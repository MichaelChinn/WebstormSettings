IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalVisibilityForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalVisibilityForEvaluatee.'
      DROP PROCEDURE dbo.GetEvalVisibilityForEvaluatee
   END
GO
PRINT '.. Creating sproc GetEvalVisibilityForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetEvalVisibilityForEvaluatee
	@pEvaluateeID BIGINT,
	@pDistrictCode VARCHAR(20),
	@pSchoolYear SMALLINT,
	@pEvaluationTypeID SMALLINT
AS

SET NOCOUNT ON 

SELECT VisibilityID
	  ,v.EvaluationID
	  ,FinalScoreVisible
	  ,FNSummativeScoresVisible
	  ,FNExcerptsVisible
	  ,RRSummativeScoresVisible
	  ,ObservationsVisible
	  ,EvalCommentsVisible
	  ,EvalExcerptsVisible
	  ,RRAnnotationsVisible
	  ,EvalRecommendationsVisible
	  ,ReportSnapshotVisible
 FROM dbo.SEEvalVisibility v
 JOIN dbo.SEEvaluation e ON v.EvaluationID=e.EvaluationID
WHERE e.EvaluateeID=@pEvaluateeID
  AND e.DistrictCode=@pDistrictCode
  AND e.SchoolYear=@pSchoolYear
  AND e.EvaluationTypeID=@pEvaluationTypeID

 



