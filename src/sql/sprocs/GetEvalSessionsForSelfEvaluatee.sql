IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionsForSelfEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionsForSelfEvaluatee.'
      DROP PROCEDURE dbo.GetEvalSessionsForSelfEvaluatee
   END
GO
PRINT '.. Creating sproc GetEvalSessionsForSelfEvaluatee.'
GO

CREATE PROCEDURE dbo.GetEvalSessionsForSelfEvaluatee
	@pEvaluateeUserId	BIGINT
	,@pIncludePrivate BIT = 1
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pFocusedOnly BIT = 0
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
  JOIN dbo.SEEvaluation e
    ON (e.EvaluateeID=s.EvaluateeUserID AND s.DistrictCode=e.DistrictCode AND s.EvaluationTypeID=e.EvaluationTypeID AND s.SchoolYear=e.SchoolYear)
 WHERE s.EvaluateeUserID=@pEvaluateeUserID
   AND s.IsSelfAssess=1
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND (@pFocusedOnly = 0 OR s.IsFocused=1)
   AND (@pIncludePrivate = 1 OR s.ObserveIsPublic=1)
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND (@pFocusedOnly = 0 OR s.FocusedFrameworkNodeID=e.FocusedFrameworkNodeID)
 ORDER BY EvalSessionID



