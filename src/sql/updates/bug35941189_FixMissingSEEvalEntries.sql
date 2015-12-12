
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

select @bugFixed = 35941189
, @title = 'bug35941189_FixMissingSEEvalEntries'
, @comment = 'users logging multiple times, first as non tee, then as tee'


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2461
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug2)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug2 AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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

DECLARE @EvalID BIGINT, @seUserID BIGINT, @pEvaluationTYpe SMALLINT
, @pSchoolYear INTEGER, @userPromptID bigint

select @pSchoolYear = 2013

IF EXISTS (												-- this is so we only do this on production
	SELECT seUserID FROM seUser u 
	JOIN aspnet_users au ON au.userID =u.ASPNetUserID
	WHERE seUserID = 1182 AND au.userName = '22977_edsUser'
	) 
BEGIN

	SELECT @seUserID = 783, @pEvaluationType = 2 
			INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, SchoolYear) VALUES(@seUserID, null, @pEvaluationType, @pSchoolYear)
			SELECT @EvalID=SCOPE_IDENTITY()
			INSERT dbo.SEEvalVisibility(EvaluationID) VALUES(@EvalID)
			SELECT @UserPromptID = UserPromptID FROM dbo.SEUserPrompt WHERE Title='EvaluationNotes' AND EvaluationTypeID=@pEvaluationType		 
			INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear) VALUES (@UserPromptID, @seUserID, @pSchoolYear)


	SELECT @seUserID = 1160, @pEvaluationType = 1 
			INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, SchoolYear) VALUES(@seUserID, null, @pEvaluationType, @pSchoolYear)
			SELECT @EvalID=SCOPE_IDENTITY()
			INSERT dbo.SEEvalVisibility(EvaluationID) VALUES(@EvalID)
			SELECT @UserPromptID = UserPromptID FROM dbo.SEUserPrompt WHERE Title='EvaluationNotes' AND EvaluationTypeID=@pEvaluationType		 
			INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear) VALUES (@UserPromptID, @seUserID, @pSchoolYear)

	SELECT @seUserID = 1182, @pEvaluationType = 1 
			INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, SchoolYear) VALUES(@seUserID, null, @pEvaluationType, @pSchoolYear)
			SELECT @EvalID=SCOPE_IDENTITY()
			INSERT dbo.SEEvalVisibility(EvaluationID) VALUES(@EvalID)
			SELECT @UserPromptID = UserPromptID FROM dbo.SEUserPrompt WHERE Title='EvaluationNotes' AND EvaluationTypeID=@pEvaluationType		 
			INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear) VALUES (@UserPromptID, @seUserID, @pSchoolYear)
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
