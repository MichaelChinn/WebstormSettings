if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalSessionIsComplete') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalSessionIsComplete.'
      drop procedure dbo.UpdateEvalSessionIsComplete
   END
GO
PRINT '.. Creating sproc UpdateEvalSessionIsComplete.'
GO
CREATE PROCEDURE UpdateEvalSessionIsComplete
	 @pSessionID BIGINT
	,@pPreConfIsComplete BIT = NULL
	,@pObserveIsComplete BIT = NULL
	,@pPostConfIsComplete BIT = NULL
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



-- this will update the drift-defect sessions to
--- stay in sync with their anchor session

UPDATE dbo.SEEvalSession
	SET PreConfIsComplete=ISNULL(@pPreConfIsComplete, PreConfIsComplete)
	   ,ObserveIsComplete=ISNULL(@pObserveIsComplete, ObserveIsComplete)
	   ,PostConfIsComplete=ISNULL(@pPostConfIsComplete, PostConfIsComplete)
WHERE EvalSessionID=@pSessionID
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


