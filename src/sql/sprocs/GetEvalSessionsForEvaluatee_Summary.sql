IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionsForEvaluatee_Summary') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionsForEvaluatee_Summary.'
      DROP PROCEDURE dbo.GetEvalSessionsForEvaluatee_Summary
   END
GO
PRINT '.. Creating sproc GetEvalSessionsForEvaluatee_Summary.'
GO

CREATE PROCEDURE dbo.GetEvalSessionsForEvaluatee_Summary
	@pEvaluateeUserId	BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
    ,@pIncludeFocusOnly BIT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
  JOIN dbo.SEEvaluation e
    ON (e.EvaluateeID=s.EvaluateeUserID AND s.DistrictCode=e.DistrictCode AND s.EvaluationTypeID=e.EvaluationTypeID AND s.SchoolYear=e.SchoolYear)
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.EvaluationScoreTypeID=1 -- standard
   AND s.EvaluationTypeID=@pEvaluationTypeID
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   -- AND s.ObserveIsComplete=1
   AND s.ObserveIsPublic=1
   AND s.IsSelfAssess=0
   AND (@pIncludeFocusOnly = 0 OR (e.FocusedFrameworkNodeID=s.FocusedFrameworkNodeID))
 ORDER BY s.SessionKey ASC


