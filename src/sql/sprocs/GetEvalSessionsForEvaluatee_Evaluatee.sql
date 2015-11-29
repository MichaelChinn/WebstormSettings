IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionsForEvaluatee_Evaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionsForEvaluatee_Evaluatee.'
      DROP PROCEDURE dbo.GetEvalSessionsForEvaluatee_Evaluatee
   END
GO
PRINT '.. Creating sproc GetEvalSessionsForEvaluatee_Evaluatee.'
GO

CREATE PROCEDURE dbo.GetEvalSessionsForEvaluatee_Evaluatee
	@pEvaluateeUserId	BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.EvaluationScoreTypeID=1 -- standard
   AND s.EvaluationTypeID=@pEvaluationTypeID
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND (s.PreConfIsPublic=1 OR s.ObserveIsPublic=1 OR s.PostConfIsPublic=1) -- something is visible
 ORDER BY s.SessionKey ASC


