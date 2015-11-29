IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vMessageTypeRecipientConfig')
   BEGIN
      PRINT '.. Dropping View vMessageTypeRecipientConfig.'
	  DROP VIEW dbo.vMessageTypeRecipientConfig
   END
GO
PRINT '.. Creating View vMessageTypeRecipientConfig.'
GO
CREATE VIEW dbo.vMessageTypeRecipientConfig
AS 

SELECT	MessageTypeRecipientConfigID,
		RecipientID,
		MessageTypeID,
		Inbox,
		EmailDeliveryTypeID
  FROM dbo.MessageTypeRecipientConfig



