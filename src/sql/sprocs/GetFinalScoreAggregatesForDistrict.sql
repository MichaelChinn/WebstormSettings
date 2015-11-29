IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFinalScoreAggregatesForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFinalScoreAggregatesForDistrict.'
      DROP PROCEDURE dbo.GetFinalScoreAggregatesForDistrict
   END
GO
PRINT '.. Creating sproc GetFinalScoreAggregatesForDistrict.'
GO

CREATE PROCEDURE dbo.GetFinalScoreAggregatesForDistrict
	@pDistrictCode VARCHAR(20)
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT x.PerformanceLevelID, COUNT(*) AS COUNT
  FROM (SELECT CASE WHEN (fs.PerformanceLevelID IS NULL) THEN 0 ELSE fs.PerformanceLevelID END As PerformanceLevelID
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID
		 WHERE u.DistrictCode=@pDistrictCode
		   AND fs.DistrictCode=@pDistrictCode
		   AND fs.SchoolYear=@pSchoolYear
		   AND fs.EvaluationTypeID=@pEvaluationTypeID) x
		 GROUP BY x.PerformanceLevelID
		 

