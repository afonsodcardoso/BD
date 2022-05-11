CREATE SCHEMA company;
GO

CREATE TABLE company.employee (
	Fname 		VARCHAR(10) 	NOT NULL,
	Minit 		CHAR(1),
	Lname 		VARCHAR(10) 	NOT NULL,
	Ssn   		INT 			NOT NULL, 
	Bdate 		DATE, 
	Address		VARCHAR(20), 
	Sex			CHAR(1), 
	Salary		INT, 
	Super_ssn	INT,
	Dno 		INT 			NOT NULL,
	PRIMARY KEY(Ssn),
	FOREIGN KEY(Super_ssn) REFERENCES company.employee(Ssn) 
);

CREATE TABLE company.department (
	Dname 			VARCHAR(20)	NOT NULL,
	Dnumber 		INT 		NOT NULL,
	Mgr_ssn 		INT,
	Mgr_start_date 	DATE,
	PRIMARY KEY(Dnumber),
	FOREIGN KEY(Mgr_ssn) REFERENCES company.employee(Ssn)
);

CREATE TABLE company.dependent (
	Essn 			INT 		NOT NULL,
	Dependent_name 	VARCHAR(20) NOT NULL,
	Sex 			CHAR(1),
	Bdate 			DATE,
	Relationship	VARCHAR(10)	NOT NULL,
	PRIMARY KEY(Essn, Dependent_name),
	FOREIGN KEY(Essn) REFERENCES company.employee(Ssn)
);

CREATE TABLE company.dept_location (
	Dnumber		INT 			NOT NULL,
	Dlocation 	VARCHAR(20)		NOT NULL,
	PRIMARY KEY(Dnumber, Dlocation),
	FOREIGN KEY(Dnumber) REFERENCES company.department(Dnumber)
);

CREATE TABLE company.project (
	Pname 		VARCHAR(20)		NOT NULL,
	Pnumber 	INT 			NOT NULL,
	Plocation 	VARCHAR(20),
	Dnum 		INT 			NOT NULL,
	PRIMARY KEY(Pnumber),
	FOREIGN KEY(Dnum) REFERENCES company.department(Dnumber)
);

CREATE TABLE company.works_on (
	Essn 	INT					NOT NULL,
	Pno 	INT 				NOT NULL,
	Hours	INT,
	PRIMARY KEY(Essn, Pno),
	FOREIGN KEY(Essn) REFERENCES company.employee(Ssn),
	FOREIGN KEY(Pno) REFERENCES company.project(Pnumber)
);

-----Inserir valores da tabela employee
INSERT INTO company.employee VALUES ('Paula', 'A', 'Sousa', 183623612, '20010811', 'Rua da FRENTE', 'F', 1450, NULL, 3);
INSERT INTO company.employee VALUES ('Carlos', 'D', 'Gomes', 21312332, '20000101', 'Rua XPTO', 'M', 1200, NULL, 1);
INSERT INTO company.employee VALUES ('Juliana', 'A', 'Amaral', 321233765, '19800811', 'Rua BZZZZ', 'F', 1350, NULL, 3);
INSERT INTO company.employee VALUES ('Maria', 'I', 'Pereira', 342343434, '20010501', 'Rua JANOTA', 'F', 1250, 21312332, 2);
INSERT INTO company.employee VALUES ('Joao', 'G', 'Costa', 41124234, '20010101', 'Rua YGZ', 'M', 1300, 21312332, 2);
INSERT INTO company.employee VALUES ('Ana', 'L', 'Silva', 12652121, '19900303', 'Rua ZIG ZAG', 'F', 1400, 21312332, 2);

-----Inserir valores da tabela department
INSERT INTO company.department VALUES ('Investigacao', 1, 21312332, '20100802');
INSERT INTO company.department VALUES ('Comercial', 2, 321233765, '20130516');
INSERT INTO company.department VALUES ('Logistica', 3, 41124234, '20130516');
INSERT INTO company.department VALUES ('Recursos Humanos', 4, 12652121, '20140402');
INSERT INTO company.department VALUES ('Desporto', 5, NULL, NULL);

-----Inserir valores da tabela dependent
INSERT INTO company.dependent VALUES (21312332, 'Joana Costa', 'F', '20080401', 'Filho');
INSERT INTO company.dependent VALUES (21312332, 'Maria Costa', 'F', '19901005', 'Neto');
INSERT INTO company.dependent VALUES (21312332, 'Rui Costa', 'M', '20000804', 'Neto');
INSERT INTO company.dependent VALUES (321233765, 'Filho Lindo', 'M', '20010222', 'Filho');
INSERT INTO company.dependent VALUES (342343434, 'Rosa Lima', 'F', '20060311', 'Filho');
INSERT INTO company.dependent VALUES (41124234, 'Ana Sousa', 'F', '20070413', 'Neto');
INSERT INTO company.dependent VALUES (41124234, 'Gaspar Pinto', 'M', '20060208', 'Sobrinho');

-----Inserir valores da tabela dept_location
INSERT INTO company.dept_location VALUES (2, 'Aveiro');
INSERT INTO company.dept_location VALUES (3, 'Coimbra');

-----Inserir valores da tabela project
INSERT INTO company.project VALUES ('Aveiro Digital', 1, 'Aveiro', 3);
INSERT INTO company.project VALUES ('BD Open Day', 2, 'Espinho', 2);
INSERT INTO company.project VALUES ('Dicoogle', 3, 'Aveiro', 3);
INSERT INTO company.project VALUES ('GOPACS', 4, 'Aveiro', 3);

-----Inserir valores da tabela works_on
INSERT INTO company.works_on VALUES (183623612, 1, 20);
INSERT INTO company.works_on VALUES (183623612, 3, 10);
INSERT INTO company.works_on VALUES (21312332, 1, 20);
INSERT INTO company.works_on VALUES (321233765, 1, 25);
INSERT INTO company.works_on VALUES (342343434, 1, 20);
INSERT INTO company.works_on VALUES (342343434, 4, 25);
INSERT INTO company.works_on VALUES (41124234, 2, 20);
INSERT INTO company.works_on VALUES (41124234, 3, 30);