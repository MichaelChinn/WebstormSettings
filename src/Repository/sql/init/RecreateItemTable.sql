IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RepositoryItem]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
ALTER TABLE [dbo].[RepositoryItem]  DROP  CONSTRAINT [FK_RepositoryItem_RepositoryFolder]
drop table dbo.repositoryFolder
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RepositoryFolder]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table dbo.repositoryItem
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RepositoryFolder]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[RepositoryFolder](
	[RepositoryFolderId] [bigint] IDENTITY(1,1) NOT NULL,
	[FolderName] [varchar](512) NOT NULL,
	[LeftOrdinal] [bigint] NOT NULL,
	[RightOrdinal] [bigint] NOT NULL,
	[OwnerId] [bigint] NOT NULL,
 CONSTRAINT [PK_RepositoryFolder] PRIMARY KEY CLUSTERED 
(
	[RepositoryFolderId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RepositoryItem]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[RepositoryItem](
	[RepositoryItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerID] [bigint] NOT NULL,
	[ReferenceCount] [int] NOT NULL,
	[Data] [varbinary](max) NULL,
	[ItemName] [varchar](1024) NULL,
	[Description] [varchar](1024) NULL,
	[Keywords] [varchar](1024) NULL,
	[LastUpload] [datetime] NULL,
	[InitialUpload] [datetime] NULL,
	[RepositoryFolderId] [bigint] NULL,
 CONSTRAINT [PK_RepositoryItem] PRIMARY KEY CLUSTERED 
(
	[RepositoryItemId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FK_RepositoryItem_RepositoryFolder]') AND type = 'F')
ALTER TABLE [dbo].[RepositoryItem]  WITH CHECK ADD  CONSTRAINT [FK_RepositoryItem_RepositoryFolder] FOREIGN KEY([RepositoryFolderId])
REFERENCES [dbo].[RepositoryFolder] ([RepositoryFolderId])
GO
ALTER TABLE [dbo].[RepositoryItem] CHECK CONSTRAINT [FK_RepositoryItem_RepositoryFolder]
