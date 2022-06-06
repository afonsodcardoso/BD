-- SQL file for the creation of the stored procedures

--a) Construa um stored procedure que aceite o ssn de um funcion�rio, que o remova da
-- tabela de funcion�rios, que remova as suas entradas da tabela works_on e que remova
-- ainda os seus dependentes. 
-- Que preocupa��es adicionais devem ter no storage procedure para al�m das referidas anteriormente?
-- Neste caso, � tamb�m necess�rio atualizar o valor do super_ssn de cada employee caso o ssn do employee
-- a ser removido coincida com o super_ssn de qualquer employee
GO
DROP PROC company.pr_exA;

GO
CREATE PROC company.pr_exA @ssn_chosen int
AS
	DELETE FROM company.employee
	WHERE employee.Ssn = @ssn_chosen; -- delete from employee table
	
	DELETE FROM company.works_on
	WHERE works_on.Essn = @ssn_chosen; -- delete from works_on table
	
	DELETE FROM company.dependent
	WHERE dependent.Essn = @ssn_chosen; -- delete from dependent table
	
	DELETE FROM company.department
	WHERE department.Mgr_ssn = @ssn_chosen;
	
	UPDATE company.employee
	SET Super_ssn = 0
	WHERE Super_ssn = @ssn_chosen;		-- modify the super_ssn of employees who have it as the ssn to be removed
--b)
--GO

--c)

--d)

--e) Crie uma UDF que, para determinado funcion�rio (ssn), devolva o nome e localiza��o
-- dos projetos em que trabalha.
GO 
DROP FUNCTION name_location;

GO
CREATE FUNCTION name_location (@ssn_chosen INT) RETURNS @table TABLE (Pname VARCHAR(20), Plocation VARCHAR(20))
AS
BEGIN
	INSERT @table SELECT Pname, Plocation
	FROM company.project, companhia.company.works_on
	WHERE Pno = Pnumber AND Essn = @ssn_chosen;

	RETURN;
END;


--f) Crie uma UDF que, para determinado departamento (dno), retorne os funcion�rios
-- com um vencimento superior � m�dia dos vencimentos desse departamento;
GO
DROP FUNCTION vencimento;

GO
CREATE FUNCTION vencimento (@dno_chosen INT) RETURNS @table TABLE (Fname VARCHAR(10), Lname VARCHAR(10), Ssn INT, Salary INT)
AS
BEGIN
	INSERT @table SELECT Fname, Lname, Ssn, Salary
	FROM company.employee JOIN(SELECT Dno, AVG(Salary) as avg_salary
	FROM company.employee, company.department WHERE Dno = Dnumber
	GROUP BY Dno) AS dep_salary
	ON employee.Dno = dep_salary.Dno AND employee.Dno = @dno_chosen AND Salary > avg_salary;

	RETURN;
END;


--g)Crie uma UDF que, para determinado departamento, retorne um record-set com os
-- projetos desse departamento. Para cada projeto devemos ter um atributo com seu o
-- or�amento mensal de m�o de obra e outra coluna com o valor acumulado do or�amento. 

GO
DROP FUNCTION employeeDeptHighAverage;

GO
CREATE FUNCTION employeeDeptHighAverage(@id_chosen INT) RETURNS @table TABLE (pname  VARCHAR(20), 
	pnumber INT, plocation VARCHAR(20), dnum INT, budget FLOAT, totalbudget FLOAT )

AS
BEGIN
	DECLARE C CURSOR
	FOR SELECT Pname, Pnumber, Plocation, Dnum, SUM((Salary * Hours * 1.0)/40) AS Budget 
            FROM company.project JOIN company.works_on ON Pnumber=Pno
            JOIN company.employee ON Essn=Ssn WHERE Dnum = @id_chosen
            GROUP BY Pnumber, Pname, Plocation, Dnum;
 
	DECLARE @pname AS VARCHAR(20), @pnumber AS INT, @plocation as VARCHAR(20), @dnum AS INT, @budget AS FLOAT, @totalbudget AS FLOAT;
	SET @totalbudget = 0;

    OPEN C;
	FETCH C INTO @pname, @pnumber, @plocation, @dnum, @budget;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @totalbudget += @budget;
		INSERT INTO @table VALUES (@pname, @pnumber, @plocation, @dnum, @budget, @totalbudget);
		FETCH C INTO @pname, @pnumber, @plocation, @dnum, @budget;
	END
	CLOSE C;
	DEALLOCATE C;
	
	RETURN;
END;

--h) Pretende-se criar um trigger que, quando se elimina um departamento, este passe para
-- uma tabela department_deleted com a mesma estrutura da department. Caso esta
-- tabela n�o exista ent�o deve criar uma nova e s� depois inserir o registo. Implemente
-- a solu��o com um trigger de cada tipo (after e instead of). Discuta vantagens e
-- desvantagem de cada implementa��o.

-- utilizando after

GO
CREATE Trigger delete_dep_after ON company.department
AFTER DELETE
AS
BEGIN
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'company' AND TABLE_NAME = 'department_deleted'))
	BEGIN
		INSERT INTO department_deleted SELECT * FROM deleted;
	END
	ELSE
	BEGIN
		CREATE TABLE department_deleted(
			Dname	VARCHAR(20) NOT NULL,
			Dnumber INT NOT NULL,
			Mgr_ssn INT NOT NULL,
			Mgr_start_date DATE,
			PRIMARY KEY (Dnumber),
		);
		INSERT INTO Department_Deleted SELECT * FROM deleted;
	END
END;

--utilizando instead of

GO
CREATE Trigger delete_dept_insteadOf ON company.department
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Dnumber_chosen AS INT;
	SELECT @Dnumber_chosen = Dnumber FROM deleted;

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'company' AND TABLE_NAME = 'department_deleted'))
	BEGIN
		INSERT INTO department_deleted SELECT * FROM deleted;
		DELETE FROM company.department WHERE Dnumber = @Dnumber_chosen;
	END
	ELSE
	BEGIN
		CREATE TABLE department_deleted(
			Dname VARCHAR(20) NOT NULL,
			Dnumber INT NOT NULL,
			Mgr_ssn INT NOT NULL,
			Mgr_start_date DATE,
			PRIMARY KEY (Dnumber),
		);
		INSERT INTO department_deleted SELECT * FROM deleted;
		DELETE FROM company.department WHERE Dnumber = @Dnumber_chosen;
	END
END;

-- Vantagens do AFTER: n�o necessita da query DELETE.
-- Vantagens do InsteadOF: faz override do DELETE casual e adiciona funcionalidades


--i) Relativamente aos stored procedure e UDFs, enumere as suas mais valias e as
-- caracter�sticas que as distingue. D� exemplos de situa��es em que se deve utiliza cada uma destas ferramentas;

-- Stored Procedures:   gravados na mem�ria cache
--						podem (ou n�o) retornar mais que um valor
--						n�o suportam SELECT, WHERE, e HAVING
--						suportam exce��es
--						podem receber par�metros de entrada e sa�da
--						permitem tabelas tempor�rias
					  
-- UDFs:				gravadas na mem�ria cache
--						apenas retornam um valor
--						suportam SELECT, WHERE, e HAVING
--						n�o suportam exce��es
--						podem receber par�metros de entrada
--						n�o permitem tabelas tempor�rias
