IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthGoalBundleById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthGoalBundleById'
      DROP PROCEDURE dbo.GetStudentGrowthGoalBundleById
   END
GO
PRINT '.. Creating sproc GetStudentGrowthGoalBundleById'
GO

CREATE PROCEDURE dbo.GetStudentGrowthGoalBundleById
	@pBundleId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vStudentGrowthGoalBundle
 WHERE StudentGrowthGoalBundleID=@pBundleID

