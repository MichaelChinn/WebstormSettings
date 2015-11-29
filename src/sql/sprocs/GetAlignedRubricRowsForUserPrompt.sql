IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedRubricRowsForUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedRubricRowsForUserPrompt.'
      DROP PROCEDURE dbo.GetAlignedRubricRowsForUserPrompt
   END
GO
PRINT '.. Creating sproc GetAlignedRubricRowsForUserPrompt.'
GO

CREATE PROCEDURE dbo.GetAlignedRubricRowsForUserPrompt
	@pFrameworkID BIGINT
	,@pUserPromptID BIGINT
	,@pCreatedByUserID BIGINT
AS

SET NOCOUNT ON 

SELECT ri.*
  FROM dbo.vAlignedRubricRowInfo ri
 WHERE ri.UserPromptID=@pUserPromptID
   AND ri.FrameworkID=@pFrameworkID
   AND ri.CreatedByUserID=@pCreatedByUserID
 ORDER BY ri.FrameworkNodeID



