IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'$(UserName)')
CREATE LOGIN [$(UserName)] WITH PASSWORD=N'$(UserPassword)', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'$(UserName)')
CREATE USER [$(UserName)] FOR LOGIN [$(UserName)]
GO

EXEC sp_addrolemember N'db_owner', N'$(UserName)'
GO



