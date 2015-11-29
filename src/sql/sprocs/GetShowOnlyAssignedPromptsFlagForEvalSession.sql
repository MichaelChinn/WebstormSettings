IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetShowOnlyAssignedPromptsFlagForEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetShowOnlyAssignedPromptsFlagForEvalSession.'
      DROP PROCEDURE dbo.GetShowOnlyAssignedPromptsFlagForEvalSession
   END
GO
PRINT '.. Creating sproc GetShowOnlyAssignedPromptsFlagForEvalSession.'
GO

CREATE PROCEDURE dbo.GetShowOnlyAssignedPromptsFlagForEvalSession
	@pSessionID	BIGINT
	,@pPromptTypeID SMALLINT
AS

SET NOCOUNT ON 

-- select * from seuserprompttype

IF (@pPromptTypeID = 1) -- Pre
BEGIN

SELECT ShowOnlyAssignedPreConfPrompts
  FROM dbo.SEEvalSession
 WHERE EvalSessionID=@pSessionID

END
ELSE -- Post
BEGIN

SELECT ShowOnlyAssignedPostConfPrompts
  FROM dbo.SEEvalSession
 WHERE EvalSessionID=@pSessionID
 
END


