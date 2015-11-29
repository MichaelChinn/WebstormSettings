if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptById.'
      drop procedure dbo.GetUserPromptById
   END
GO
PRINT '.. Creating sproc GetUserPromptById.'
GO
CREATE PROCEDURE GetUserPromptById
	 @pUserPromptId BIGINT
AS
SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vUserPrompt p (NOLOCK)
 WHERE p.UserPromptID=@pUserPromptId

   
