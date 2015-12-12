
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

select @bugFixed = 71630088
, @title = 'Db Cleanup'
, @comment = ''


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
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

ALTER TABLE dbo.SEEvalSession DROP CONSTRAINT FK_SEEvalSession_SEEvaluation
ALTER TABLE dbo.SEEvalSession DROP COLUMN EvaluationID
ALTER TABLE SETrainingProtocol DROP COLUMN VideoName

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('SEEvaluation') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'Locked' AND object_id = OBJECT_ID(N'SEEvaluation'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE SEEvaluation DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('SEEvaluation') AND name='Locked')
EXEC('ALTER TABLE SEEvaluation DROP COLUMN Locked')

SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('SEEvaluation') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ModifyDate' AND object_id = OBJECT_ID(N'SEEvaluation'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE SEEvaluation DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('SEEvaluation') AND name='ModifyDate')
EXEC('ALTER TABLE SEEvaluation DROP COLUMN ModifyDate')

ALTER TABLE dbo.SEEvaluation DROP COLUMN LockUserID
ALTER TABLE dbo.SEEvaluation DROP COLUMN LockDate
ALTER TABLE dbo.SEEvaluation DROP COLUMN CreatedBy

ALTER TABLE [dbo].[SEArtifact]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifact_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

-- this is nocheck because the SEUserID sample records are created later
ALTER TABLE [dbo].[SEUserPrompt]  WITH NOCHECK ADD  CONSTRAINT [FK_SEUserPrompt_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptRubricRowAlignment_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE dbo.SESummativeFrameworkNodeScore DROP CONSTRAINT FK_SESummativeFrameworkNodeScore_SEUser1
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEUserID] FOREIGN KEY([SEUserID])
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

GO
