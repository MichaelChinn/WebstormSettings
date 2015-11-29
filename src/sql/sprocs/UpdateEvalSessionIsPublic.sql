if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalSessionIsPublic') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalSessionIsPublic.'
      drop procedure dbo.UpdateEvalSessionIsPublic
   END
GO
PRINT '.. Creating sproc UpdateEvalSessionIsPublic.'
GO
CREATE PROCEDURE UpdateEvalSessionIsPublic
	 @pSessionID BIGINT
	,@pPreConfIsPublic BIT = NULL
	,@pObserveIsPublic BIT = NULL
	,@pPostConfIsPublic BIT = NULL
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
	SET PreConfIsPublic=ISNULL(@pPreConfIsPublic, PreConfIsPublic)
	   ,ObserveIsPublic=ISNULL(@pObserveIsPublic, ObserveIsPublic)
	   ,PostConfIsPublic=ISNULL(@pPostConfIsPublic, PostConfIsPublic)
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


