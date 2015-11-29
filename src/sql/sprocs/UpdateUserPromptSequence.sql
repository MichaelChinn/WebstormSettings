if exists (select * from sysobjects 
where id = object_id('dbo.UpdateUserPromptSequence') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateUserPromptSequence.'
      drop procedure dbo.UpdateUserPromptSequence
   END
GO
PRINT '.. Creating sproc UpdateUserPromptSequence.'
GO
CREATE PROCEDURE UpdateUserPromptSequence
	 @pUserPromptID BIGINT
	,@pNewSequence smallint
	,@pDebug BIT = 0
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

UPDATE dbo.SEUserPrompt 
SET Sequence = @pNewSequence 
WHERE UserPromptID = @pUserPromptID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEUserPrompt Sequence Number  failed. In: ' 
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


