IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'$(DatabaseName)')
BEGIN
	ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [$(DatabaseName)] 
END
CREATE DATABASE [$(DatabaseName)] 
ALTER DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO