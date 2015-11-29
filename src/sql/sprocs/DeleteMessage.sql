if exists (select * from sysobjects 
where id = object_id('dbo.DeleteMessage') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteMessage.'
      drop procedure dbo.DeleteMessage
   END
GO
PRINT '.. Creating sproc DeleteMessage.'
GO
CREATE PROCEDURE DeleteMessage
	 @pRecipientID BIGINT
	,@pMessageID BIGINT
AS
SET NOCOUNT ON 

UPDATE dbo.MessageHeader
   SET Deleted=1
      ,StateFlag = 3
  WHERE RecipientID=@pRecipientID
    AND MessageID=@pMessageID

GO


