
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2704
, @title = 'EvaluationMap table, 5/7/2012'
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



IF NOT Exists(select * from sys.tables where Name = N'EvaluationMap' )
BEGIN

	CREATE TABLE [dbo].[EvaluationMap](
		[EvaluationMapID] [int] IDENTITY(1,1) NOT NULL,
		[EvaluatorID] [bigint] NOT NULL,
		[TargetUserID] [bigint] NOT NULL,
		[SchoolCode] [varchar](10) NULL,
		[DistrictCode] [varchar](10) NULL,
		[PrimaryEvaluator] [bit] NOT NULL,
		[FinalEvaluator] [bit] NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[ModifyDate] [datetime] NOT NULL,
	 CONSTRAINT [PK_EvaluationMap] PRIMARY KEY CLUSTERED 
	(
		[EvaluationMapID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed EvaluationMap table. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
	
	ALTER TABLE [dbo].[EvaluationMap]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationMap_Evaluatee] FOREIGN KEY([TargetUserID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[EvaluationMap] CHECK CONSTRAINT [FK_EvaluationMap_Evaluatee]

	ALTER TABLE [dbo].[EvaluationMap]  WITH CHECK ADD  CONSTRAINT [FK_EvaluationMap_Evaluator] FOREIGN KEY([EvaluatorID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[EvaluationMap] CHECK CONSTRAINT [FK_EvaluationMap_Evaluator]

	ALTER TABLE [dbo].[EvaluationMap] ADD  CONSTRAINT [DF_EvaluationMap_PrimaryEvaluator]  DEFAULT ((0)) FOR [PrimaryEvaluator]

	ALTER TABLE [dbo].[EvaluationMap] ADD  CONSTRAINT [DF_EvaluationMap_FinalEvaluator]  DEFAULT ((0)) FOR [FinalEvaluator]

	ALTER TABLE [dbo].[EvaluationMap] ADD  CONSTRAINT [DF_EvaluationMap_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]

	ALTER TABLE [dbo].[EvaluationMap] ADD  CONSTRAINT [DF_EvaluationMap_ModifyDate]  DEFAULT (getutcdate()) FOR [ModifyDate]

END


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed primary key updates to SEDistrictSchool and SERubrikRowScore tables. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END




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

GO

/*

select * from coeStudentSiteconfig
select * from updatelog


*/