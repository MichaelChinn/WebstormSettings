IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthProcessForm') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthProcessForm'
      DROP PROCEDURE dbo.GetStudentGrowthProcessForm
   END
GO
PRINT '.. Creating sproc GetStudentGrowthProcessForm'
GO

CREATE PROCEDURE dbo.GetStudentGrowthProcessForm
	@pDistrictCode VARCHAR(20),
	@pEvaluationTypeID SMALLINT,
	@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vForm
 WHERE EvaluationTypeID=@pEvaluationTypeID
   AND SchoolYear=@pSchoolYear
   AND (DistrictCode=@pDistrictCode OR DistrictCode='')


