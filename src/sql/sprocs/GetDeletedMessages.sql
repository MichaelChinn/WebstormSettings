if exists (select * from sysobjects 
where id = object_id('dbo.GetDeletedMessages') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDeletedMessages.'
      drop procedure dbo.GetDeletedMessages
   END
GO
PRINT '.. Creating sproc GetDeletedMessages.'
GO
CREATE PROCEDURE GetDeletedMessages
	 @pRecipientID BIGINT
AS
SET NOCOUNT ON 

SELECT mh.*
  FROM dbo.vMessageHeader mh
  WHERE RecipientID=@pRecipientID
    AND [Deleted]=1
  ORDER BY mh.EmailSentDateTime

GO


