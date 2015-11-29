IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetGoalsForStudentGrowthGoalBundle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalsForStudentGrowthGoalBundle'
      DROP PROCEDURE dbo.GetGoalsForStudentGrowthGoalBundle
   END
GO
PRINT '.. Creating sproc GetGoalsForStudentGrowthGoalBundle'
GO

CREATE PROCEDURE dbo.GetGoalsForStudentGrowthGoalBundle
	@pBundleID BIGINT
AS

SET NOCOUNT ON 
SELECT g.*
  FROM dbo.vStudentGrowthGoal g
 WHERE g.GoalBundleID=@pBundleID

