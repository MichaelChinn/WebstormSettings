IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppUsageCount_RepositoryItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppUsageCount]'))
ALTER TABLE [dbo].[AppUsageCount] DROP CONSTRAINT [FK_AppUsageCount_RepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bitstream_Bundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bitstream]'))
ALTER TABLE [dbo].[Bitstream] DROP CONSTRAINT [FK_Bitstream_Bundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bundle_Bitstream]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bundle]'))
ALTER TABLE [dbo].[Bundle] DROP CONSTRAINT [FK_Bundle_Bitstream]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bundle_RepositoryItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bundle]'))
ALTER TABLE [dbo].[Bundle] DROP CONSTRAINT [FK_Bundle_RepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RepositoryItem_RepositoryFolder]') AND parent_object_id = OBJECT_ID(N'[dbo].[RepositoryItem]'))
ALTER TABLE [dbo].[RepositoryItem] DROP CONSTRAINT [FK_RepositoryItem_RepositoryFolder]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepoRecordCounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RepoRecordCounts]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddBitstreamToRepositoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddBitstreamToRepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddBundle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddFolder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddFolder]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddRepositoryItemWithSingleFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddRepositoryItemWithSingleFile]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChunkInStreamData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ChunkInStreamData]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteBitstream]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteBitstream]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlushTrees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FlushTrees]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlushUserTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FlushUserTree]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBitstreamById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBitstreamById]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBitstreamForItemByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBitstreamForItemByName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBitstreamsForBundle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBitstreamsForBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBitstreamData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBitstreamData]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBundleForItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBundleForItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildFolderByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetChildFolderByName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildItemByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetChildItemByName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDiskUsageForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDiskUsageForUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtensionContentType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtensionContentType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFolderNode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFolderNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetIsItemImmutable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetIsItemImmutable]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetIsItemUsed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetIsItemUsed]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetItemNode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetItemNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetItemPathComponents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetItemPathComponents]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildBitstreamByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetChildBitstreamByName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPrimaryBitstreamForRepositoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPrimaryBitstreamForRepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRepositoryFolders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRepositoryFolders]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRepositoryForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRepositoryForUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRepositoryItemById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRepositoryItemById]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRepositoryItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRepositoryItems]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRootForUserTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRootForUserTree]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSiblingFolderIDWithSameName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSiblingFolderIDWithSameName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserTree]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MoveItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MoveItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MoveBitStreamItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MoveBitStreamItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PutBitstreamData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PutBitstreamData]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecycleFolder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RecycleFolder]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecycleItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RecycleItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RenameBitstream]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RenameBitstream]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RenameFolder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RenameFolder]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RenameRepositoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RenameRepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetUnsetItemImmutable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetUnsetItemImmutable]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetUnsetItemUsed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetUnsetItemUsed]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StartTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[StartTree]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateBundle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateRepositoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateRepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmptyRecycle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[EmptyRecycle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImageType]') AND type in (N'U'))
DROP TABLE [dbo].[ImageType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemIsImmutable_fn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ItemIsImmutable_fn]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBitstream]'))
DROP VIEW [dbo].[vBitstream]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vBundle]'))
DROP VIEW [dbo].[vBundle]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vRepositoryItem]'))
DROP VIEW [dbo].[vRepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemIsUsed_fn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ItemIsUsed_fn]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vUserRepoContext]'))
DROP VIEW [dbo].[vUserRepoContext]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MoveSubTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MoveSubTree]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsBitstreamCollision_fn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[IsBitstreamCollision_fn]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bitstream]') AND type in (N'U'))
DROP TABLE [dbo].[Bitstream]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bundle]') AND type in (N'U'))
DROP TABLE [dbo].[Bundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppUsageCount]') AND type in (N'U'))
DROP TABLE [dbo].[AppUsageCount]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRepoContext]') AND type in (N'U'))
DROP TABLE [dbo].[UserRepoContext]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vRepositoryFolder]'))
DROP VIEW [dbo].[vRepositoryFolder]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsCollision_fn]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[IsCollision_fn]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepositoryItem]') AND type in (N'U'))
DROP TABLE [dbo].[RepositoryItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepositoryFolder]') AND type in (N'U'))
DROP TABLE [dbo].[RepositoryFolder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImageType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ImageType](
	[ImageTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Extension] [varchar](20) NULL,
	[ImageType] [varchar](250) NULL,
 CONSTRAINT [PK_ImageType] PRIMARY KEY CLUSTERED 
(
	[ImageTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepositoryFolder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RepositoryFolder](
	[RepositoryFolderId] [bigint] IDENTITY(1,1) NOT NULL,
	[FolderName] [varchar](512) NOT NULL,
	[LeftOrdinal] [bigint] NOT NULL,
	[RightOrdinal] [bigint] NOT NULL,
	[ParentNodeId] [bigint] NULL,
	[OwnerId] [bigint] NOT NULL,
 CONSTRAINT [PK_RepositoryFolder] PRIMARY KEY CLUSTERED 
(
	[RepositoryFolderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRepoContext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserRepoContext](
	[UserRepoContextID] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerID] [bigint] NOT NULL,
	[DiskQuota] [bigint] NOT NULL,
	[DiskUsage] [bigint] NOT NULL,
	[MaxFileSize] [bigint] NOT NULL,
 CONSTRAINT [PK_UserRepoContext] PRIMARY KEY CLUSTERED 
(
	[UserRepoContextID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bitstream]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Bitstream](
	[BitstreamID] [bigint] IDENTITY(1,1) NOT NULL,
	[BundleID] [bigint] NULL,
	[Bitstream] [image] NULL,
	[URL] [varchar](500) NULL,
	[Name] [varchar](2000) NULL,
	[Ext] [varchar](20) NULL,
	[ContentType] [varchar](250) NULL,
	[Description] [text] NULL,
	[Size] [bigint] NULL,
	[InitialUpload] [datetime] NOT NULL,
	[LastUpload] [datetime] NOT NULL,
	[OwnerId] [bigint] NOT NULL,
	[OldRepoPath] [varchar](1024) NULL,
 CONSTRAINT [PK_Bitstream] PRIMARY KEY CLUSTERED 
(
	[BitstreamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bundle]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Bundle](
	[BundleID] [bigint] IDENTITY(1,1) NOT NULL,
	[PrimaryBitstreamID] [bigint] NULL,
	[RepositoryItemID] [bigint] NOT NULL,
 CONSTRAINT [PK_Bundle] PRIMARY KEY CLUSTERED 
(
	[BundleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RepositoryItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RepositoryItem](
	[RepositoryItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerID] [bigint] NOT NULL,
	[ItemName] [varchar](1024) NULL,
	[Description] [varchar](1024) NULL,
	[Keywords] [varchar](5000) NULL,
	[VerifiedByStudent] [bit] NULL,
	[RepositoryFolderId] [bigint] NULL,
	[WithdrawnFlag] [bit] NULL,
	[IsImmutable] [bit] NULL,
 CONSTRAINT [PK_RepositoryItem] PRIMARY KEY CLUSTERED 
(
	[RepositoryItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppUsageCount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AppUsageCount](
	[ApplicationString] [varchar](40) NULL,
	[RepositoryItemId] [bigint] NULL,
	[ReferenceCount] [int] NULL,
	[ImmutabilityCount] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AppUsageCount_RepositoryItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[AppUsageCount]'))
ALTER TABLE [dbo].[AppUsageCount]  WITH CHECK ADD  CONSTRAINT [FK_AppUsageCount_RepositoryItem] FOREIGN KEY([RepositoryItemId])
REFERENCES [dbo].[RepositoryItem] ([RepositoryItemId])
GO
ALTER TABLE [dbo].[AppUsageCount] CHECK CONSTRAINT [FK_AppUsageCount_RepositoryItem]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bitstream_Bundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bitstream]'))
ALTER TABLE [dbo].[Bitstream]  WITH CHECK ADD  CONSTRAINT [FK_Bitstream_Bundle] FOREIGN KEY([BundleID])
REFERENCES [dbo].[Bundle] ([BundleID])
GO
ALTER TABLE [dbo].[Bitstream] CHECK CONSTRAINT [FK_Bitstream_Bundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bundle_Bitstream]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bundle]'))
ALTER TABLE [dbo].[Bundle]  WITH CHECK ADD  CONSTRAINT [FK_Bundle_Bitstream] FOREIGN KEY([PrimaryBitstreamID])
REFERENCES [dbo].[Bitstream] ([BitstreamID])
GO
ALTER TABLE [dbo].[Bundle] CHECK CONSTRAINT [FK_Bundle_Bitstream]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bundle_RepositoryItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bundle]'))
ALTER TABLE [dbo].[Bundle]  WITH CHECK ADD  CONSTRAINT [FK_Bundle_RepositoryItem] FOREIGN KEY([RepositoryItemID])
REFERENCES [dbo].[RepositoryItem] ([RepositoryItemId])
GO
ALTER TABLE [dbo].[Bundle] CHECK CONSTRAINT [FK_Bundle_RepositoryItem]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RepositoryItem_RepositoryFolder]') AND parent_object_id = OBJECT_ID(N'[dbo].[RepositoryItem]'))
ALTER TABLE [dbo].[RepositoryItem]  WITH CHECK ADD  CONSTRAINT [FK_RepositoryItem_RepositoryFolder] FOREIGN KEY([RepositoryFolderId])
REFERENCES [dbo].[RepositoryFolder] ([RepositoryFolderId])
GO
ALTER TABLE [dbo].[RepositoryItem] CHECK CONSTRAINT [FK_RepositoryItem_RepositoryFolder]
GO
