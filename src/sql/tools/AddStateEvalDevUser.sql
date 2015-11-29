
DECLARE @dbname VARCHAR (20)
SELECT @dbname =  DB_NAME()

IF NOT EXISTS (SELECT * 
FROM sys.database_principals
WHERE name = 'StateEval_Web_User'
) AND @dbName = 'StateEval'
BEGIN

SELECT 'inserting'
CREATE USER [StateEval_Web_User] FOR LOGIN [StateEval_Web_User]

ALTER ROLE [db_datareader] ADD MEMBER [StateEval_Web_User]

ALTER ROLE [db_datawriter] ADD MEMBER [StateEval_Web_User]

ALTER ROLE [db_owner] ADD MEMBER [StateEval_Web_User]
END
GO
