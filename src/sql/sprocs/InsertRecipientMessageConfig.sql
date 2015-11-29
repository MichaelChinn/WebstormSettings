if exists (select * from sysobjects 
where id = object_id('dbo.InsertRecipientMessageConfig') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertRecipientMessageConfig.'
      drop procedure dbo.InsertRecipientMessageConfig
   END
GO
PRINT '.. Creating sproc InsertRecipientMessageConfig.'
GO
CREATE PROCEDURE InsertRecipientMessageConfig
	@pRecipientID BIGINT
	,@sql_error_message VARCHAR(500) OUTPUT

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT


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


INSERT dbo.MessageTypeRecipientConfig(
						RecipientID,
						MessageTypeID,
						Inbox,
						EmailDeliveryTypeID)
SELECT @pRecipientID,
	   m.MessageTypeID,
	   1,
	   1
  FROM dbo.MessageType m
  
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert into MessageTypeRecipientConfig. In: ' 
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


