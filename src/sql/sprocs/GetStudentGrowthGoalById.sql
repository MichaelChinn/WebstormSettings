IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthGoalById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthGoalById'
      DROP PROCEDURE dbo.GetStudentGrowthGoalById
   END
GO
PRINT '.. Creating sproc GetStudentGrowthGoalById'
GO

CREATE PROCEDURE dbo.GetStudentGrowthGoalById
	@pGoalId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vStudentGrowthGoal
 WHERE StudentGrowthGoalID=@pGoalID

