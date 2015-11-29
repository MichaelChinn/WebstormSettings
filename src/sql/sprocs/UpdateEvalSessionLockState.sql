if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalSessionLockState') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalSessionLockState.'
      drop procedure dbo.UpdateEvalSessionLockState
   END
GO
PRINT '.. Creating sproc UpdateEvalSessionLockState.'
GO
CREATE PROCEDURE UpdateEvalSessionLockState
	 @pSessionID BIGINT
	,@pLockStateID SMALLINT
	,@pSeattleDistrictCode VARCHAR(20) = null
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

UPDATE dbo.SEEvalSession
	SET EvalSessionLockStateID=@pLockStateID
WHERE EvalSessionID=@pSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- special case for Seattle SD
IF (@pLockStateID = 2 AND @pSeattleDistrictCode IS NOT NULL) -- Lock
BEGIN

UPDATE dbo.SEEvalSession
	SET PreConfIsPublic=1
	   ,ObserveIsPublic=1
	   ,PostConfIsPublic=1
	   ,ObserveIsComplete=1
	   ,LockDateTime=GETDATE()
WHERE EvalSessionID=@pSessionID
  AND DistrictCode=@pSeattleDistrictCode
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

-- special case for Seattle SD
IF (@pLockStateID = 1 AND @pSeattleDistrictCode IS NOT NULL) -- Lock
BEGIN

UPDATE dbo.SEEvalSession
	SET PreConfIsComplete=0
	   ,ObserveIsComplete=0
	   ,PostConfIsComplete=0
WHERE EvalSessionID=@pSessionID
  AND DistrictCode=@pSeattleDistrictCode
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

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


