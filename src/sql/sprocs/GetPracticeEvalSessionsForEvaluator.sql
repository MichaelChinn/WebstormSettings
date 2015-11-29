IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeEvalSessionsForEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeEvalSessionsForEvaluator.'
      DROP PROCEDURE dbo.GetPracticeEvalSessionsForEvaluator
   END
GO
PRINT '.. Creating sproc GetPracticeEvalSessionsForEvaluator.'
GO

CREATE PROCEDURE dbo.GetPracticeEvalSessionsForEvaluator
	 @pEvaluatorUserId	BIGINT
	 	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT es.* 
  FROM dbo.vEvalSession es
 WHERE es.EvaluatorUserID=@pEvaluatorUserID
   AND es.EvaluationScoreTypeID=3 -- Drift-detect
   AND ObserveIsPublic = 1
   AND es.SchoolYear = @pSchoolYear
 ORDER BY es.ObserveStartTime DESC


