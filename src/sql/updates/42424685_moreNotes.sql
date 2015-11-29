
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 42424685
, @title = 'More Notes - Part 2'
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
DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
	
-- Rubric Notes
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'RubricNotes', 'Notes', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'RubricNotes', 'Notes', '', '', 2, 1, @theDate, 0, 2, 0)

-- Rubric Recommendations
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'RubricRecommendations', 'Recommendations', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'RubricRecommendations', 'Recommendations', '', '', 2, 1, @theDate, 0, 2, 0)

DECLARE @UserPromptID BIGINT

-- insert notes for all existing sessions
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricNotes'
   AND EvaluationTypeID=1
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID)
SELECT @UserPromptID
      ,s.EvaluateeUserID
      ,s.EvalSessionID
  FROM dbo.SEEvalSession s
 WHERE s.EvaluationTypeID=1
   AND s.EvaluateeUserID IS NOT NULL

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricNotes'
   AND EvaluationTypeID=2
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID)
SELECT @UserPromptID
      ,s.EvaluateeUserID
      ,s.EvalSessionID
  FROM dbo.SEEvalSession s
 WHERE s.EvaluationTypeID=2
   AND s.EvaluateeUserID IS NOT NULL
   
-- insert recommendations for all existing sessions
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricRecommendations'
   AND EvaluationTypeID=1
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID)
SELECT @UserPromptID
      ,s.EvaluateeUserID
      ,s.EvalSessionID
  FROM dbo.SEEvalSession s
 WHERE s.EvaluationTypeID=1
   AND s.EvaluateeUserID IS NOT NULL

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricRecommendations'
   AND EvaluationTypeID=2
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID)
SELECT @UserPromptID
      ,s.EvaluateeUserID
      ,s.EvalSessionID
  FROM dbo.SEEvalSession s
 WHERE s.EvaluationTypeID=2
   AND s.EvaluateeUserID IS NOT NULL
   
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


