IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFinalScoreAggregatesForState') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFinalScoreAggregatesForState.'
      DROP PROCEDURE dbo.GetFinalScoreAggregatesForState
   END
GO
PRINT '.. Creating sproc GetFinalScoreAggregatesForState.'
GO

CREATE PROCEDURE dbo.GetFinalScoreAggregatesForState
	@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

IF (@pEvaluationTypeID=1)
BEGIN

SELECT x.PerformanceLevelID, COUNT(*) AS COUNT
  FROM (SELECT CASE WHEN (dc.HasBeenSubmittedToStatePE=0 OR fs.PerformanceLevelID IS NULL) THEN 0 ELSE fs.PerformanceLevelID END As PerformanceLevelID
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID AND fs.EvaluationTypeID=@pEvaluationTypeID
		  JOIN dbo.SEDistrictConfiguration dc
			ON u.DistrictCode=dc.DistrictCode
		 WHERE dc.EvaluationTypeID=@pEvaluationTypeID
		   AND dc.SchoolYear=@pSchoolYear
		   AND fs.SchoolYear=@pSchoolYear) x
		 GROUP BY x.PerformanceLevelID
		 
END
ELSE
BEGIN

SELECT x.PerformanceLevelID, COUNT(*) AS COUNT
  FROM (SELECT CASE WHEN (dc.HasBeenSubmittedToStateTE=0 OR fs.PerformanceLevelID IS NULL) THEN 0 ELSE fs.PerformanceLevelID END As PerformanceLevelID
		  FROM dbo.SEEvaluation fs
		  JOIN dbo.SEUser u
			ON fs.EvaluateeID=u.SEUserID AND fs.EvaluationTypeID=@pEvaluationTypeID
		  JOIN dbo.SEDistrictConfiguration dc
			ON u.DistrictCode=dc.DistrictCode
		WHERE dc.EvaluationTypeID=@pEvaluationTypeID
		  AND fs.SchoolYear=@pSchoolYear
		  AND dc.SchoolYear=@pSchoolYear) x
		 GROUP BY x.PerformanceLevelID
END
