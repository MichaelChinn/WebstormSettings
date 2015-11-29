IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFinalScoreAggregatesForSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFinalScoreAggregatesForSchool.'
      DROP PROCEDURE dbo.GetFinalScoreAggregatesForSchool
   END
GO
PRINT '.. Creating sproc GetFinalScoreAggregatesForSchool.'
GO

CREATE PROCEDURE dbo.GetFinalScoreAggregatesForSchool
	@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

DECLARE @DistrictCode VARCHAR(20)
SELECT @DistrictCode = DistrictCode FROM dbo.SEDistrictSchool WHERE SchoolCode=@pSchoolCode AND IsSchool=1

SELECT x.PerformanceLevelID, COUNT(*) AS COUNT
  FROM (SELECT CASE WHEN (e.PerformanceLevelID IS NULL) THEN 0 ELSE e.PerformanceLevelID END As PerformanceLevelID
		  FROM dbo.SEEvaluation e
		  JOIN dbo.SEUser u
			ON e.EvaluateeID=u.SEUserID
		 WHERE u.SchoolCode=@pSchoolCode
		   AND e.SchoolYear=@pSchoolYear
		   AND e.DistrictCode=@DistrictCode
		   AND e.EvaluationTypeID=2) x
		 GROUP BY x.PerformanceLevelID
		 