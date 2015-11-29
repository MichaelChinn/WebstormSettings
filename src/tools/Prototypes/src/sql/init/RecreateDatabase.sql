DECLARE @name nvarchar(50)
SELECT @name=name FROM sys.databases WHERE name = N'$(DatabaseName)'

IF  @name is not NULL
BEGIN
	-- Read current users to cursor
	CREATE TABLE #dbUsers
	(
		dbUser nvarchar(50)
	)

	INSERT INTO #dbUsers
	SELECT name from $(DatabaseName).dbo.sysusers 
		where islogin = 1 and name like 'StateEval%'

	-- Drop database
	ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [$(DatabaseName)] 
END
CREATE DATABASE [$(DatabaseName)] 
ALTER DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS

IF  @name is not NULL
BEGIN
	DECLARE @SQL NVARCHAR(4000);
	
	-- Read current users to cursor
	DECLARE @dbUser nvarchar(50)
	DECLARE dbUsers CURSOR
		FOR SELECT * FROM #dbUsers 	

	USE [$(DatabaseName)];
	
	OPEN dbUsers
	FETCH NEXT FROM dbUsers
		INTO @dbUser

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Creating user' + @dbUser
		IF EXISTS (SELECT * FROM sys.server_principals WHERE name = @dbUser)
		BEGIN		
			SET @SQL = 'CREATE User [' + @dbUser + '] FOR LOGIN [' + @dbUser + ']';
			EXECUTE(@SQL);

			EXEC sp_addrolemember N'db_datareader', @dbUser
						
			EXEC sp_addrolemember N'db_datawriter', @dbUser
						
			SET @SQL = 'GRANT EXECUTE TO [' + @dbUser + ']';
			EXECUTE(@SQL);
		END
			    
		FETCH NEXT FROM dbUsers
		INTO @dbUser
	END
	 
	CLOSE dbUsers -- close the cursor
	DEALLOCATE dbUsers -- Deallocate the cursor

	DROP TABLE #dbUsers
END