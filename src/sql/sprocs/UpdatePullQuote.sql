if exists (select * from sysobjects 
where id = object_id('dbo.UpdatePullQuote') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdatePullQuote.'
      drop procedure dbo.UpdatePullQuote
   END
GO
PRINT '.. Creating sproc UpdatePullQuote.'
GO
CREATE PROCEDURE UpdatePullQuote
	 @pPullQuoteID BIGINT
	,@pIsImportant bit
	,@pQuote VARCHAR(MAX)
		
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

DECLARE @ID bigint

update dbo.SEPullQuote 
set [Quote]=@pQuote
where PullQuoteID = @pPullQuoteID

SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not set/unset pullquote imporantance. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT * from dbo.vPullQuote where PullQuoteID = @ID

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


