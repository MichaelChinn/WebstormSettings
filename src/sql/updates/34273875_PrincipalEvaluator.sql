
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 97873478
, @title = 'Rubric Evidence'
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

CREATE TABLE [dbo].[SERubricEvidence](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NOT NULL,
	[RubricDescriptorText] [varchar](max) NOT NULL,
	[SupportingEvidenceText] [varchar](max) NULL,
	[RubricEvidenceTypeID] [smallint] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluateeId] [bigint] NOT NULL,
	[CreatedByUserId] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[IsPublic] [bit] NOT NULL,
 CONSTRAINT [PK_SERubricEvidence] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[SERubricEvidenceType](
	[ID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SERubricEvidenceEvidenceType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SEEvalSession]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SEEvaluationType]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SERubricPerformanceLevel]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SERubricRow]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SESchoolYear]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SEUser] FOREIGN KEY([EvaluateeId])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SEUser]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SEUser1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SEUser1]

ALTER TABLE [dbo].[SERubricEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SERubricEvidence_SERubricEvidenceType] FOREIGN KEY([RubricEvidenceTypeID])
REFERENCES [dbo].[SERubricEvidenceType] ([ID])

ALTER TABLE [dbo].[SERubricEvidence] CHECK CONSTRAINT [FK_SERubricEvidence_SERubricEvidenceType]




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



