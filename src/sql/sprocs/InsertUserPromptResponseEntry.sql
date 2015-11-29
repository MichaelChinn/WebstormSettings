if exists (select * from sysobjects 
where id = object_id('dbo.InsertUserPromptResponseEntry') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertUserPromptResponseEntry.'
      drop procedure dbo.InsertUserPromptResponseEntry
   END
GO
PRINT '.. Creating sproc InsertUserPromptResponseEntry.'
GO
CREATE PROCEDURE InsertUserPromptResponseEntry
	@pUserPromptResponseID BIGINT,
	@pResponse VARCHAR(MAX),
	@pUserID BIGINT


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

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()

INSERT dbo.SEUserPromptResponseEntry(UserPromptResponseID, Response, UserID, CreationDateTime)
VALUES(@pUserPromptResponseID, @pResponse, @pUserID, @theDate)

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponseEntry  failed. In: ' 
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


