
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 49034807
, @title = 'SEUserPrompt.SchoolYear'
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

ALTER TABLE dbo.SEUserPrompt ADD SchoolYear SMALLINT  NULL

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

DECLARE @Query VARCHAR(MAX)
SELECT @Query = 'UPDATE dbo.SEUserPrompt SET SchoolYear=2012 WHERE PublishedDate < CONVERT(DATETIME, ''2012-08-13 00:00:00.000'')'
EXEC(@Query)
SELECT @Query = 'UPDATE dbo.SEUserPrompt SET SchoolYear=2013 WHERE PublishedDate IS NULL OR PublishedDate > CONVERT(DATETIME, ''2012-08-13 00:00:00.000'')'
EXEC(@Query)

ALTER TABLE dbo.SEUserPromptResponse ADD DistrictCode VARCHAR(20) NULL
SELECT @Query = 
'UPDATE dbo.SEUserPromptResponse
   SET DistrictCode=u.DistrictCode
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.SEUser u ON r.EvaluateeID=u.SEUserID
'
EXEC (@Query)

ALTER TABLE dbo.SEUserPromptConferenceDefault ADD DistrictCode VARCHAR(20) NULL
SELECT @Query = 
'UPDATE dbo.SEUserPromptConferenceDefault
   SET DistrictCode=u.DistrictCode
  FROM dbo.SEUserPromptConferenceDefault d
  JOIN dbo.SEUser u ON d.EvaluateeID=u.SEUserID
'
EXEC (@Query)
  
  
SELECT @Query = 'ALTER TABLE SEUserPrompt ALTER COLUMN SchoolYear SMALLINT NOT NULL'
EXEC(@Query)
SELECT @Query = 'ALTER TABLE SEUserPromptResponse ALTER COLUMN DistrictCode VARCHAR(20) NOT NULL'
EXEC(@Query)
SELECT @Query = 'ALTER TABLE SEUserPromptConferenceDefault ALTER COLUMN DistrictCode VARCHAR(20) NOT NULL'
EXEC(@Query)
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


