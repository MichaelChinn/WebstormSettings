
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 86142450
, @title = '86142450_SessionID_Data'
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

CREATE TABLE #Session(EvalSessionID BIGINT, SchoolYear SMALLINT, EvaluateeUserID BIGINT, RowNum SMALLINT)

INSERT INTO #Session(EvalSessionID, SchoolYear, EvaluateeUserID, RowNum)
SELECT 
   s.EvalSessionID, 
   s.SchoolYear, 
   s.EvaluateeUserID,
   ROW_NUMBER() OVER (PARTITION BY s.SchoolYear, s.EvaluateeUserID ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID)
  FROM SEEvalSession s
 WHERE s.EvaluateeUserID IS NOT NULL
   AND s.EvaluationScoreTypeID = 1
   AND s.IsSelfAssess=0
 ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID
 
 UPDATE s 
    SET s.SessionKey=s2.RowNum
   FROM dbo.SEEvalSession s
   JOIN dbo.#Session s2 ON s.EvalSessionID=s2.EvalSessionID
  
DELETE #Session 
INSERT INTO #Session(EvalSessionID, SchoolYear, EvaluateeUserID, RowNum)
SELECT 
   s.EvalSessionID, 
   s.SchoolYear, 
   s.EvaluateeUserID,
   ROW_NUMBER() OVER (PARTITION BY s.SchoolYear, s.EvaluateeUserID ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID)
  FROM SEEvalSession s
 WHERE s.EvaluateeUserID IS NOT NULL
   AND s.EvaluationScoreTypeID = 1
   AND s.IsSelfAssess=1
 ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID
 
 UPDATE s 
    SET s.SessionKey=s2.RowNum
   FROM dbo.SEEvalSession s
   JOIN dbo.#Session s2 ON s.EvalSessionID=s2.EvalSessionID
   

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


