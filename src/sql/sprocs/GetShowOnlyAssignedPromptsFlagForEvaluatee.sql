IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetShowOnlyAssignedPromptsFlagForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetShowOnlyAssignedPromptsFlagForEvaluatee.'
      DROP PROCEDURE dbo.GetShowOnlyAssignedPromptsFlagForEvaluatee
   END
GO
PRINT '.. Creating sproc GetShowOnlyAssignedPromptsFlagForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetShowOnlyAssignedPromptsFlagForEvaluatee
	@pEvaluateeID	BIGINT
	,@pSchoolYear SMALLINT
	,@pPromptTypeID SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

-- select * from seuserprompttype

IF (@pPromptTypeID = 4) -- Evaluator Goal
BEGIN

SELECT ShowOnlyAssignedGoalPrompts
  FROM dbo.SEEvaluation
 WHERE EvaluateeId=@pEvaluateeID
   AND SchoolYear=@pSchoolYear 
   AND DistrictCode=@pDistrictCode

END
ELSE -- Reflection
BEGIN

SELECT ShowOnlyAssignedReflectionPrompts
  FROM dbo.SEEvaluation
 WHERE EvaluateeId=@pEvaluateeID
   AND SchoolYear=@pSchoolYear 
   AND DistrictCode=@pDistrictCode
   
END


