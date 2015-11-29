IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'$(DatabaseName)')
BEGIN
	ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [$(DatabaseName)] 
END
CREATE DATABASE [$(DatabaseName)] 
ALTER DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO

USE [$(DatabaseName)]
GO
CREATE USER [WebApplication] FOR LOGIN [WebApplication]
GO
EXEC sp_addrolemember N'db_datareader', N'WebApplication'
GO
EXEC sp_addrolemember N'db_datawriter', N'WebApplication'
GO
GRANT EXECUTE TO [WebApplication]
GO

USE [$(DatabaseName)]
GO
CREATE USER [hoc] FOR LOGIN [hoc]
GO
EXEC sp_addrolemember N'db_datareader', N'hoc'
GO
EXEC sp_addrolemember N'db_datawriter', N'hoc'
GO
EXEC sp_addrolemember N'db_owner', N'hoc'
GO

GRANT EXECUTE TO [hoc]
GO



