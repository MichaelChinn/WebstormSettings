
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 83903402
, @title = '83903402_finalSubmissionWF'
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

CREATE TABLE [dbo].[SEWfState](
	[WfStateID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Description] [varchar](200) NULL,
	[ShortName] [varchar](20) NULL,
 CONSTRAINT [PK_SEWfState] PRIMARY KEY CLUSTERED 
(
	[WfStateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] ADD StatementOfPerformance VARCHAR(MAX) DEFAULT('')

ALTER TABLE [dbo].[SEEvalSession] ADD IncludeInFinalReport BIT DEFAULT(0)

ALTER TABLE [dbo].[SEEvaluation] ADD WfStateID BIGINT NULL
ALTER TABLE [dbo].[SEEvaluation] ADD NextYearEvaluateePlanTypeID SMALLINT NULL
ALTER TABLE [dbo].[SEEvaluation] ADD NextYearFocusedFrameworkNodeID BIGINT NULL
ALTER TABLE [dbo].[SEEvaluation] ADD NextYearFocusedSGFrameworkNodeID BIGINT NULL
ALTER TABLE [dbo].[SEEvaluation] ADD ByPassSGScores BIT DEFAULT(0)
ALTER TABLE [dbo].[SEEvaluation] ADD SGScoreOverrideComment VARCHAR(200) DEFAULT('')
ALTER TABLE [dbo].[SEEvaluation] ADD VisibleToEvaluatee BIT DEFAULT(0)
ALTER TABLE [dbo].[SEEvaluation] ADD AutoSubmitAfterReceipt BIT DEFAULT(1)
ALTER TABLE [dbo].[SEEvaluation] ADD ByPassReceipt BIT DEFAULT(0)
ALTER TABLE [dbo].[SEEvaluation] ADD ByPassReceiptOverrideComment VARCHAR(200) DEFAULT('')
ALTER TABLE [dbo].[SEEvaluation] ADD DropToPaper BIT DEFAULT(0)
ALTER TABLE [dbo].[SEEvaluation] ADD DropToPaperOverrideComment VARCHAR(200) DEFAULT('')
ALTER TABLE [dbo].[SEEvaluation] ADD MarkedFinalDateTime DATETIME
ALTER TABLE [dbo].[SEEvaluation] ADD FinalReportRepositoryItemID BIGINT NULL
ALTER TABLE [dbo].[SEEvaluation] ADD EvaluateeReflections VARCHAR(MAX) DEFAULT('')
ALTER TABLE [dbo].[SEEvaluation] ADD EvaluatorRecommendations VARCHAR(MAX) DEFAULT('')
ALTER TABLE [dbo].[SEEvaluation] ADD EvaluateeReflectionsIsPublic BIT DEFAULT(0)
ALTER TABLE [dbo].[SEEvaluation] ADD SubmissionCount SMALLINT DEFAULT(0)

DECLARE @QUERY VARCHAR(MAX)
SELECT @Query = 'UPDATE SEEvaluation SET ByPassSGScores=0, SGScoreOverrideComment='''', VisibleToEvaluatee=0, AutoSubmitAfterReceipt=1, ByPassReceipt=0, ByPassReceiptOverrideComment=0, DropToPaper=0, DropToPaperOverrideComment='''', EvaluateeReflections='''', EvaluatorRecommendations='''', EvaluateeReflectionsIsPublic=0, SubmissionCount=0'
EXECUTE (@QUERY)

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType2] FOREIGN KEY([NextYearEvaluateePlanTypeID])
REFERENCES [dbo].[SEEvaluateePlanType] ([EvaluateePlanTypeID])
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEFrameworkNode3] FOREIGN KEY([NextYearFocusedFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEFrameworkNode4] FOREIGN KEY([NextYearFocusedSGFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])

CREATE TABLE [dbo].[SEWfTransition](
	[WfTransitionID] [bigint] IDENTITY(1,1) NOT NULL,
	[StartStateID] [bigint] NOT NULL,
	[EndStateID] [bigint] NOT NULL,
	[Description] [varchar](200) NULL,
 CONSTRAINT [PK_SEWfTransition] PRIMARY KEY CLUSTERED 
(
	[WfTransitionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEWfTransition]  WITH CHECK ADD  CONSTRAINT [FK_SEWfTransition_SEWfState1] FOREIGN KEY([StartStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])

ALTER TABLE [dbo].[SEWfTransition]  WITH CHECK ADD  CONSTRAINT [FK_SEWfTransition_SEWfState2] FOREIGN KEY([EndStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])

CREATE TABLE [dbo].[SEEvaluationWfHistory](
	[EvaluationWfHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[WfTransitionID] [bigint] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[Comment] [text] NULL,
 CONSTRAINT [PK_SEEvaluationWfHistory] PRIMARY KEY CLUSTERED 
(
	[EvaluationWfHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])

ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEWfTransition] FOREIGN KEY([WfTransitionID])
REFERENCES [dbo].[SEWfTransition] ([WfTransitionID])

ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEUser1] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

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


