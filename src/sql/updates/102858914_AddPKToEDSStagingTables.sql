/*
Run this script on:

        (local).stateeval_baseline    -  This database will be modified

to synchronize it with:

        (local).stateeval

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.2.1 from Red Gate Software Ltd at 9/7/2015 8:12:15 AM

#102858914

*/
SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
SET XACT_ABORT ON;
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
BEGIN TRANSACTION;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO



PRINT N'Checking PT... ';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
IF EXISTS (SELECT BugNumber FROM dbo.UpdateLog WHERE BugNumber = 102858914)
    SET NOEXEC ON;
ELSE INSERT dbo.UpdateLog
        ( BugNumber ,
          UpdateName ,
          Comment ,
          timestamp
        )
VALUES  ( 102858914 , -- BugNumber - bigint
          'AddPKToEDSStagingTables' , -- UpdateName - varchar(100)
          'tables edsStaging, edsError, edsUsersV1 and edsRolesV1' , -- Comment - varchar(200)
          GETDATE()  -- timestamp - datetime
        )
GO


PRINT N'truncate table EDSE*ror';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
TRUNCATE TABLE dbo.EDSError
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO

PRINT N'truncate table EDSUsersV1';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
TRUNCATE TABLE dbo.EDSUsersV1
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO

PRINT N'truncate table EDSRolesV1';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
TRUNCATE TABLE dbo.EDSRolesV1
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO


PRINT N'truncate table EDSStaging';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
TRUNCATE TABLE dbo.EDSStaging
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO


PRINT N'Altering [dbo].[EDSUsersV1]';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
ALTER TABLE [dbo].[EDSUsersV1] ADD
[EDSUsersID] [BIGINT] NOT NULL IDENTITY(1, 1);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_EDSUsersV1] on [dbo].[EDSUsersV1]';
GO
ALTER TABLE [dbo].[EDSUsersV1] ADD CONSTRAINT [PK_EDSUsersV1] PRIMARY KEY CLUSTERED  ([EDSUsersID]);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[EDSRolesV1]';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
ALTER TABLE [dbo].[EDSRolesV1] ADD
[EDSRolesID] [BIGINT] NOT NULL IDENTITY(1, 1);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_EDSRolesV1] on [dbo].[EDSRolesV1]';
GO
ALTER TABLE [dbo].[EDSRolesV1] ADD CONSTRAINT [PK_EDSRolesV1] PRIMARY KEY CLUSTERED  ([EDSRolesID]);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO

PRINT N'Altering [dbo].[EDSE*ror]';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
ALTER TABLE [dbo].[EDSError] ADD
[EDSErrorID] [BIGINT] NOT NULL IDENTITY(1, 1);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_EDSE*ror] on [dbo].[EDSE*ror]';
GO
ALTER TABLE [dbo].[EDSError] ADD CONSTRAINT [PK_EDSError] PRIMARY KEY CLUSTERED  ([EDSErrorID]);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_EDSStaging] on [dbo].[EDSStaging]';
GO
ALTER TABLE [dbo].[EDSStaging] ADD CONSTRAINT [PK_EDSStaging] PRIMARY KEY CLUSTERED  ([stagingId]);
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
COMMIT TRANSACTION;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
DECLARE @Success AS BIT;
SET @Success = 1;
SET NOEXEC OFF;
IF ( @Success = 1 )
    PRINT 'The database update succeeded';
ELSE
    BEGIN
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'The database update failed';
    END;
GO
