-- SQL file for the creation of the stored procedures

--a) Construa um stored procedure que aceite o ssn de um funcionário, que o remova da
-- tabela de funcionários, que remova as suas entradas da tabela works_on e que remova
-- ainda os seus dependentes. 
-- Que preocupações adicionais devem ter no storage procedure para além das referidas anteriormente?
-- Neste caso, é também necessário atualizar o valor do super_ssn de cada employee caso o ssn do employee
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

--e) Crie uma UDF que, para determinado funcionário (ssn), devolva o nome e localização
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


--f) Crie uma UDF que, para determinado departamento (dno), retorne os funcionários
-- com um vencimento superior à média dos vencimentos desse departamento;
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


--g)