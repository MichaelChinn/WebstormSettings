if exists (select * from sysobjects 
where id = object_id('dbo.UpdateFrameworkNodeObservationNotes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateFrameworkNodeObservationNotes.'
      drop procedure dbo.UpdateFrameworkNodeObservationNotes
   END
GO
PRINT '.. Creating sproc UpdateFrameworkNodeObservationNotes.'
GO
CREATE PROCEDURE UpdateFrameworkNodeObservationNotes
	 @pFrameworkNodeID BIGINT
	,@pSessionID   BIGINT
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

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION
				  
IF NOT EXISTS(SELECT @pFrameworkNodeID 
                FROM dbo.[SEFrameworkNodeObservationNotes]
               WHERE FrameworkNodeID=@pFrameworkNodeID
                 AND EvalSessionID=@pSessionID)
BEGIN
	INSERT dbo.[SEFrameworkNodeObservationNotes](FrameworkNodeID, EvalSessionID, Notes)
	VALUES (@pFrameworkNodeID, @pSessionID, @pNotes)
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert to SEFrameworkNodeObservationNotes  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN


UPDATE dbo.[SEFrameworkNodeObservationNotes]
	SET Notes=@pNotes
WHERE FrameworkNodeID=@pFrameworkNodeID
  AND EvalSessionID=@pSessionID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEFrameworkNodeObservationNotes  failed. In: ' 
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


