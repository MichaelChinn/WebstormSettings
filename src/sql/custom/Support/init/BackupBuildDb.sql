BACKUP DATABASE [stateeval] TO  DISK = N'$(BackupDatabasePath)' WITH NOFORMAT, INIT,  NAME = N'stateeval-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
