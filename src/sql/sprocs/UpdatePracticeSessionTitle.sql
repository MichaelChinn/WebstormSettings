if exists (select * from sysobjects 
where id = object_id('dbo.UpdatePracticeSessionTitle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdatePracticeSessionTitle.'
      drop procedure dbo.UpdatePracticeSessionTitle
   END
GO
PRINT '.. Creating sproc UpdatePracticeSessionTitle.'
GO
CREATE PROCEDURE UpdatePracticeSessionTitle
	 @pPracticeSessionID	BIGINT
	,@pTitle				VARCHAR(50)
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
   SET Title=@pTitle
 WHERE PracticeSessionID=@pPracticeSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEPracticeSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


UPDATE dbo.SEEvalSession
	SET Title=@pTitle
   FROM dbo.SEPracticeSessionParticipant p
WHERE p.PracticeSessionID=@pPracticeSessionID
  AND SEEvalSession.EvalSessionID=p.EvalSessionID
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


