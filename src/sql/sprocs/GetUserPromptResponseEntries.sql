if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptResponseEntries') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptResponseEntries.'
      drop procedure dbo.GetUserPromptResponseEntries
   END
GO
PRINT '.. Creating sproc GetUserPromptResponseEntries.'
GO
CREATE PROCEDURE GetUserPromptResponseEntries
	 @pUserPromptResponseID BIGINT
AS
SET NOCOUNT ON 

SELECT e.*
  FROM dbo.vUserPromptResponseEntry e
 WHERE e.UserPromptResponseID=@pUserPromptResponseID
 ORDER BY e.CreationDateTime DESC

   
