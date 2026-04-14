DROP TABLE GESTIUNE_UTILAJ CASCADE CONSTRAINTS;
DROP TABLE ETAPA_MATERIAL CASCADE CONSTRAINTS;
DROP TABLE COST CASCADE CONSTRAINTS;
DROP TABLE ANGAJAT CASCADE CONSTRAINTS;
DROP TABLE ETAPA CASCADE CONSTRAINTS;
DROP TABLE MATERIAL CASCADE CONSTRAINTS;
DROP TABLE UTILAJ CASCADE CONSTRAINTS;
DROP TABLE ECHIPA CASCADE CONSTRAINTS;
DROP TABLE FURNIZOR CASCADE CONSTRAINTS;


--CREARE TABELE

CREATE TABLE ETAPA (
    numar_etapa NUMBER(5) PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL,
    data_inceput DATE,
    data_finalizare DATE,
    status VARCHAR2(20)
);

ALTER TABLE ETAPA ADD id_echipa NUMBER(5) NOT NULL;
ALTER TABLE ETAPA ADD CONSTRAINT CK_ETAPA_STATUS CHECK (status IN ('Planificata', 'In Lucru', 'Finalizata'));

CREATE TABLE MATERIAL (
    id_material NUMBER(5) PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL,
    unitate_masura VARCHAR2(10),
    pret_unitar NUMBER(10,2) NOT NULL,
    cantitate_stoc NUMBER(10,2) DEFAULT 0
);

ALTER TABLE MATERIAL ADD id_furnizor NUMBER(5) NOT NULL;
ALTER TABLE MATERIAL ADD CONSTRAINT CK_MATERIAL_PRET CHECK (pret_unitar > 0);

CREATE TABLE FURNIZOR (
    id_furnizor NUMBER(5) PRIMARY KEY,
    nume_firma VARCHAR2(50) NOT NULL,
    cui VARCHAR2(20) NOT NULL,
    adresa VARCHAR2(100),
    telefon VARCHAR2(15)
);

ALTER TABLE FURNIZOR ADD CONSTRAINT UQ_FURNIZOR_CUI UNIQUE (cui);
ALTER TABLE FURNIZOR ADD CONSTRAINT CK_FURNIZOR_TEL CHECK (LENGTH(telefon) >= 10);

CREATE TABLE ECHIPA (
    id_echipa NUMBER(5) PRIMARY KEY,
    nume_echipa VARCHAR2(30) NOT NULL,
    specializare VARCHAR2(30) NOT NULL,
    sef_echipa VARCHAR2(50)
);

CREATE TABLE COST (
    id_factura_cost NUMBER(5) PRIMARY KEY,
    numar_factura VARCHAR2(20) NOT NULL,
    valoare_totala NUMBER(12,2) NOT NULL,
    data_plata DATE DEFAULT SYSDATE
);

ALTER TABLE COST ADD id_material NUMBER(5) NOT NULL;
ALTER TABLE COST ADD CONSTRAINT UQ_COST_FACTURA UNIQUE (numar_factura);
ALTER TABLE COST ADD CONSTRAINT CK_COST_VALOARE CHECK (valoare_totala > 0);

CREATE TABLE ANGAJAT (
    id_angajat NUMBER(5) PRIMARY KEY,
    nume VARCHAR2(30) NOT NULL,
    prenume VARCHAR2(30) NOT NULL,
    functie VARCHAR2(30),
    salariu NUMBER(8,2),
    data_angajarii DATE DEFAULT SYSDATE
);

ALTER TABLE ANGAJAT ADD id_echipa NUMBER(5) NOT NULL;
ALTER TABLE ANGAJAT ADD CONSTRAINT CK_ANGAJAT_SALARIU CHECK (salariu > 0);

CREATE TABLE UTILAJ (
    id_utilaj NUMBER(5) PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL,
    tip_utilaj VARCHAR2(20),
    valoare_inventar NUMBER(10,2),
    stare VARCHAR2(20)
);

ALTER TABLE UTILAJ ADD CONSTRAINT CK_UTILAJ_STARE CHECK (stare IN ('Functional', 'In Reparatie', 'Casat'));

ALTER TABLE ETAPA ADD CONSTRAINT FK_ETAPA_ECHIPA FOREIGN KEY (id_echipa) REFERENCES ECHIPA(id_echipa) ON DELETE CASCADE;
ALTER TABLE MATERIAL ADD CONSTRAINT FK_MATERIAL_FURNIZOR FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor) ON DELETE CASCADE;
ALTER TABLE COST ADD CONSTRAINT FK_COST_MATERIAL FOREIGN KEY (id_material) REFERENCES MATERIAL(id_material) ON DELETE CASCADE;
ALTER TABLE ANGAJAT ADD CONSTRAINT FK_ANGAJAT_ECHIPA FOREIGN KEY (id_echipa) REFERENCES ECHIPA(id_echipa) ON DELETE CASCADE;

CREATE TABLE ETAPA_MATERIAL (
    numar_etapa NUMBER(5) NOT NULL,
    id_material NUMBER(5) NOT NULL,
    cantitate_necesara NUMBER(10,2) NOT NULL,
    CONSTRAINT PK_ETAPA_MATERIAL PRIMARY KEY (numar_etapa, id_material)
);

ALTER TABLE ETAPA_MATERIAL ADD CONSTRAINT FK_EM_ETAPA FOREIGN KEY (numar_etapa) REFERENCES ETAPA(numar_etapa) ON DELETE CASCADE;
ALTER TABLE ETAPA_MATERIAL ADD CONSTRAINT FK_EM_MATERIAL FOREIGN KEY (id_material) REFERENCES MATERIAL(id_material) ON DELETE CASCADE;

CREATE TABLE GESTIUNE_UTILAJ (
    id_angajat NUMBER(5) NOT NULL,
    id_utilaj NUMBER(5) NOT NULL,
    data_alocarii DATE DEFAULT SYSDATE,
    CONSTRAINT PK_GESTIUNE_UTILAJ PRIMARY KEY (id_angajat, id_utilaj)
);

ALTER TABLE GESTIUNE_UTILAJ ADD CONSTRAINT FK_GU_ANGAJAT FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat) ON DELETE CASCADE;
ALTER TABLE GESTIUNE_UTILAJ ADD CONSTRAINT FK_GU_UTILAJ FOREIGN KEY (id_utilaj) REFERENCES UTILAJ(id_utilaj) ON DELETE CASCADE;



--INSERARI DATE

INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (1, 'DRAXON ONE SRL', 'RO44785959', 'Str. Ion Sugariu 6, Baia Mare', '0745535455');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (2, 'STEELHAUS SRL', 'RO1771593', 'Str. Independentei 107, Aricestii Rahtivani', '0244123456');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (3, 'MARINOS CHATTALAS', 'CY10203040', 'Nicosia, Cyprus', '0035799123');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (4, 'HOLCIM ROMANIA SA', 'RO1225301', 'Calea Floreasca 169, Bucuresti', '0212315050');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (5, 'TARGET SPORT RO', 'RO2884102', 'Soseaua Odaii 20, Otopeni', '0722100200');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (6, 'QUARTZ MATRIX', 'RO6543210', 'B-dul Chimiei 12, Iasi', '0232250150');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (7, 'ELBA TIMISOARA', 'RO1587630', 'Str. Paul Morand 135, Timisoara', '0256444333');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (8, 'DRENAJ PRO INSTAL', 'RO1122334', 'Str. Libertatii 88, Ploiesti', '0744111222');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (9, 'GEOSYNTHETICS SRL', 'RO9988776', 'Str. Uzinei 1, Cluj-Napoca', '0264888999');
INSERT INTO FURNIZOR (id_furnizor, nume_firma, cui, adresa, telefon) VALUES (10, 'AGRO-TURF SERVICES', 'RO7766554', 'Str. Campului 14, Oradea', '0755999888');

INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (1, 'Echipa Terasament', 'Infrastructura', 'Popescu George');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (2, 'Echipa Drenaj', 'Instalatii', 'Lupu Ion');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (3, 'Echipa Montaj Gazon', 'Finisaje Sportive', 'Radu Alin');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (4, 'Echipa Nocturna', 'Electrice', 'Stoica Dan');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (5, 'Echipa Garduri', 'Metalice', 'Victor Lupu');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (6, 'Echipa Nivelare Laser', 'Infrastructura', 'Mihai Voicu');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (7, 'Echipa Logistica', 'Transport', 'Stan Mihai');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (8, 'Echipa Mentenanta', 'Service', 'Dinu Paul');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (9, 'Echipa Fundatii', 'Betonare', 'Dumitru Matei');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (10, 'Echipa Finisaje', 'Vopsitorie', 'Enache Alin');
INSERT INTO ECHIPA (id_echipa, nume_echipa, specializare, sef_echipa) VALUES (11, 'Birou Tehnic', 'Proiectare', 'Arh. Dumitrescu Laura');

INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (1, 'Panou Gard Verde Dublu Fir', 'BUC', 237.90, 150, 2);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (2, 'Transport Materiale Grele', 'BUC', 247.93, 10, 2);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (3, 'Gazon Sintetic MS-PRO 50mm', 'MP', 72.75, 2500, 3);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (4, 'Linii fotbal si adeziv', 'SET', 12.50, 972, 3);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (5, 'Proiectoare LED ECO 300W', 'BUC', 495.00, 24, 3);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (6, 'Plasa protectie polietilena', 'MP', 11.50, 600, 3);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (7, 'Granule Cauciuc SBR', 'TONA', 1250.00, 60, 5);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (8, 'Nisip Quartos Uscat', 'TONA', 185.00, 100, 10);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (9, 'Ciment Structo Plus', 'SACI', 38.00, 300, 4);
INSERT INTO MATERIAL (id_material, denumire, unitate_masura, pret_unitar, cantitate_stoc, id_furnizor) VALUES (10, 'Piatra Concassata 0-63', 'TONA', 75.00, 1200, 4);

INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (1, 'Excavator Volvo EC220', 'Greu', 450000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (2, 'Buldozer Cat D6', 'Greu', 380000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (3, 'Cilindru Compactor Hamm', 'Terasament', 120000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (4, 'Incarcator Bobcat T590', 'Usor', 85000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (5, 'Masina Imprastiat SandMatic', 'Special', 45000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (6, 'Autobasculanta MAN 8x4', 'Transport', 280000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (7, 'Masina Periat TurfCare', 'Intretinere', 18000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (8, 'Generator 60kVA', 'Electric', 25000, 'In Reparatie');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (9, 'Nacela Haulotte', 'Lucru Inaltime', 95000, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (10, 'Mini-excavator Yanmar', 'Usor', 65000, 'Casat');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (11, 'Nivela Laser Rotativa', 'Echipament', 3500, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (12, 'Multimetru Digital Profesional', 'Scule', 850, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (13, 'Trusa Scule Izolate 1000V', 'Scule', 1200, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (14, 'Dispozitiv Masura Rezistenta Sol', 'Echipament', 2200, 'Functional');
INSERT INTO UTILAJ (id_utilaj, denumire, tip_utilaj, valoare_inventar, stare) VALUES (15, 'Ciocan Rotopercutor SDS-Max', 'Scule', 2800, 'Functional');

INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (101, 'Ionescu', 'Mihai', 'Inginer Sef', 8500, TO_DATE('2024-01-10','YYYY-MM-DD'), 1);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (102, 'Vasile', 'Ionut', 'Operator Greu', 5800, TO_DATE('2024-01-15','YYYY-MM-DD'), 1);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (103, 'Miron', 'Andrei', 'Tehnician Hidro', 4900, TO_DATE('2024-02-01','YYYY-MM-DD'), 2);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (104, 'Popa', 'Claudiu', 'Lucrator montaj gazon sintetic', 5200, TO_DATE('2024-02-10','YYYY-MM-DD'), 3);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (108, 'Gheorghe', 'Vasile', 'Lucrator montaj gazon sintetic', 5300, TO_DATE('2024-04-10','YYYY-MM-DD'), 3);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (105, 'Dima', 'Cristian', 'Electrician', 5500, TO_DATE('2024-03-01','YYYY-MM-DD'), 4);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (110, 'Nita', 'Alexandru', 'Electrician', 5400, TO_DATE('2024-05-15','YYYY-MM-DD'), 4);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (106, 'Lazar', 'Stefan', 'Sudor Structuri', 5100, TO_DATE('2024-03-15','YYYY-MM-DD'), 5);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (107, 'Stoica', 'Andrei', 'Sofer Autobasculanta', 4500, TO_DATE('2024-04-01','YYYY-MM-DD'), 7);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (109, 'Marin', 'Daniel', 'Muncitor Calificat', 4000, TO_DATE('2024-05-01','YYYY-MM-DD'), 6);
INSERT INTO ANGAJAT (id_angajat, nume, prenume, functie, salariu, data_angajarii, id_echipa) VALUES (111, 'Dumitrescu', 'Laura', 'Arhitect Sef', 9500, TO_DATE('2024-01-05','YYYY-MM-DD'), 11);

INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (1, 'Proiectare Teren 40x20m', TO_DATE('2026-02-15','YYYY-MM-DD'), TO_DATE('2026-02-28','YYYY-MM-DD'), 'Finalizata', 11);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (2, 'Pregatire si Decopertare Sol', TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-05','YYYY-MM-DD'), 'Finalizata', 1);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (3, 'Sapatura Santuri Drenaj 80cm', TO_DATE('2026-03-06','YYYY-MM-DD'), TO_DATE('2026-03-15','YYYY-MM-DD'), 'Finalizata', 2);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (4, 'Asezare Straturi Agregate', TO_DATE('2026-03-16','YYYY-MM-DD'), TO_DATE('2026-03-25','YYYY-MM-DD'), 'Finalizata', 1);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (5, 'Nivelare Laser Finala', TO_DATE('2026-03-26','YYYY-MM-DD'), TO_DATE('2026-03-30','YYYY-MM-DD'), 'In Lucru', 6);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (6, 'Fundatii Stalpi Nocturna', TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-05','YYYY-MM-DD'), 'Planificata', 9);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (7, 'Montaj Structura Imprejmuire', TO_DATE('2026-04-06','YYYY-MM-DD'), TO_DATE('2026-04-15','YYYY-MM-DD'), 'Planificata', 5);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (8, 'Lipire Covor Gazon', TO_DATE('2026-04-16','YYYY-MM-DD'), TO_DATE('2026-04-20','YYYY-MM-DD'), 'Planificata', 3);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (9, 'Infiltrare Nisip si Granule', TO_DATE('2026-04-21','YYYY-MM-DD'), TO_DATE('2026-04-25','YYYY-MM-DD'), 'Planificata', 3);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (10, 'Montaj Corpuri Iluminat LED', TO_DATE('2026-04-26','YYYY-MM-DD'), TO_DATE('2026-04-28','YYYY-MM-DD'), 'Planificata', 4);
INSERT INTO ETAPA (numar_etapa, denumire, data_inceput, data_finalizare, status, id_echipa) VALUES (11, 'Receptie Finala', TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-03','YYYY-MM-DD'), 'Planificata', 1);

INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (1, 'INV-STEEL-3050', 3178.60, TO_DATE('2025-09-29','YYYY-MM-DD'), 1);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (2, 'INV-MARIN-972', 70713.00, TO_DATE('2025-09-15','YYYY-MM-DD'), 3);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (3, 'INV-MARIN-LED', 11880.00, TO_DATE('2025-09-16','YYYY-MM-DD'), 5);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (4, 'INV-MARIN-NET', 6900.00, TO_DATE('2025-09-17','YYYY-MM-DD'), 6);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (5, 'INV-HOLC-400', 11400.00, SYSDATE, 9);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (6, 'INV-HOLC-500', 90000.00, SYSDATE, 10);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (7, 'INV-TARG-101', 75000.00, SYSDATE, 7);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (8, 'INV-AGRO-202', 18500.00, SYSDATE, 8);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (9, 'INV-STEEL-TRN', 247.93, SYSDATE, 2);
INSERT INTO COST (id_factura_cost, numar_factura, valoare_totala, data_plata, id_material) VALUES (10, 'INV-DRAX-3051', 2626.94, SYSDATE, 1);

INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (2, 10, 500);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (3, 10, 100);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (4, 10, 600);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (5, 8, 50);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (6, 9, 100);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (7, 1, 150);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (8, 3, 2500);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (8, 4, 972);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (9, 7, 60);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (9, 8, 120);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (10, 5, 24);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (7, 6, 600);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (2, 2, 1);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (2, 9, 20);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (3, 9, 50);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (6, 1, 10);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (11, 4, 10);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (8, 10, 10);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (9, 10, 20);
INSERT INTO ETAPA_MATERIAL (numar_etapa, id_material, cantitate_necesara) VALUES (10, 9, 5);

INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (102, 1, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (102, 2, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (101, 3, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (104, 5, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (108, 5, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (107, 6, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (105, 9, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (105, 12, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (105, 13, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (110, 8, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (110, 14, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (110, 15, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (109, 4, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (106, 9, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (102, 11, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (104, 7, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (101, 2, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (106, 8, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (107, 10, SYSDATE);
INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (101, 1, SYSDATE);
COMMIT;


-- INSERT INTO MATERIAL (ID_MATERIAL, DENUMIRE, UNITATE_MASURA, PRET_UNITAR, CANTITATE_STOC, ID_FURNIZOR) VALUES(1, 'Panou Gard Verde Dublu', 'BUC', 237, 150, 2);

-- INSERT INTO GESTIUNE_UTILAJ (id_angajat, id_utilaj, data_alocarii) VALUES (111, 11, SYSDATE);


-- ALTER TABLE MATERIAL DROP COLUMN UNITATE_MASURA;


-- ALTER TABLE MATERIAL DROP COLUMN ID_FURNIZOR CASCADE CONSTRAINTS;


-- INSERT INTO ANGAJAT (ID_ANGAJAT, NUME, PRENUME, FUNCTIE, SALARIU, DATA_ANGAJARII) VALUES 
-- (112, 'Popescu', 'Andreea', 'Secretara', 3500, 11);


