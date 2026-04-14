// Load environment variables from the .env file (Security)
require('dotenv').config();

// Import required modules
const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');

// Initialize the Express application
const app = express();

// Middleware setup
app.use(cors()); // Allow cross-origin requests
app.use(express.json()); // Parse incoming JSON payloads
app.use(express.static('public')); // Serve static files from the 'public' folder

// Database configuration using environment variables from .env
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASS, 
    connectString: process.env.DB_STRING
};

// Helper function to execute Oracle DB queries
async function runQuery(query, params = []) {
    let conn;
    try {
        // Establish database connection
        conn = await oracledb.getConnection(dbConfig);
        
        // Set date format for the current session
        await conn.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD'");
        
        // Execute the SQL query
        const result = await conn.execute(query, params, { 
            outFormat: oracledb.OUT_FORMAT_OBJECT, // Return rows as JS objects
            autoCommit: true // Automatically commit changes (INSERT/UPDATE/DELETE)
        });
        return result.rows || result;
    } finally { 
        // Ensure the connection is always closed
        if (conn) await conn.close(); 
    }
}

// --- API ROUTES ---

// (a) List and Sort: GET data from any table
app.get('/api/tabel/:nume', async (req, res) => {
    const { sortBy, order } = req.query;
    let sql = `SELECT * FROM ${req.params.nume}`;
    
    // Append ORDER BY clause if requested by the client
    if (sortBy) sql += ` ORDER BY ${sortBy} ${order || 'ASC'}`;
    
    try { res.json(await runQuery(sql)); }
    catch (err) { res.status(500).send(err.message); }
});

// (b) Delete: Remove a specific row from a table
app.delete('/api/tabel/:nume/:idCol/:idVal', async (req, res) => {
    const sql = `DELETE FROM ${req.params.nume} WHERE ${req.params.idCol} = :id`;
    try { 
        await runQuery(sql, [req.params.idVal]); 
        res.json({ success: true }); 
    } catch (err) { res.status(500).send(err.message); }
});

// Update: Modify a specific column for a specific row
app.put('/api/modifica/:tabel/:idCol/:idVal', async (req, res) => {
    const { coloana, valoareNoua } = req.body;
    const sql = `UPDATE ${req.params.tabel} SET ${coloana} = :1 WHERE ${req.params.idCol} = :2`;
    try {
        await runQuery(sql, [valoareNoua, req.params.idVal]);
        res.json({ success: true });
    } catch (err) { res.status(500).send(err.message); }
});

// (c, d, f) Complex query with JOINs and conditions
app.get('/api/complex', async (req, res) => {
    const sql = `SELECT A.NUME, A.PRENUME, EC.NUME_ECHIPA, E.DENUMIRE FROM ANGAJAT A 
                 JOIN ECHIPA EC ON A.ID_ECHIPA = EC.ID_ECHIPA 
                 JOIN ETAPA E ON EC.ID_ECHIPA = E.ID_ECHIPA 
                 WHERE E.STATUS = 'Finalizata' AND A.SALARIU > 5000`;
    res.json(await runQuery(sql));
});

// Grouping query with aggregate functions
app.get('/api/grupare', async (req, res) => {
    const sql = `SELECT ID_ECHIPA, COUNT(ID_ANGAJAT) AS NR FROM ANGAJAT 
                 GROUP BY ID_ECHIPA HAVING AVG(SALARIU) > 4000`;
    res.json(await runQuery(sql));
});

// Fetch data from a database View
app.get('/api/view/:nume', async (req, res) => {
    res.json(await runQuery(`SELECT * FROM ${req.params.nume}`));
});

// Insert: Add a new row to any table dynamically
app.post('/api/tabel/:nume', async (req, res) => {
    const tabel = req.params.nume;
    
    // Extract column names and generate bind variables (e.g., :1, :2)
    const coloane = Object.keys(req.body).join(', ');
    const placeHolders = Object.keys(req.body).map((_, i) => `:${i + 1}`).join(', ');
    
    // Format values, cleaning up ISO date strings if necessary
    const valori = Object.values(req.body).map(val => {
        if (typeof val === 'string' && val.includes('T') && val.length > 15) {
            return val.split('T')[0]; 
        }
        return val;
    });

    const sql = `INSERT INTO ${tabel} (${coloane}) VALUES (${placeHolders})`;

    try {
        await runQuery(sql, valori);
        res.json({ success: true });
    } catch (err) {
        res.status(400).send(err.message);
    }
});

// Start the Express server
app.listen(3000, () => console.log('Server pornit pe http://localhost:3000'));