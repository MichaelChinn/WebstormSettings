EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Repository'
GO
USE [master]
GO
ALTER DATABASE [Repository] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [Repository]    Script Date: 08/03/2007 23:39:38 ******/
DROP DATABASE [Repository]
GO
