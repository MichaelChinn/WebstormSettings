IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluatorEvalSessionsForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluatorEvalSessionsForEvaluatee.'
      DROP PROCEDURE dbo.GetEvaluatorEvalSessionsForEvaluatee
   END
GO
PRINT '.. Creating sproc GetEvaluatorEvalSessionsForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetEvaluatorEvalSessionsForEvaluatee
	 @pEvaluatorUserId	BIGINT
	,@pEvaluateeUserId BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT es.* 
  FROM dbo.vEvalSession es
 WHERE es.EvaluatorUserID=@pEvaluatorUserID
   AND es.EvaluateeUserID=@pEvaluateeUserID
   AND es.EvaluationScoreTypeID=1 -- Standard
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND es.SchoolYear = @pSchoolYear
   AND es.DistrictCode = @pDistrictCode
   AND es.SchoolCode = @pSchoolCode
   AND es.IsSelfAssess=0
 ORDER BY es.ObserveStartTime ASC





