if exists (select * from sysobjects 
where id = object_id('dbo.MarkMessageSent') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc MarkMessageSent.'
      drop procedure dbo.MarkMessageSent
   END
GO
PRINT '.. Creating sproc MarkMessageSent.'
GO
CREATE PROCEDURE MarkMessageSent
	 @pMessageID BIGINT
AS
SET NOCOUNT ON 

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()

UPDATE dbo.MessageHeader
   SET EmailSent=1
      ,EmailSentDateTime=@theDate
  WHERE MessageID=@pMessageID

GO


