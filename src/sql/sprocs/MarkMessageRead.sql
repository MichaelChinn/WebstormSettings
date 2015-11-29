if exists (select * from sysobjects 
where id = object_id('dbo.MarkMessageRead') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc MarkMessageRead.'
      drop procedure dbo.MarkMessageRead
   END
GO
PRINT '.. Creating sproc MarkMessageRead.'
GO
CREATE PROCEDURE MarkMessageRead
	 @pRecipientID BIGINT
	,@pMessageID BIGINT
AS
SET NOCOUNT ON 

UPDATE dbo.MessageHeader
   SET IsRead=1
      ,StateFlag = 2
  WHERE RecipientID=@pRecipientID
    AND MessageID=@pMessageID

GO


