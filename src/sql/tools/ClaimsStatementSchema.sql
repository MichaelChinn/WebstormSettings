USE [stateeval]
GO
/****** Object:  Table [dbo].[SEClaimsStatement]    Script Date: 5/14/2015 11:10:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEClaimsStatement](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NOT NULL,
	[DescriptorText] [varchar](max) NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluateeId] [bigint] NOT NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[ContainerTypeID] [smallint] NOT NULL,
	[IsPublic] [bit] NOT NULL,
 CONSTRAINT [PK_SEClaimsStatement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SEClaimsStatementContainerType]    Script Date: 5/14/2015 11:10:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEClaimsStatementContainerType](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
 CONSTRAINT [PK_SEClaimsStatementContainerType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SEClaimsStatementEvidence]    Script Date: 5/14/2015 11:10:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEClaimsStatementEvidence](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClaimsStatementID] [bigint] NOT NULL,
	[EvidenceTypeID] [smallint] NOT NULL,
	[ArtifactID] [bigint] NULL,
	[Notes] [varchar](max) NULL,
 CONSTRAINT [PK_SEClaimsStatementEvidence] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SEClaimsStatementEvidenceType]    Script Date: 5/14/2015 11:10:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SEClaimsStatementEvidenceType](
	[ID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEClaimsStatementEvidenceType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SEClaimsStatementContainerType] FOREIGN KEY([ContainerTypeID])
REFERENCES [dbo].[SEClaimsStatementContainerType] ([ID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SEClaimsStatementContainerType]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SEEvalSession]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SEEvaluationType]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SERubricPerformanceLevel]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SERubricRow]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SESchoolYear]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SEUser] FOREIGN KEY([EvaluateeId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SEUser]
GO
ALTER TABLE [dbo].[SEClaimsStatement]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatement_SEUser1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
ALTER TABLE [dbo].[SEClaimsStatement] CHECK CONSTRAINT [FK_SEClaimsStatement_SEUser1]
GO
ALTER TABLE [dbo].[SEClaimsStatementEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatementEvidence_SEClaimsStatement] FOREIGN KEY([ClaimsStatementID])
REFERENCES [dbo].[SEClaimsStatement] ([ID])
GO
ALTER TABLE [dbo].[SEClaimsStatementEvidence] CHECK CONSTRAINT [FK_SEClaimsStatementEvidence_SEClaimsStatement]
GO
ALTER TABLE [dbo].[SEClaimsStatementEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEClaimsStatementEvidence_SEClaimsStatementEvidenceType] FOREIGN KEY([EvidenceTypeID])
REFERENCES [dbo].[SEClaimsStatementEvidenceType] ([ID])
GO
ALTER TABLE [dbo].[SEClaimsStatementEvidence] CHECK CONSTRAINT [FK_SEClaimsStatementEvidence_SEClaimsStatementEvidenceType]
GO
