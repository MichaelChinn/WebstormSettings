IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vMessageHeader')
   BEGIN
      PRINT '.. Dropping View vMessageHeader.'
	  DROP VIEW dbo.vMessageHeader
   END
GO
PRINT '.. Creating View vMessageHeader.'
GO
CREATE VIEW dbo.vMessageHeader
AS 

SELECT MessageID	
      ,SenderID
      ,RecipientID
      ,Subject
      ,Sender
      ,SendTime
      ,MessageTypeID
      ,Importance
      ,IsRead
      ,Deleted
      ,StateFlag
      ,Flag
      ,Tags
      ,SchoolYear
      ,EmailSent
      ,EmailSentDateTime
  FROM dbo.MessageHeader





	
