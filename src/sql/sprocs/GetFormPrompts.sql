IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFormPrompts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFormPrompts'
      DROP PROCEDURE dbo.GetFormPrompts
   END
GO
PRINT '.. Creating sproc GetFormPrompts'
GO

CREATE PROCEDURE dbo.GetFormPrompts
	@pFormID BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vFormPrompt
 WHERE FormID=@pFormID


