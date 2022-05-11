---a) Obtenha uma lista contendo os projetos e funcionários (ssn e nome completo) que lá trabalham;
SELECT Pname, Fname, Lname, Ssn FROM (company.project JOIN company.works_on ON Pnumber = Pno) JOIN company.employee ON Essn = Ssn;

---b) Obtenha o nome de todos os funcionários supervisionador por 'Carlos D Gomes'
SELECT SuperE.Fname, SuperE.Minit, SuperE.Lname FROM company.employee AS SuperE JOIN (SELECT  * FROM company.employee
WHERE Fname = 'Carlos' AND Minit='D' AND Lname='Gomes')  AS emp ON SuperE.Super_ssn = emp.Ssn;

---c) Para cada projecto, listar o seu nome e o número de horas (por semana) gastos nesse projecto por todos os funcionários
SELECT Pno, Pname, SUM(Hours) AS total_horas FROM company.project JOIN company.works_on ON Pnumber=Pno GROUP BY Pname, Pno;

---d) Obter o nome de todos os funcionários do departamento 3 que trabalham mais de 20 horaspor semana no projecto 'Aveiro Digital'
SELECT Fname, Minit, Lname, Ssn, works_on.Hours, project.Pname FROM (company.employee JOIN company.works_on ON Dno=3 AND Ssn=Essn) 
JOIN company.project ON Pno=Pnumber AND Pname='Aveiro Digital' WHERE Hours > 20;

---e) Nome dos funcionários que não trabalham para projetos
SELECT Fname, Minit, Lname, Ssn FROM company.employee LEFT OUTER JOIN company.works_on ON Ssn=Essn WHERE Pno IS NULL;

---f) Para cada departamento, listar o seu nome e o salário médio dos seus funcionários do sexo feminino;
SELECT Dno, Dname, AVG(Salary) AS media_salario FROM company.employee JOIN company.department ON Dno=Dnumber WHERE Sex='F' GROUP BY Dno, Dname;

---g) Obter uma lista de todos os funcionários com mais do que dois dependentes;
SELECT Fname, Minit, Lname FROM company.dependent JOIN company.employee ON Essn=Ssn GROUP BY Fname, Minit, Lname, Ssn HAVING COUNT(Essn)> 2;

---h) Obtenha uma lista de todos os funcionários gestores de departamento que não têm dependentes;
SELECT Fname, Minit, Lname FROM (company.employee JOIN company.department ON Ssn=Mgr_ssn) LEFT OUTER JOIN company.dependent ON Ssn=Essn
GROUP BY Fname, Minit, Lname, Ssn HAVING COUNT(Essn) = 0;

---i) Obter os nomes e endereços de todos os funcionários que trabalham em, pelo menos, um projeto localizado em Aveiro mas o seu departamento não tem nenhuma localização em Aveiro.
SELECT DISTINCT Fname, Minit, Lname, Ssn, Address FROM company.employee  JOIN company.works_on ON Ssn=Essn JOIN company.project ON Pno=Pnumber AND Plocation='Aveiro'
JOIN (SELECT company.department.* FROM (company.department LEFT OUTER JOIN company.dept_location ON company.department.Dnumber=company.dept_location.Dnumber)
WHERE Dlocation!='Aveiro' OR Dlocation IS NULL) AS temp ON Dno=Dnumber;