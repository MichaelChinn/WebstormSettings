if exists (select * from sysobjects 
where id = object_id('dbo.UpdateUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateUserPrompt.'
      drop procedure dbo.UpdateUserPrompt
   END
GO
PRINT '.. Creating sproc UpdateUserPrompt.'
GO
CREATE PROCEDURE UpdateUserPrompt
	 @pUserPromptID BIGINT,
	 @pTitle VARCHAR(200),
	 @pQuestion VARCHAR(MAX),
	 @pRetired BIT,
	 @pPrivate BIT
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

DECLARE @TheDate DATETIME
SELECT @TheDate = GETDATE()

UPDATE dbo.SEUserPrompt
   SET Title=@pTitle,
	   Retired=@pRetired,
       [Private]=@pPrivate,
       Prompt=@pQuestion,
       EvalSessionID=CASE WHEN (@pPrivate=0) THEN NULL ELSE EvalSessionID END,
       EvaluateeID=CASE WHEN (@pPrivate=0) THEN NULL ELSE EvaluateeID END
 WHERE UserPromptID=@pUserPromptID
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEUserPrompt  failed. In: ' 
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


