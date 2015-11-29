IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UpdateShowOnlyAssignedPromptsFlagForEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateShowOnlyAssignedPromptsFlagForEvalSession.'
      DROP PROCEDURE dbo.UpdateShowOnlyAssignedPromptsFlagForEvalSession
   END
GO
PRINT '.. Creating sproc UpdateShowOnlyAssignedPromptsFlagForEvalSession.'
GO

CREATE PROCEDURE dbo.UpdateShowOnlyAssignedPromptsFlagForEvalSession
	@pSessionID	BIGINT
	,@pPromptTypeID SMALLINT
	,@pFlag BIT
AS

SET NOCOUNT ON 

-- select * from seuserprompttype

IF (@pPromptTypeID = 1) -- Pre
BEGIN

UPDATE dbo.SEEvalSession
   SET ShowOnlyAssignedPreConfPrompts=@pFlag
 WHERE EvalSessionID=@pSessionID

END
ELSE -- Post
BEGIN

UPDATE dbo.SEEvalSession
   SET ShowOnlyAssignedPostConfPrompts=@pFlag
 WHERE EvalSessionID=@pSessionID

 
END


