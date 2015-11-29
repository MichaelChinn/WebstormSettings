
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 98611348
, @title = '98611348_ArtifactBundles'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResource]') AND type in (N'U'))
DROP TABLE [dbo].[SEResource]
 
CREATE TABLE [dbo].[SEResourceItemType](
	[ResourceItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEResourceItemType] PRIMARY KEY CLUSTERED 
(
	[ResourceItemTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEResource](
	[ResourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [smallint] NOT NULL,
	[FileUUID] [uniqueidentifier] NULL,
	[WebUrl] [varchar](max) NULL,
	[SchoolCode] [varchar](20) NULL,
	[DistrictCode] [varchar](20) NULL,
	[Title] [varchar](200) NOT NULL,
	[Comments] [varchar](max) NULL,
	[FileName] [varchar](255) NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[ResourceType] [smallint] NOT NULL,
 CONSTRAINT [PK_SEResource] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[SEResourceRubricRowAlignment](
	[ResourceId] [bigint] NOT NULL,
	[RubricRowId] [bigint] NOT NULL,
 CONSTRAINT [PK_SEResourceRubricRowAlignment] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC,
	[RubricRowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SEResource]  WITH CHECK ADD  CONSTRAINT [FK_SEResource_ItemType] FOREIGN KEY([ItemTypeID])
REFERENCES [dbo].[SEResourceItemType] ([ResourceItemTypeID])
ALTER TABLE [dbo].[SEResource] CHECK CONSTRAINT [FK_SEResource_ItemType]


ALTER TABLE [dbo].[SEResourceRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEResourceRubricRowAlignment_SEResource] FOREIGN KEY([ResourceId])
REFERENCES [dbo].[SEResource] ([ResourceID])

ALTER TABLE [dbo].[SEResourceRubricRowAlignment] CHECK CONSTRAINT [FK_SEResourceRubricRowAlignment_SEResource]

ALTER TABLE [dbo].[SEResourceRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEResourceRubricRowAlignment_SERubricRow] FOREIGN KEY([RubricRowId])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])

ALTER TABLE [dbo].[SEResourceRubricRowAlignment] CHECK CONSTRAINT [FK_SEResourceRubricRowAlignment_SERubricRow]


CREATE TABLE [dbo].[SEArtifactLibItemType](
	[ArtifactLibItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactLibItemType] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEArtifactLibItem](
	[ArtifactLibItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [smallint] NOT NULL,
	[FileUUID] UNIQUEIDENTIFIER NULL,
	[WebUrl] VARCHAR(MAX) NULL,
	[ProfPracticeNotes] VARCHAR(MAX) NULL,
	[EvaluationID] BIGINT NOT NULL,
	[Title] VARCHAR(200) NOT NULL DEFAULT(''),
	[Comments] VARCHAR(MAX) NULL ,
	[CreationDateTime] DATETIME NOT NULL,
	[FileName] VARCHAR(255) NULL,
	[CreatedByUserID] BIGINT NOT NULL,
 CONSTRAINT [PK_SEArtifactLibItem] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 

ALTER TABLE [dbo].[SEArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactLibItem_ItemType] FOREIGN KEY([ItemTypeID])
REFERENCES [dbo].[SEArtifactLibItemType] ([ArtifactLibItemTypeID])
ALTER TABLE [dbo].[SEArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactLibItem_ItemType]

ALTER TABLE [dbo].[SEArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactLibItem_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactLibItem_CreatedByUserID]


ALTER TABLE [dbo].[SEArtifact] DROP CONSTRAINT [FK_SEArtifact_SEArtifactType]

TRUNCATE TABLE [dbo].[SEArtifactType]
INSERT [dbo].[SEArtifactType](Name) VALUES('STANDARD')
INSERT [dbo].[SEArtifactType](Name) VALUES('STUDENT_GROWTH_GOAL')
INSERT [dbo].[SEArtifactType](Name) VALUES('OBSERVATION')  

SET IDENTITY_INSERT [dbo].[SEWfState] ON
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (16, N'ARTIFACT_EVALUATED', N'ARTIFACT_EVALUATED', N'ARTIFACT_EVALUATED')
SET IDENTITY_INSERT [dbo].[SEWfState] OFF

CREATE TABLE [dbo].[SEArtifactBundle](
	[ArtifactBundleID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] BIGINT NOT NULL,
	[Title] VARCHAR(200) NOT NULL DEFAULT(''),
	[CreationDateTime] DATETIME NOT NULL,
	[Context] VARCHAR(MAX) NULL DEFAULT(''), 
	[Evidence] VARCHAR(MAX) NULL DEFAULT(''),
	[WfStateID] BIGINT NOT NULL DEFAULT(6),
	[ArtifactTypeID] SMALLINT NOT NULL,
	[SubmitDateTime] DATETIME NULL,
	[RejectDateTime] DATETIME NULL,
	[EvalSessionID] [bigint] NULL,
	[StudentGrowthGoalID] BIGINT NULL,
	[CreatedByUserID] BIGINT NOT NULL,
	[RejectionTypeID] SMALLINT NULL
 CONSTRAINT [PK_SEArtifactBundle] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


ALTER TABLE [dbo].[SERubricRowAnnotation] ADD ArtifactBundleID BIGINT NULL
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT FK_SERubricRowAnnotation_SEEvalSession
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP COLUMN EvalSessionID 
ALTER TABLE [dbo].[SERubricRowAnnotation] ADD EvalSessionID BIGINT NULL

ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SEArtifactBundle]

ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEStudentGrowthGoal] FOREIGN KEY([StudentGrowthGoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])

ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEStudentGrowthGoal]

-- moved here from sggoals so SEArtifactBundle will be defined
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEArtifactBundle] FOREIGN KEY([ProcessArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEArtifactBundle]


ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEEvalSession]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])

ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEWfState]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])

ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEEvaluation]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_CreatedByUserID]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_ArtifactTypeID] FOREIGN KEY([ArtifactTypeID])
REFERENCES [dbo].[SEArtifactType] ([ArtifactTypeID])
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_ArtifactTypeID]

CREATE TABLE [dbo].[SEArtifactBundleArtifactLibItem](
	[ArtifactBundleID] [bigint] NOT NULL,
	[ArtifactLibItemID] [bigint] NOT NULL,
	CONSTRAINT PK_ArtifactBundleArtifactLibItem PRIMARY KEY NONCLUSTERED ([ArtifactBundleID], [ArtifactLibItemID])
	)

ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]

ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID] FOREIGN KEY([ArtifactLibItemID])
REFERENCES [dbo].[SEArtifactLibItem] ([ArtifactLibItemID])
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]


CREATE TABLE [dbo].[SEArtifactBundleRubricRowAlignment](
	[ArtifactBundleID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	CONSTRAINT PK_ArtifactBundleRubricRow PRIMARY KEY NONCLUSTERED ([ArtifactBundleID], [RubricRowID])
	)

ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]

ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_RubricRowID]


CREATE TABLE [dbo].[SEArtifactBundleWfHistory](
	[ArtifactBundleWfHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ArtifactBundleID] BIGINT NOT NULL,
	[TransitionID] BIGINT NOT NULL,
	[Comments] VARCHAR(MAX) NULL DEFAULT(''),
	[TimeStamp] DATETIME NOT NULL,
	[UserID] [bigint] NULL,
 CONSTRAINT [PK_SEArtifactBundleWfHistory] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleWfHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SEArtifactBundleWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleWfHistory_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
ALTER TABLE [dbo].[SEArtifactBundleWfHistory] CHECK CONSTRAINT [FK_SEArtifactBundleWfHistory_ArtifactBundleID]

/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


