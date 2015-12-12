/*
Run this script on:

        (local).stateeval_baseline    -  This database will be modified

to synchronize it with:

        (local).stateeval

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.2.1 from Red Gate Software Ltd at 8/18/2015 7:32:10 AM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Inserting patch number into UpdateLog'
GO

IF NOT EXISTS (SELECT UpdateLogID FROM dbo.UpdateLog WHERE bugnumber = 101522026)
begin
	INSERT dbo.UpdateLog
	        ( BugNumber ,
	          UpdateName ,
	          Comment ,
	          timestamp
	        )
	VALUES  ( 101522026 , -- BugNumber - bigint
	          '101522026_MakeTagTables' , -- UpdateName - varchar(100)
	          '' , -- Comment - varchar(200)
	          GETDATE()  -- timestamp - datetime
	        )
	IF @@ERROR <> 0 SET NOEXEC ON
END
ELSE
	SET NOEXEC on
GO




GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SETagArtifactLibItem]'
GO
CREATE TABLE [dbo].[SETagArtifactLibItem]
(
[ArtifactLibItemID] [bigint] NOT NULL,
[TagID] [bigint] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SETagArtifactLibItem] on [dbo].[SETagArtifactLibItem]'
GO
ALTER TABLE [dbo].[SETagArtifactLibItem] ADD CONSTRAINT [PK_SETagArtifactLibItem] PRIMARY KEY CLUSTERED  ([ArtifactLibItemID], [TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SETag]'
GO
CREATE TABLE [dbo].[SETag]
(
[TagID] [bigint] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SETag] on [dbo].[SETag]'
GO
ALTER TABLE [dbo].[SETag] ADD CONSTRAINT [PK_SETag] PRIMARY KEY CLUSTERED  ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SETagArtifactLibItem]'
GO
ALTER TABLE [dbo].[SETagArtifactLibItem] ADD CONSTRAINT [FK_SETagArtifactLibItem_SEArtifactLibItem] FOREIGN KEY ([ArtifactLibItemID]) REFERENCES [dbo].[SEArtifactLibItem] ([ArtifactLibItemID])
ALTER TABLE [dbo].[SETagArtifactLibItem] ADD CONSTRAINT [FK_SETagArtifactLibItem_SETag] FOREIGN KEY ([TagID]) REFERENCES [dbo].[SETag] ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
