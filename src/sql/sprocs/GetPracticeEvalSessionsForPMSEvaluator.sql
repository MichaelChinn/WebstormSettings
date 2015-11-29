IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeEvalSessionsForPMSEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeEvalSessionsForPMSEvaluator.'
      DROP PROCEDURE dbo.GetPracticeEvalSessionsForPMSEvaluator
   END
GO
PRINT '.. Creating sproc GetPracticeEvalSessionsForPMSEvaluator.'
GO

CREATE PROCEDURE dbo.GetPracticeEvalSessionsForPMSEvaluator
	 @pEvaluatorUserId	BIGINT
	 	,@pSchoolYear SMALLINT
	 	,@pSchoolCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT es.* 
  FROM dbo.vEvalSession es
 WHERE es.EvaluatorUserID=@pEvaluatorUserID
   AND es.EvaluationScoreTypeID=3 -- Drift-detect
   AND ObserveIsPublic = 1
   AND es.SchoolYear = @pSchoolYear
   AND ((es.SchoolCode IS NULL OR es.SchoolCode = '') OR (es.SchoolCode=@pSchoolCode))
 ORDER BY es.ObserveStartTime DESC


