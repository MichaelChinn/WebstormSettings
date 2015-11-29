/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 99759084
, @title = '99759084_StudentGrowthGoals Schema'
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

CREATE TABLE dbo.SEStudentGrowthProcessSettings (
	StudentGrowthProcessSettingsID BIGINT IDENTITY(1,1) NOT NULL,
	DistrictCode VARCHAR(20) NULL,
	EvaluationTypeID SMALLINT NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	FrameworkNodeShortName VARCHAR(50) NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthSettings] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthProcessSettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[SEStudentGrowthGoal](
	[StudentGrowthGoalID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalBundleID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[ProcessRubricRowID] [bigint] NOT NULL,
	[ResultsRubricRowID] [bigint] NULL,
	[GoalStatement] [varchar](max) NOT NULL,
	[GoalTargets] [varchar](max) NOT NULL,
	[EvidenceAll] [varchar](max) NOT NULL,
	[EvidenceMost] [varchar](max) NOT NULL,
	[ProcessPerformanceLevelID] [smallint] NULL,
	[ResultsPerformanceLevelID] [smallint] NULL,
	[ProcessTypeID] [smallint] NOT NULL,
	[ProcessArtifactBundleID] [bigint] NULL,
	[ProcessFormID] [bigint] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthGoal] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthGoalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[SEStudentGrowthGoalBundle](
	[StudentGrowthGoalBundleID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Comments] [varchar](max) NULL,
	[Course] [varchar](200) NULL,
	[Grade] [varchar](20) NULL,
	[WfStateID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthGoalBundle] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthGoalBundleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[SEStudentGrowthGoalBundleGoal](
	[BundleID] [bigint] NOT NULL,
	[GoalID] [bigint] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt](
    [ProcessSettingsFormPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessSettingsID] [bigint] NOT NULL,
	[FormPromptID] [bigint] NOT NULL,
	[Required] [bit] NOT NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthProcessSettingsFormPrompt] PRIMARY KEY CLUSTERED 
(
	[ProcessSettingsFormPromptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[SEFormPrompt](
	[FormPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[Prompt] [varchar](max) NOT NULL,
	DistrictCode VARCHAR(20) NULL,
	EvaluationTypeID SMALLINT NOT NULL,
	SchoolYear SMALLINT NOT NULL,
 CONSTRAINT [PK_SEFormPrompt] PRIMARY KEY CLUSTERED 
(
	[FormPromptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[SEFormPromptResponse](
	[FormPromptResponseID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormPromptID] [bigint] NOT NULL,
	[Response] [varchar](max) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[StudentGrowthGoalID] [bigint] NULL
 CONSTRAINT [PK_SEFormPromptResponse] PRIMARY KEY CLUSTERED 
(
	[FormPromptResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_GoalStatement]  DEFAULT ('') FOR [GoalStatement]

ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_GoalTargets]  DEFAULT ('') FOR [GoalTargets]

ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost]  DEFAULT ('') FOR [EvidenceAll]

ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost_1]  DEFAULT ('') FOR [EvidenceMost]

ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Title]  DEFAULT ('') FOR [Title]

ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Course]  DEFAULT ('') FOR [Course]

ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Grade]  DEFAULT ('') FOR [Grade]


ALTER TABLE [dbo].[SEFormPrompt] ADD  CONSTRAINT [DF_SEFormPrompt_Prompt]  DEFAULT ('') FOR [Prompt]

ALTER TABLE [dbo].[SEFormPromptResponse] ADD  CONSTRAINT [DF_SEFormPromptResponse_Response]  DEFAULT ('') FOR [Response]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowProcess] FOREIGN KEY([ProcessRubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowProcess]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowResults] FOREIGN KEY([ResultsRubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowResults]


ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle] FOREIGN KEY([GoalBundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEEvaluation]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEFrameworkNode]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel] FOREIGN KEY([ProcessPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel]

ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel1] FOREIGN KEY([ResultsPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])

ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]



ALTER TABLE [dbo].[SEStudentGrowthGoalBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])

ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState]

ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal] FOREIGN KEY([GoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])

ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]

ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle] FOREIGN KEY([BundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])

ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]

ALTER TABLE [dbo].[SEFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEFormPromptResponse_SEFormPrompt1] FOREIGN KEY([FormPromptID])
REFERENCES [dbo].[SEFormPrompt] ([FormPromptID])

ALTER TABLE [dbo].[SEFormPromptResponse] CHECK CONSTRAINT [FK_SEFormPromptResponse_SEFormPrompt1]

ALTER TABLE [dbo].[SEFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEFormPromptResponse_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEFormPromptResponse] CHECK CONSTRAINT [FK_SEFormPromptResponse_SEUser]

ALTER TABLE [dbo].[SEFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEFormPromptResponse_SEStudentGrowthGoal] FOREIGN KEY([StudentGrowthGoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])

ALTER TABLE [dbo].[SEFormPromptResponse] CHECK CONSTRAINT [FK_SEFormPromptResponse_SEStudentGrowthGoal]

ALTER TABLE dbo.SESchoolConfiguration ADD IsStudentGrowthProcessSettingsDelegated BIT NOT NULL DEFAULT(0)

ALTER TABLE [dbo].[SEStudentGrowthProcessSettings]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])

ALTER TABLE [dbo].[SEStudentGrowthProcessSettings] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_SEEvaluationType]

ALTER TABLE [dbo].[SEStudentGrowthProcessSettings]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])


ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_Settings] FOREIGN KEY([ProcessSettingsID])
REFERENCES [dbo].[SEStudentGrowthProcessSettings] ([StudentGrowthProcessSettingsID])
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_Settings]


ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_FormPrompt] FOREIGN KEY([FormPromptID])
REFERENCES [dbo].[SEFormPrompt] ([FormPromptID])
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_FormPrompt]


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


