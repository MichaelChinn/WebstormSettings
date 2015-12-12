IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_IFWType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework] DROP CONSTRAINT [FK_SEFramework_IFWType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_SEFrameworkType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework] DROP CONSTRAINT [FK_SEFramework_SEFrameworkType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] DROP CONSTRAINT [FK_SEFrameworkNode_SEFramework]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] DROP CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType] DROP CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType] DROP CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType] DROP CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel2]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType] DROP CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel3]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] DROP CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] DROP CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFrameworkNodeById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFrameworkNodeById]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNodesInFramework]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetNodesInFramework]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPrototypeFrameworks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPrototypeFrameworks]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertFrameworkNodeRubricRow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InsertFrameworkNodeRubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateRubricRow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateRubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkViewType]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkViewType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictConfiguration]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteRubricRow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteRubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_GetErrorXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ELMAH_GetErrorXml]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_GetErrorsXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ELMAH_GetErrorsXml]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_LogError]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ELMAH_LogError]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildRubricRowOfFrameworkNode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetChildRubricRowOfFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetChildRubricRowsOfFrameworkNode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetChildRubricRowsOfFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFrameworkById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFrameworkById]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricPerformanceLevel]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEIFWType]') AND type in (N'U'))
DROP TABLE [dbo].[SEIFWType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkType]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFrameworkNode]'))
DROP VIEW [dbo].[vFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFramework]'))
DROP VIEW [dbo].[vFramework]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vFrameworkNodeRubricRow]'))
DROP VIEW [dbo].[vFrameworkNodeRubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_Error]') AND type in (N'U'))
DROP TABLE [dbo].[ELMAH_Error]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRowFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRow]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFramework]') AND type in (N'U'))
DROP TABLE [dbo].[SEFramework]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkNode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_Error]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ELMAH_Error](
	[ErrorId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ELMAH_Error_ErrorId]  DEFAULT (newid()),
	[Application] [nvarchar](60) NOT NULL,
	[Host] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Source] [nvarchar](60) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[User] [nvarchar](50) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[TimeUtc] [datetime] NOT NULL,
	[Sequence] [int] IDENTITY(1,1) NOT NULL,
	[AllXml] [ntext] NOT NULL,
 CONSTRAINT [PK_ELMAH_Error] PRIMARY KEY NONCLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricPerformanceLevel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricPerformanceLevel](
	[PerformanceLevelID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_PerformanceLevel] PRIMARY KEY CLUSTERED 
(
	[PerformanceLevelID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEIFWType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEIFWType](
	[IFWTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_IFWType] PRIMARY KEY CLUSTERED 
(
	[IFWTypeID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkViewType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkViewType](
	[FrameworkViewTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEFrameworkViewType] PRIMARY KEY CLUSTERED 
(
	[FrameworkViewTypeID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRow]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRow](
	[RubricRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](256) NOT NULL,
	[Description] [text] NOT NULL,
	[PL4Descriptor] [text] NOT NULL,
	[PL3Descriptor] [text] NOT NULL,
	[PL2Descriptor] [text] NOT NULL,
	[PL1Descriptor] [text] NOT NULL,
	[XferID] [uniqueidentifier] NULL,
	[IsStateAligned] [bit] NULL,
 CONSTRAINT [PK_Element] PRIMARY KEY CLUSTERED 
(
	[RubricRowID] ASC
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
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluationType](
	[EvaluationTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EvaluatorType] PRIMARY KEY CLUSTERED 
(
	[EvaluationTypeID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictConfiguration](
	[DistrictConfigurationID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](50) NOT NULL,
	[FrameworkViewTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_SEDistrictConfiguration] PRIMARY KEY CLUSTERED 
(
	[DistrictConfigurationID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkType](
	[FrameworkTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[RubricPL1ID] [smallint] NOT NULL,
	[RubricPL2ID] [smallint] NOT NULL,
	[RubricPL3ID] [smallint] NOT NULL,
	[RubricPL4ID] [smallint] NOT NULL,
 CONSTRAINT [PK_SEFrameworkType] PRIMARY KEY CLUSTERED 
(
	[FrameworkTypeID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFramework]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFramework](
	[FrameworkID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NULL,
	[Description] [varchar](200) NULL,
	[DistrictCode] [varchar](10) NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[FrameworkTypeID] [smallint] NOT NULL,
	[IFWTypeID] [smallint] NULL,
	[IsPrototype] [bit] NOT NULL,
	[DerivedFromFrameworkId] [bigint] NULL,
	[HasBeenModified] [bit] NOT NULL,
	[HasBeenApproved] [bit] NOT NULL,
 CONSTRAINT [PK_Framework] PRIMARY KEY CLUSTERED 
(
	[FrameworkID] ASC
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRowFrameworkNode](
	[FrameworkNodeID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[Sequence] [smallint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkNode](
	[FrameworkNodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[FrameworkID] [bigint] NOT NULL,
	[ParentNodeID] [bigint] NULL,
	[Title] [varchar](500) NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
	[Description] [varchar](8000) NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[IsLeafNode] [bit] NOT NULL,
	[XferID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_SEFrameworkNode] PRIMARY KEY CLUSTERED 
(
	[FrameworkNodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_IFWType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework]  WITH CHECK ADD  CONSTRAINT [FK_SEFramework_IFWType] FOREIGN KEY([IFWTypeID])
REFERENCES [dbo].[SEIFWType] ([IFWTypeID])
GO
ALTER TABLE [dbo].[SEFramework] CHECK CONSTRAINT [FK_SEFramework_IFWType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_SEFrameworkType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework]  WITH CHECK ADD  CONSTRAINT [FK_SEFramework_SEFrameworkType] FOREIGN KEY([FrameworkTypeID])
REFERENCES [dbo].[SEFrameworkType] ([FrameworkTypeID])
GO
ALTER TABLE [dbo].[SEFramework] CHECK CONSTRAINT [FK_SEFramework_SEFrameworkType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNode_SEFramework] FOREIGN KEY([FrameworkID])
REFERENCES [dbo].[SEFramework] ([FrameworkID])
GO
ALTER TABLE [dbo].[SEFrameworkNode] CHECK CONSTRAINT [FK_SEFrameworkNode_SEFramework]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode] FOREIGN KEY([ParentNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
ALTER TABLE [dbo].[SEFrameworkNode] CHECK CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel] FOREIGN KEY([RubricPL1ID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
ALTER TABLE [dbo].[SEFrameworkType] CHECK CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel1] FOREIGN KEY([RubricPL2ID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
ALTER TABLE [dbo].[SEFrameworkType] CHECK CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel2] FOREIGN KEY([RubricPL3ID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
ALTER TABLE [dbo].[SEFrameworkType] CHECK CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel2]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkType_SERubricPerformanceLevel3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkType]'))
ALTER TABLE [dbo].[SEFrameworkType]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel3] FOREIGN KEY([RubricPL4ID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
ALTER TABLE [dbo].[SEFrameworkType] CHECK CONSTRAINT [FK_SEFrameworkType_SERubricPerformanceLevel3]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
ALTER TABLE [dbo].[SERubricRowFrameworkNode] CHECK CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
ALTER TABLE [dbo].[SERubricRowFrameworkNode] CHECK CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow]
GO
