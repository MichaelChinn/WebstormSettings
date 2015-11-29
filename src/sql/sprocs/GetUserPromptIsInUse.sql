if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptIsInUse') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptIsInUse.'
      drop procedure dbo.GetUserPromptIsInUse
   END
GO
PRINT '.. Creating sproc GetUserPromptIsInUse.'
GO
CREATE PROCEDURE GetUserPromptIsInUse
	 @pUserPromptId BIGINT
AS
SET NOCOUNT ON 


IF EXISTS (SELECT UserPromptID FROM SEUserPromptResponse WHERE UserPromptID=@pUserPromptID) OR
   EXISTS (SELECT UserPromptID FROM SEUserPromptConferenceDefault WHERE UserPromptID=@pUserPromptID)
BEGIN
	SELECT 1 AS Result
END
ELSE
BEGIN
	SELECT 0 AS Result
END

 

   
