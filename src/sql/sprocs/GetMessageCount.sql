if exists (select * from sysobjects 
where id = object_id('dbo.GetMessageCount') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetMessageCount.'
      drop procedure dbo.GetMessageCount
   END
GO
PRINT '.. Creating sproc GetMessageCount.'
GO
CREATE PROCEDURE GetMessageCount
	 @pRecipientID BIGINT
	,@pSchoolYear SMALLINT
	,@pStateFlag SMALLINT = NULL
	,@pMessageTypeID SMALLINT = NULL
	,@pSenderID BIGINT = NULL
AS
SET NOCOUNT ON 

SELECT COUNT(MessageID) 
  FROM MessageHeader 
 WHERE RecipientID = @pRecipientID
   AND (@pStateFlag IS NULL OR StateFlag = @pStateFlag) 
   AND (@pMessageTypeID IS NULL OR MessageTypeID=@pMessageTypeID)
   AND (@pSenderID IS NULL OR SenderID=@pSenderID)
   AND SchoolYear = @pSchoolYear


