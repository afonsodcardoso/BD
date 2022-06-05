-- Experiences relative to exercise 1 of guide 8

-- Before executing each query, its necessary to clear the database's cache
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

--#1  Index : WorkOrderID (PK)
select * from Production.WorkOrder;

--#2 Index: WorkOrderID (PK)
select * from Production.WorkOrder where WorkOrderID=1234;

--#3 Index: WorkOrderID (PK)
SELECT * FROM Production.WorkOrder
WHERE WorkOrderID between 10000 and 10010;

--#4 Index: WorkOrderID (PK)
SELECT * FROM Production.WorkOrder
WHERE StartDate = '2007-06-25';

--#5 Index: ProductID
SELECT * FROM Production.WorkOrder WHERE ProductID = 757;

--#6 Index: ProductID Covered (StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
 WHERE ProductID = 757;
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
 WHERE ProductID = 945;
SELECT WorkOrderID FROM Production.WorkOrder
 WHERE ProductID = 945 AND StartDate = '2006-01-04';

--#7 Index: ProductID and StartDate
SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 945 AND StartDate = '2006-01-04';

--#8 Index: Composite (ProductID, StartDate)
Query: SELECT WorkOrderID, StartDate FROM Production.WorkOrder
WHERE ProductID = 945 AND StartDate = '2006-01-04';