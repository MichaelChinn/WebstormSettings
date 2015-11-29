if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalSessionSchedule') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalSessionSchedule.'
      drop procedure dbo.UpdateEvalSessionSchedule
   END
GO
PRINT '.. Creating sproc UpdateEvalSessionSchedule.'
GO
CREATE PROCEDURE UpdateEvalSessionSchedule
	 @pSessionID BIGINT
	,@pStartTime DATETIME
	,@pEndTime DATETIME
	,@pLocation VARCHAR(200) = NULL
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

IF (@pLocation IS NULL)
BEGIN

UPDATE dbo.SEEvalSession
   SET StartTime=@pStartTime
	  ,EndTime=@pEndTIme
 WHERE EvalSessionID=@pSessionID

END
ELSE
BEGIN

UPDATE dbo.SEEvalSession
   SET StartTime=@pStartTime
	  ,EndTime=@pEndTIme
	  ,Location=@pLocation
WHERE EvalSessionID=@pSessionID

END

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


