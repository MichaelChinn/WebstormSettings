
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 66375272
, @title = 'Goals Schema 2014-2015'
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

CREATE TABLE [dbo].[SEGoalTemplateType](
	[GoalTemplateTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_SEGoalTemplateType] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEGoalTemplateType]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateType_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
ALTER TABLE [dbo].[SEGoalTemplateType] CHECK CONSTRAINT [FK_SEGoalTemplateType_SEEvaluationType]

ALTER TABLE [dbo].[SEGoalTemplateType]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateType_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
ALTER TABLE [dbo].[SEGoalTemplateType] CHECK CONSTRAINT [FK_SEGoalTemplateType_SESchoolYear]


CREATE TABLE [dbo].[SEGoalProcessStepType](
	[GoalProcessStepTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[RRShortName] [varchar](20) NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[GoalTemplateTypeID] [smallint] NOT NULL
 CONSTRAINT [PK_SEGoalProcessStepType] PRIMARY KEY CLUSTERED 
(
	[GoalProcessStepTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SEGoalProcessStepType]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalProcessStepType_SchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
ALTER TABLE [dbo].[SEGoalProcessStepType] CHECK CONSTRAINT [FK_SEGoalProcessStepType_SchoolYear]

ALTER TABLE [dbo].[SEGoalProcessStepType]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalProcessStepType_EvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
ALTER TABLE [dbo].[SEGoalProcessStepType] CHECK CONSTRAINT [FK_SEGoalProcessStepType_EvaluationType]

ALTER TABLE [dbo].[SEGoalProcessStepType]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalProcessStepType_GoalTemplateType] FOREIGN KEY([GoalTemplateTypeID])
REFERENCES [dbo].[SEGoalTemplateType] ([GoalTemplateTypeID])
ALTER TABLE [dbo].[SEGoalProcessStepType] CHECK CONSTRAINT [FK_SEGoalProcessStepType_GoalTemplateType]


CREATE TABLE [dbo].[SEGoalTemplate](
	[GoalTemplateID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalTemplateTypeID] [smallint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SEGoalTemplate] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEGoalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SEEvaluationType1] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
ALTER TABLE [dbo].[SEGoalTemplate] CHECK CONSTRAINT [FK_SEGoalTemplate_SEEvaluationType1]
ALTER TABLE [dbo].[SEGoalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SEGoalTemplateType] FOREIGN KEY([GoalTemplateTypeID])
REFERENCES [dbo].[SEGoalTemplateType] ([GoalTemplateTypeID])
ALTER TABLE [dbo].[SEGoalTemplate] CHECK CONSTRAINT [FK_SEGoalTemplate_SEGoalTemplateType]
ALTER TABLE [dbo].[SEGoalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SESchoolYear1] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
ALTER TABLE [dbo].[SEGoalTemplate] CHECK CONSTRAINT [FK_SEGoalTemplate_SESchoolYear1]
ALTER TABLE [dbo].[SEGoalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEGoalTemplate] CHECK CONSTRAINT [FK_SEGoalTemplate_SEUser]


CREATE TABLE [dbo].[SEGoalTemplateProcessStep](
	[GoalTemplateProcessStepID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalTemplateID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NULL,
	[GoalProcessStepTypeID] [smallint] NOT NULL,
	[Response] [varchar] (MAX) NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_SEGoalTemplateProcess] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateProcessStepID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEGoalTemplateProcessStep]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateProcessStep_GoalTemplateID] FOREIGN KEY([GoalTemplateID])
REFERENCES [dbo].[SEGoalTemplate] ([GoalTemplateID])
ALTER TABLE [dbo].[SEGoalTemplateProcessStep] CHECK CONSTRAINT [FK_SEGoalTemplateProcessStep_GoalTemplateID]

ALTER TABLE [dbo].[SEGoalTemplateProcessStep]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateProcessStep_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEGoalTemplateProcessStep] CHECK CONSTRAINT [FK_SEGoalTemplateProcessStep_RubricRowID]

ALTER TABLE [dbo].[SEGoalTemplateProcessStep]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateProcessStep_GoalProcessStepTypeID] FOREIGN KEY([GoalProcessStepTypeID])
REFERENCES [dbo].[SEGoalProcessStepType] ([GoalProcessStepTypeID])
ALTER TABLE [dbo].[SEGoalTemplateProcessStep] CHECK CONSTRAINT [FK_SEGoalTemplateProcessStep_GoalProcessStepTypeID]


CREATE TABLE [dbo].[SEGoalTemplateRubricRowScore] (
	[GoalTemplateRubricRowScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalTemplateID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[UserID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEGoalTemplateRubricRowScore] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateRubricRowScoreID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateRubricRowScore_SEGoalTemplateID] FOREIGN KEY([GoalTemplateID])
REFERENCES [dbo].[SEGoalTemplate] ([GoalTemplateID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore] CHECK CONSTRAINT [FK_SEGoalTemplateRubricRowScore_SEGoalTemplateID]

ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateRubricRowScore_PerformanceLevelID] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore] CHECK CONSTRAINT [FK_SEGoalTemplateRubricRowScore_PerformanceLevelID]

ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateRubricRowScore_UserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore] CHECK CONSTRAINT [FK_SEGoalTemplateRubricRowScore_UserID]

ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateRubricRowScore_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowScore] CHECK CONSTRAINT [FK_SEGoalTemplateRubricRowScore_RubricRowID]


CREATE TABLE [dbo].[SEGoalTemplateGoal](
	[GoalTemplateGoalID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalTemplateID] [bigint] NOT NULL,
	[GoalStatement] [varchar](max) NOT NULL,
	[RubricRowID] [bigint] NULL,
	[Outcome] [varchar] (MAX) NOT NULL,
	[Reflection] [varchar] (MAX) NOT NULL,
 CONSTRAINT [PK_SEGoalTemplateGoal] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateGoalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SEGoalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateGoal_SEGoalTemplate] FOREIGN KEY([GoalTemplateID])
REFERENCES [dbo].[SEGoalTemplate] ([GoalTemplateID])
ALTER TABLE [dbo].[SEGoalTemplateGoal] CHECK CONSTRAINT [FK_SEGoalTemplateGoal_SEGoalTemplate]

ALTER TABLE [dbo].[SEGoalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplateGoal_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEGoalTemplateGoal] CHECK CONSTRAINT [FK_SEGoalTemplateGoal_SERubricRow]

CREATE TABLE [dbo].[SEGoalTemplateRubricRowAlignment](
	[GoalTemplateRubricRowAlignmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalTemplateID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEGoalTemplateRubricRowAlignment] PRIMARY KEY CLUSTERED 
(
	[GoalTemplateRubricRowAlignmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	
ALTER TABLE [dbo].[SEGoalTemplateRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SEGoalTemplate] FOREIGN KEY([GoalTemplateID])
REFERENCES [dbo].[SEGoalTemplate] ([GoalTemplateID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowAlignment] CHECK CONSTRAINT [FK_SEGoalTemplate_SEGoalTemplate]

ALTER TABLE [dbo].[SEGoalTemplateRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalTemplate_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEGoalTemplateRubricRowAlignment] CHECK CONSTRAINT [FK_SEGoalTemplate_SERubricRow]

	
ALTER TABLE [dbo].[SEUserPromptResponse] ADD GoalTemplateGoalID BIGINT NULL
ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_GoalTemplateGoalID] FOREIGN KEY([GoalTemplateGoalID])
REFERENCES [dbo].[SEGoalTemplateGoal] ([GoalTemplateGoalID])
ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_GoalTemplateGoalID]

ALTER TABLE [dbo].[SEArtifact] ADD GoalTemplateGoalID BIGINT NULL
ALTER TABLE [dbo].[SEArtifact]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifact_GoalTemplateGoalID] FOREIGN KEY([GoalTemplateGoalID])
REFERENCES [dbo].[SEGoalTemplateGoal] ([GoalTemplateGoalID])
ALTER TABLE [dbo].[SEArtifact] CHECK CONSTRAINT [FK_SEArtifact_GoalTemplateGoalID]

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


