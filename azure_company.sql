-- Configuração inicial
CREATE SCHEMA IF NOT EXISTS azure_company;
USE azure_company;

-- Removendo restrições de chaves estrangeiras temporariamente
SET FOREIGN_KEY_CHECKS = 0;

-- Drop de tabelas existentes
DROP TABLE IF EXISTS works_on;
DROP TABLE IF EXISTS dependent;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS dept_locations;
DROP TABLE IF EXISTS departament;
DROP TABLE IF EXISTS employee;

SET FOREIGN_KEY_CHECKS = 1;

-- Criação de tabelas
CREATE TABLE employee (
    Ssn CHAR(9) NOT NULL, 
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    FullName VARCHAR(50) AS (CONCAT(Fname, ' ', Lname)) STORED, -- Mescla do nome completo
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR,
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn)
);

CREATE TABLE departament (
    Dnumber INT NOT NULL,
    Dname VARCHAR(15) NOT NULL,
    LocationInfo VARCHAR(50),
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept_unique CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE(Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
);


CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
);

CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    FOREIGN KEY (Dnum) REFERENCES departament(Dnumber)
);

CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR,
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);

-- Inserção de dados em employee (primeiro)
INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES
    ('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, '333445555', 5),
    ('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, '888665555', 5),
    ('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, '987654321', 4),
    ('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, '888665555', 4),
    ('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, '333445555', 5),
    ('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, '333445555', 5),
    ('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, '987654321', 4),
    ('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);


-- Inserção de dados em departament (depois)
INSERT INTO departament (Dnumber, Dname, Mgr_ssn, Mgr_start_date, Dept_create_date, LocationInfo) VALUES
    (1, 'Headquarters', '888665555', '1981-06-19', '1980-06-19', 'Headquarters - Houston'),
    (4, 'Administration', '987654321', '1995-01-01', '1994-01-01', 'Administration - Stafford'),
    (5, 'Research', '333445555', '1988-05-22', '1986-05-22', 'Research - Bellaire');

INSERT INTO dept_locations (Dnumber, Dlocation) VALUES
    (5, 'Sugarland'), 
    (5, 'Houston');

-- Inserção de dados em outras tabelas
INSERT INTO dependent (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
    ('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
    ('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
    ('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
    ('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
    ('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
    ('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
    ('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

INSERT INTO project (Pname, Pnumber, Plocation, Dnum) VALUES
    ('ProductX', 1, 'Bellaire', 5),
    ('ProductY', 2, 'Sugarland', 5),
    ('ProductZ', 3, 'Houston', 5),
    ('Computerization', 10, 'Stafford', 4),
    ('Reorganization', 20, 'Houston', 1),
    ('Newbenefits', 30, 'Stafford', 4);

INSERT INTO works_on (Essn, Pno, Hours) VALUES
    ('123456789', 1, 32.5),
    ('123456789', 2, 7.5),
    ('666884444', 3, 40.0),
    ('453453453', 1, 20.0),
    ('453453453', 2, 20.0),
    ('333445555', 2, 10.0),
    ('333445555', 3, 10.0),
    ('333445555', 10, 10.0),
    ('333445555', 20, 10.0),
    ('999887777', 30, 30.0),
    ('999887777', 10, 10.0),
    ('987987987', 10, 35.0),
    ('987987987', 30, 5.0),
    ('987654321', 30, 20.0),
    ('987654321', 20, 15.0),
    ('888665555', 20, 0.0);

-- Consulta de validação de mesclas
SELECT * FROM employee_with_manager;
SELECT * FROM department_with_location;
SELECT * FROM employee WHERE Ssn IN ('888665555', '987654321', '333445555');
SELECT * FROM employee;

-- Correção da junção implícita e uso de LEFT JOIN para contar dependentes
SELECT e.Ssn, COUNT(d.Essn) AS DependentCount
FROM employee e
LEFT JOIN dependent d ON e.Ssn = d.Essn
GROUP BY e.Ssn
LIMIT 0, 1000;

SELECT * FROM dependent;

-- Buscar informações de um funcionário específico
SELECT Bdate, Address FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

-- Buscar departamento específico
SELECT * FROM departament WHERE Dname = 'Research';

-- Usar JOIN para melhorar legibilidade e eficiência
SELECT Fname, Lname, Address
FROM employee e
JOIN departament d ON d.Dnumber = e.Dno
WHERE d.Dname = 'Research';

SELECT * FROM project;

-- Recuperando informações dos departamentos presentes em Stafford
SELECT d.Dname AS Department, d.Mgr_ssn AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
WHERE l.Dlocation = 'Stafford';

-- Correção para usar CONCAT no MySQL
SELECT d.Dname AS Department, CONCAT(e.Fname, ' ', e.Lname) AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON e.Ssn = d.Mgr_ssn
WHERE l.Dlocation = 'Stafford';

-- Recuperando informações dos projetos em Stafford
SELECT * 
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
WHERE p.Plocation = 'Stafford';

-- Recuperando informações sobre departamentos e projetos localizados em Stafford
SELECT p.Pnumber, p.Dnum, e.Lname, e.Address, e.Bdate
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
JOIN employee e ON e.Ssn = d.Mgr_ssn
WHERE p.Plocation = 'Stafford';

SELECT * FROM employee WHERE Dno IN (3, 6, 9);

-- Operadores lógicos
SELECT Bdate, Address
FROM EMPLOYEE
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

SELECT Fname, Lname, Address
FROM EMPLOYEE e
JOIN departament d ON d.Dnumber = e.Dno
WHERE d.Dname = 'Research';



-- Expressões e alias
SELECT Fname, Lname, Salary, Salary * 0.011 AS INSS FROM employee;
SELECT Fname, Lname, Salary, ROUND(Salary * 0.011, 2) AS INSS FROM employee;

-- Aumento de salário para gerentes no projeto "ProductX"
SELECT e.Fname, e.Lname, 1.1 * e.Salary AS increased_sal
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'ProductX';

-- Concatenando e fornecendo alias
SELECT d.Dname AS Department, CONCAT(e.Fname, ' ', e.Lname) AS Manager
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON e.Ssn = d.Mgr_ssn;

-- Recuperando dados dos empregados que trabalham para o departamento de pesquisa
SELECT e.Fname, e.Lname, e.Address
FROM employee e
JOIN departament d ON d.Dnumber = e.Dno
WHERE d.Dname = 'Research';

-- Definindo alias para legibilidade da consulta
SELECT e.Fname, e.Lname, e.Address 
FROM employee e
JOIN departament d ON d.Dnumber = e.Dno
WHERE d.Dname = 'Research';

-- Dependentes de cada funcionário
SELECT e.Ssn, COUNT(d.Essn) AS DependentCount
FROM employee e
LEFT JOIN dependent d ON e.Ssn = d.Essn
GROUP BY e.Ssn

SHOW TABLES FROM azure_company;
SELECT * FROM azure_company.employee;
