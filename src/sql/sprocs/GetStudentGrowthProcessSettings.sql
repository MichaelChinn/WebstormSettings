IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthProcessSettings') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthProcessSettings'
      DROP PROCEDURE dbo.GetStudentGrowthProcessSettings
   END
GO
PRINT '.. Creating sproc GetStudentGrowthProcessSettings'
GO

CREATE PROCEDURE dbo.GetStudentGrowthProcessSettings
	@pDistrictCode VARCHAR(20),
	@pEvaluationTypeID SMALLINT,
	@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vStudentGrowthProcessSettings
 WHERE EvaluationTypeID=@pEvaluationTypeID
   AND SchoolYear=@pSchoolYear
   AND (DistrictCode=@pDistrictCode OR DistrictCode='')


