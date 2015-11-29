IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeRubricRowScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeRubricRowScores.'
      DROP PROCEDURE dbo.GetEvaluateeRubricRowScores
   END
GO
PRINT '.. Creating sproc GetEvaluateeRubricRowScores.'
GO

CREATE PROCEDURE dbo.GetEvaluateeRubricRowScores
	@pEvaluateeUserID	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT rrs.RubricRowID
	  ,rrs.EvalSessionID
	  ,rrs.PerformanceLevelID
	  ,rrs.SEUserID 
	  ,es.EvaluationTypeID
  FROM dbo.SERubricRowScore rrs
  JOIN dbo.SEEvalSession es
	ON rrs.EvalSessionID=es.EvalSessionID
 WHERE es.EvaluateeUserID=@pEvaluateeUserID
   AND es.EvaluationScoreTypeID=1
   AND es.SchoolYear=@pSchoolYear
   AND es.DistrictCode=@pDistrictCode

