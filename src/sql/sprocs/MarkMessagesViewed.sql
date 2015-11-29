if exists (select * from sysobjects 
where id = object_id('dbo.MarkMessagesViewed') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc MarkMessagesViewed.'
      drop procedure dbo.MarkMessagesViewed
   END
GO
PRINT '.. Creating sproc MarkMessagesViewed.'
GO
CREATE PROCEDURE MarkMessagesViewed
	 @pRecipientID BIGINT
	,@pSchoolYear SMALLINT
	,@pMessageTypeID INT = NULL
AS
SET NOCOUNT ON 

UPDATE dbo.MessageHeader
   SET StateFlag = 1
  WHERE RecipientID=@pRecipientID
    AND StateFlag = 0
    AND SchoolYear=@pSchoolYear
    AND (@pMessageTypeID IS NULL OR MessageTypeID=@pMessageTypeID)

GO


