IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthGoalBundlesForEvaluation') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthGoalBundlesForEvaluation'
      DROP PROCEDURE dbo.GetStudentGrowthGoalBundlesForEvaluation
   END
GO
PRINT '.. Creating sproc GetStudentGrowthGoalBundlesForEvaluation'
GO

CREATE PROCEDURE dbo.GetStudentGrowthGoalBundlesForEvaluation
	@pEvaluationId BIGINT,
	@pWfStateID SMALLINT = 0
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vStudentGrowthGoalBundle
 WHERE EvaluationID=@pEvaluationId
   AND (@pWfStateID = 0 OR WfStateID=@pWfStateID)

