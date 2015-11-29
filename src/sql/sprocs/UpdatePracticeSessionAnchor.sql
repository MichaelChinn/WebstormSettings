if exists (select * from sysobjects 
where id = object_id('dbo.UpdatePracticeSessionAnchor') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdatePracticeSessionAnchor.'
      drop procedure dbo.UpdatePracticeSessionAnchor
   END
GO
PRINT '.. Creating sproc UpdatePracticeSessionAnchor.'
GO
CREATE PROCEDURE UpdatePracticeSessionAnchor
	 @pPracticeSessionID BIGINT
	,@pAnchorEvalSessionID BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

UPDATE dbo.SEPracticeSession
	SET AnchorSessionID=@pAnchorEvalSessionID
WHERE PracticeSessionID=@pPracticeSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEPracticeSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

UPDATE es
   SET es.EvaluationScoreTypeID=3 -- change to drift detect
  FROM dbo.SEEvalSession es
  JOIN dbo.SEPracticeSessionParticipant psp
    ON es.EvalSessionID=psp.EvalSessionID
 WHERE es.EvaluationScoreTypeID=2 -- was anchor
   AND psp.PracticeSessionID=@pPracticeSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

UPDATE SEEvalSession
   SET EvaluationScoreTypeID=2 -- anchor
 WHERE EvalSessionID=@pAnchorEvalSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
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


