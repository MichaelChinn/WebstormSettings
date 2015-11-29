if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalSessionObservationNotes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalSessionObservationNotes.'
      drop procedure dbo.UpdateEvalSessionObservationNotes
   END
GO
PRINT '.. Creating sproc UpdateEvalSessionObservationNotes.'
GO
CREATE PROCEDURE UpdateEvalSessionObservationNotes
	 @pSessionID BIGINT
	,@pNotes VARCHAR(MAX)
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

UPDATE dbo.SEEvalSession
	SET ObserveNotes=@pNotes
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


