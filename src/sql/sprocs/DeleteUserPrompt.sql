if exists (select * from sysobjects 
where id = object_id('dbo.DeleteUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteUserPrompt.'
      drop procedure dbo.DeleteUserPrompt
   END
GO
PRINT '.. Creating sproc DeleteUserPrompt.'
GO
CREATE PROCEDURE DeleteUserPrompt
	 @pUserPromptID BIGINT
	
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


DELETE dbo.SEUserPromptRubricRowAlignment
 WHERE UserPromptID=@pUserPromptID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptRubricRowAlignment  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


DELETE dbo.SEUserPromptResponseEntry
  FROM dbo.SEUserPromptResponseEntry re
  JOIN dbo.SEUserPromptResponse r ON re.UserPromptResponseID=r.UserPromptResponseID
 WHERE r.UserPromptID=@pUserPromptID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponseEntry  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


DELETE dbo.SEUserPromptResponse
 WHERE UserPromptID=@pUserPromptID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEUserPrompt
 WHERE UserPromptID=@pUserPromptID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPrompt  failed. In: ' 
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


