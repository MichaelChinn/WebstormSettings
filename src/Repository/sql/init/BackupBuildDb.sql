BACKUP DATABASE [stateeval_repo] TO  DISK = N'$(BackupDatabasePath)' WITH NOFORMAT, INIT,  NAME = N'stateeval_repo-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
