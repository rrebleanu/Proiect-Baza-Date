const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

const dbConfig = {
    user: "C##ROBERT_DB",
    password: "Fotbal_2026!", 
    connectString: "localhost:1521/xe"
};

async function runQuery(query, params = []) {
    let conn;
    try {
        conn = await oracledb.getConnection(dbConfig);
        
        await conn.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD'");
        
        const result = await conn.execute(query, params, { 
            outFormat: oracledb.OUT_FORMAT_OBJECT, 
            autoCommit: true 
        });
        return result.rows || result;
    } finally { 
        if (conn) await conn.close(); 
    }
}

// (a) Listare și Sortare 
app.get('/api/tabel/:nume', async (req, res) => {
    const { sortBy, order } = req.query;
    let sql = `SELECT * FROM ${req.params.nume}`;
    if (sortBy) sql += ` ORDER BY ${sortBy} ${order || 'ASC'}`;
    try { res.json(await runQuery(sql)); }
    catch (err) { res.status(500).send(err.message); }
});

// (b) Ștergere 
app.delete('/api/tabel/:nume/:idCol/:idVal', async (req, res) => {
    const sql = `DELETE FROM ${req.params.nume} WHERE ${req.params.idCol} = :id`;
    try { await runQuery(sql, [req.params.idVal]); res.json({ success: true }); }
    catch (err) { res.status(500).send(err.message); }
});

app.put('/api/modifica/:tabel/:idCol/:idVal', async (req, res) => {
    const { coloana, valoareNoua } = req.body;
    const sql = `UPDATE ${req.params.tabel} SET ${coloana} = :1 WHERE ${req.params.idCol} = :2`;
    try {
        await runQuery(sql, [valoareNoua, req.params.idVal]);
        res.json({ success: true });
    } catch (err) { res.status(500).send(err.message); }
});

// (c, d, f)
app.get('/api/complex', async (req, res) => {
    const sql = `SELECT A.NUME, A.PRENUME, EC.NUME_ECHIPA, E.DENUMIRE FROM ANGAJAT A 
                 JOIN ECHIPA EC ON A.ID_ECHIPA = EC.ID_ECHIPA 
                 JOIN ETAPA E ON EC.ID_ECHIPA = E.ID_ECHIPA 
                 WHERE E.STATUS = 'Finalizata' AND A.SALARIU > 5000`;
    res.json(await runQuery(sql));
});

app.get('/api/grupare', async (req, res) => {
    const sql = `SELECT ID_ECHIPA, COUNT(ID_ANGAJAT) AS NR FROM ANGAJAT 
                 GROUP BY ID_ECHIPA HAVING AVG(SALARIU) > 4000`;
    res.json(await runQuery(sql));
});

app.get('/api/view/:nume', async (req, res) => {
    res.json(await runQuery(`SELECT * FROM ${req.params.nume}`));
});


app.post('/api/tabel/:nume', async (req, res) => {
    const tabel = req.params.nume;
    const coloane = Object.keys(req.body).join(', ');
    const placeHolders = Object.keys(req.body).map((_, i) => `:${i + 1}`).join(', ');
    
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

app.listen(3000, () => console.log('Server pornit pe http://localhost:3000'));