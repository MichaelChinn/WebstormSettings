if exists (select * from sysobjects 
where id = object_id('dbo.SendMessage') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SendMessage.'
      drop procedure dbo.SendMessage
   END
GO
PRINT '.. Creating sproc SendMessage.'
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SendMessage
	 @pSenderID BIGINT
	 ,@pSender NVARCHAR(256)
	 ,@pRecipients NVARCHAR(1000)
	 ,@pSubject NVARCHAR(500)
	 ,@pBody TEXT
	 ,@pMessageTypeID SMALLINT
	 ,@pSchoolYear SMALLINT

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



DECLARE @Id AS BIGINT, @theDate DATETIME
SELECT @theDate = GETDATE()

INSERT dbo.Message(SenderID, Sender, RecipientUsers, Subject, Body, MessageTypeID, SEndTime, HasAttachments, Importance, SchoolYear)
VALUES(@pSenderID, @pSEnder, @pRecipients, @pSubject, @pBody, @pMessageTypeID, @theDate, 0, 0, @pSchoolYear)

SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to Message  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DECLARE @xmlString XML

CREATE TABLE #r (recipientID BIGINT)

SELECT @xmlString = N'<root><r>' + replace(@pRecipients,';','</r><r>') + '</r></root>'

INSERT #r (recipientID)
SELECT t.value('.','bigint') AS [recId]
from @xmlString.nodes('//root/r') AS a(t)


INSERT dbo.MessageHeader(
		MessageID,
		SenderID, 
		Sender, 
		RecipientID, 
		Subject, 
		MessageTypeID, 
		SEndTime, 
		IsRead, 
		DELETED, 
		StateFlag, 
		EmailSent, 
		SchoolYear)
SELECT  @ID,
		@pSenderID,
		@pSender,
		RecipientID,
		@pSubject,
		@pMessageTypeID,
		@theDate,
		0,
		0,
		0,
		0,
		@pSchoolYear
  FROM dbo.#r

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to MessageHeader  failed. In: ' 
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


