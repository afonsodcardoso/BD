DROP TABLE mytemp;

CREATE TABLE mytemp (
	rid BIGINT IDENTITY (1,1) NOT NULL,
	at1 INT NULL,
	at2 INT NULL,
	at3 INT NULL,
	lixo varchar(100) NULL,
	PRIMARY KEY CLUSTERED (rid) /*WITH (FILLFACTOR=90)*/
);


-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time;

-- Generate random records
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;

SET nocount ON

WHILE @val <= @nelem
BEGIN
	DBCC DROPCLEANBUFFERS;				-- need to be sysadmin
	INSERT mytemp (/*rid,*/ at1, at2, at3, lixo)
	SELECT /*cast((RAND()*@nelem*40000) as int),*/ cast((RAND()*@nelem) as int),
		cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
		'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
	SET @val = @val + 1;
END

PRINT 'Inserted ' + str(@nelem) + ' total records'

-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND, @start_time, @end_time));


-- b) Miliseconds used: 65474 || percentagem de fragmentação: 99,16% || ocupação das páginas: 68,97%

-- c) fillfactor = 65 -> Miliseconds used: 64086
--    fillfactor = 80 -> Miliseconds used: 64407
--    fillfactor = 90 -> Miliseconds used: 63457

-- d) fillfactor = 90 -> Miliseconds used: 61430

-- e) fillfactor = 90 -> Miliseconds used: 65073 |Tempo de inserção com índices é maior do sem índices