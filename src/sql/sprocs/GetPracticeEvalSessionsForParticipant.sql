IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeEvalSessionsForParticipant') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeEvalSessionsForParticipant.'
      DROP PROCEDURE dbo.GetPracticeEvalSessionsForParticipant
   END
GO
PRINT '.. Creating sproc GetPracticeEvalSessionsForParticipant.'
GO

CREATE PROCEDURE dbo.GetPracticeEvalSessionsForParticipant
	 @pUserId	BIGINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT es.*
  FROM dbo.vEvalSession es
 WHERE es.EvaluatorUserID=@pUserID
   AND es.EvaluationScoreTypeID=3 -- Drift-detect
   AND ObserveIsPublic = 1
   AND es.SchoolYear = @pSchoolYear
 ORDER BY es.ObserveStartTime DESC


