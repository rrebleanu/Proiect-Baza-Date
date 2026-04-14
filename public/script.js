async function renderTable(url) {
    const area = document.getElementById('resultArea');
    try {
        const res = await fetch(url);
        const data = await res.json();
        
        if (!data || data.length === 0) {
            area.innerHTML = "<p>Nu există date.</p>";
            return;
        }

        const cols = Object.keys(data[0]);
        const idCol = cols[0]; 

        generateInsertForm(cols);

        let html = `<table><thead><tr>${cols.map(c => `<th>${c}</th>`).join('')}<th>Acțiuni</th></tr></thead><tbody>`;
        
        data.forEach(row => {
            html += '<tr>';
            cols.forEach(c => {
                let val = row[c] || '';
                
               
                if (typeof val === 'string' && val.includes('T') && val.length > 10) {
                    val = val.split('T')[0];
                }
                
                html += `<td>${val}</td>`;
            });
            
            html += `<td>
                <button class="btn-edit" onclick="editRecord('${idCol}', '${row[idCol]}')">Editează</button>
                <button class="btn-del" onclick="deleteRecord('${idCol}', '${row[idCol]}')">Șterge</button>
            </td></tr>`;
        });
        area.innerHTML = html + "</tbody></table>";
    } catch (err) { area.innerHTML = "Eroare: " + err.message; }
}

function generateInsertForm(cols) {
    const table = document.getElementById('tableSelect').value;
    let insertDiv = document.getElementById('insertContainer');
    if(!insertDiv) {
        insertDiv = document.createElement('div');
        insertDiv.id = 'insertContainer';
        insertDiv.className = 'filters';
        document.querySelector('.container').insertBefore(insertDiv, document.getElementById('resultArea'));
    }

    insertDiv.innerHTML = `<h3>Adaugă în ${table}</h3><div style="display:flex; flex-wrap:wrap; gap:10px;">` + 
        cols.map(c => `<input type="text" class="ins-input" data-col="${c}" placeholder="${c}...">`).join('') +
        `</div><button class="btn-query" onclick="saveNewRecord()">Salvează Înregistrarea</button>`;
}

async function saveNewRecord() {
    const table = document.getElementById('tableSelect').value;
    const inputs = document.querySelectorAll('.ins-input');
    const body = {};
    inputs.forEach(i => { if(i.value) body[i.getAttribute('data-col')] = i.value; });

    const res = await fetch(`http://localhost:3000/api/tabel/${table}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });

    if (res.ok) { alert("Înregistrare adăugată!"); loadData(); }
    else { alert("Eroare: " + await res.text()); }
}

function loadData() {
    const table = document.getElementById('tableSelect').value;
    const sort = document.getElementById('sortBy').value;
    const order = document.getElementById('orderDir').value;
    renderTable(`http://localhost:3000/api/tabel/${table}?sortBy=${sort}&order=${order}`);
}

async function editRecord(idCol, idVal) {
    const table = document.getElementById('tableSelect').value;
    const coloana = prompt("Ce coloană vrei să modifici? (Ex: SALARIU, STATUS, NUME)");
    if (!coloana) return;
    const nouaValoare = prompt(`Introdu noua valoare pentru ${coloana}:`);
    if (nouaValoare === null) return;

    const res = await fetch(`http://localhost:3000/api/modifica/${table}/${idCol}/${idVal}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ coloana: coloana.toUpperCase(), valoareNoua: nouaValoare })
    });
    if (res.ok) { alert("Modificare reușită!"); loadData(); }
    else { alert("Eroare: " + await res.text()); }
}

async function deleteRecord(idCol, idVal) {
    if (!confirm("Sigur ștergi?")) return;
    const table = document.getElementById('tableSelect').value;
    await fetch(`http://localhost:3000/api/tabel/${table}/${idCol}/${idVal}`, { method: 'DELETE' });
    loadData();
}

const runSpecial = (type) => renderTable(`http://localhost:3000/api/${type}`);
const runView = (name) => renderTable(`http://localhost:3000/api/view/${name}`);