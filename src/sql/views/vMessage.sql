IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vMessage')
   BEGIN
      PRINT '.. Dropping View vMessage.'
	  DROP VIEW dbo.vMessage
   END
GO
PRINT '.. Creating View vMessage.'
GO
CREATE VIEW dbo.vMessage
AS 

SELECT MessageID	
      ,SenderID
      ,Sender
      ,RecipientUsers
       ,[Subject]
       ,Body
       ,MessageTypeID
      ,SendTime
      ,SchoolYear
  FROM dbo.[MESSAGE]





	
