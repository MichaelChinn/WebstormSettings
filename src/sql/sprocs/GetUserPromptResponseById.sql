if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptResponseById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptResponseById.'
      drop procedure dbo.GetUserPromptResponseById
   END
GO
PRINT '.. Creating sproc GetUserPromptResponseById.'
GO
CREATE PROCEDURE GetUserPromptResponseById
	 @pUserPromptResponseId BIGINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.UserPromptResponseID=@pUserPromptResponseId

   
