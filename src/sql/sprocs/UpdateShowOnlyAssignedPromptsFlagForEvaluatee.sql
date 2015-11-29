IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UpdateShowOnlyAssignedPromptsFlagForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateShowOnlyAssignedPromptsFlagForEvaluatee.'
      DROP PROCEDURE dbo.UpdateShowOnlyAssignedPromptsFlagForEvaluatee
   END
GO
PRINT '.. Creating sproc UpdateShowOnlyAssignedPromptsFlagForEvaluatee.'
GO

CREATE PROCEDURE dbo.UpdateShowOnlyAssignedPromptsFlagForEvaluatee
	@pEvaluateeID	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pPromptTypeID SMALLINT
	,@pFlag BIT
AS

SET NOCOUNT ON 

-- select * from seuserprompttype

IF (@pPromptTypeID = 4) -- Evaluator Goal
BEGIN

UPDATE dbo.SEEvaluation
   SET ShowOnlyAssignedGoalPrompts=@pFlag
 WHERE EvaluateeId=@pEvaluateeID
   AND SchoolYear=@pSchoolYear 
   AND DistrictCode=@pDistrictCode

END
ELSE -- Reflection
BEGIN

UPDATE dbo.SEEvaluation
   SET ShowOnlyAssignedReflectionPrompts=@pFlag
 WHERE EvaluateeId=@pEvaluateeID
   AND SchoolYear=@pSchoolYear 
   AND DistrictCode=@pDistrictCode
   
END


