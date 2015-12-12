/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 102808022
, @title = '102808022_rubricevaluation'
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

CREATE TABLE [dbo].[SELinkedItemType](
	[LinkedItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SELinkedItemType] PRIMARY KEY CLUSTERED 
(
	[LinkedItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SERubricRowEvaluation](
	[RubricRowEvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[LinkedItemTypeID] [smallint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[LinkedObservationID] [bigint] NULL,
	[LinkedArtifactBundleID] [bigint] NULL,
	[LinkedStudentGrowthGoalID] [bigint] NULL,
	[LinkedSelfAssessmentID] [bigint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[WfStateID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL
 CONSTRAINT [PK_SERubricRowEvaluation] PRIMARY KEY CLUSTERED 
(
	[RubricRowEvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SERubricRowEvaluationEvidence](
	[RubricRowEvaluationEvidenceID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowEvaluationID] [bigint] NOT NULL,
	[RubricStatement] [varchar](max) NOT NULL,
	[Evidence] [varchar](max) NOT NULL,
	[StatementPerformanceLevelID] [smallint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[EvaluationID] [bigint] not null, 
 CONSTRAINT [PK_SERubricRowEvaluationEvidence] PRIMARY KEY CLUSTERED 
(
	[RubricRowEvaluationEvidenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[SERubricRowEvaluationEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluationEvidence_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
ALTER TABLE [dbo].[SERubricRowEvaluationEvidence] CHECK CONSTRAINT [FK_SERubricRowEvaluationEvidence_SEEvaluation]

ALTER TABLE [dbo].[SERubricRowEvaluationEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SERubricRowEvaluationEvidence] CHECK CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricRow]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEWfState]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEArtifactBundle] FOREIGN KEY([LinkedArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEArtifactBundle]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession] FOREIGN KEY([LinkedObservationID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession1] FOREIGN KEY([LinkedSelfAssessmentID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession1]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvaluation]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SELinkedItemType] FOREIGN KEY([LinkedItemTypeID])
REFERENCES [dbo].[SELinkedItemType] ([LinkedItemTypeID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SELinkedItemType]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SERubricPerformanceLevel]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SERubricRow]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEStudentGrowthGoal] FOREIGN KEY([LinkedStudentGrowthGoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEStudentGrowthGoal]

ALTER TABLE [dbo].[SERubricRowEvaluationEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricPerformanceLevel] FOREIGN KEY([StatementPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
ALTER TABLE [dbo].[SERubricRowEvaluationEvidence] CHECK CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricPerformanceLevel]

ALTER TABLE [dbo].[SERubricRowEvaluationEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricRowEvaluation] FOREIGN KEY([RubricRowEvaluationID])
REFERENCES [dbo].[SERubricRowEvaluation] ([RubricRowEvaluationID])
ALTER TABLE [dbo].[SERubricRowEvaluationEvidence] CHECK CONSTRAINT [FK_SERubricRowEvaluationEvidence_SERubricRowEvaluation]

ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEUser]

SET IDENTITY_INSERT [dbo].[SEWfState] ON
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (18, N'RREVAL_NOT_STARTED', N'RREVAL_NOT_STARTED', N'RREVAL_NOT_STARTED')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (19, N'RREVAL_IN_PROGRESS', N'RREVAL_IN_PROGRESS', N'RREVAL_IN_PROGRESS')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (20, N'RREVAL_DONE', N'RREVAL_DONE', N'RREVAL_DONE')
SET IDENTITY_INSERT [dbo].[SEWfState] OFF

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


