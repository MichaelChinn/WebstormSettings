RESTORE DATABASE [StateEval] FROM  DISK = N'D:\dev\StateEval\DatabaseBaks\StateEval.bak' 
WITH  FILE = 1,  MOVE N'StateEval' TO N'd:\Databases\StateEval.mdf',  
MOVE N'StateEval_log' TO N'd:\Databases\StateEval.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO


