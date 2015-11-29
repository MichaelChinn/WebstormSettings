if exists (select * from sysobjects 
where id = object_id('dbo.GetDigestMessages') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDigestMessages.'
      drop procedure dbo.GetDigestMessages
   END
GO
PRINT '.. Creating sproc GetDigestMessages.'
GO
CREATE PROCEDURE GetDigestMessages
	 @pDeliveryTypeID SMALLINT
AS
SET NOCOUNT ON 

SELECT m.*
  FROM dbo.vMessage m
  JOIN dbo.MessageHeader mh ON m.MessageID=mh.MessageID
  JOIN dbo.MessageTypeRecipientConfig c ON m.MessageTypeID=c.MessageTypeID
  WHERE mh.EmailSent=0
    AND c.RecipientID=mh.RecipientID
    AND c.EmailDeliveryTypeID = @pDeliveryTypeID
  ORDER BY mh.RecipientID

GO




