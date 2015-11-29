IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetObserveSessionsForReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetObserveSessionsForReport.'
      DROP PROCEDURE dbo.GetObserveSessionsForReport
   END
GO
PRINT '.. Creating sproc GetObserveSessionsForReport.'
GO

CREATE PROCEDURE dbo.GetObserveSessionsForReport
	@pEvaluateeUserId	BIGINT
	,@pSchoolYear SMALLINT
	,@pIncludePrivate BIT
	,@pIncludeIncomplete BIT
	,@pDistrictCode VARCHAR(20)
	,@pFocusedOnly BIT = 0
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
  JOIN dbo.SEEvaluation e ON s.EvaluateeUserID=e.EvaluateeID
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.EvaluationScoreTypeID=1 -- standard
   AND s.IsSelfAssess=0
   AND (@pIncludeIncomplete=1 OR s.ObserveIsComplete=1)
   AND (@pIncludePrivate=1 OR (s.ObserveIsPublic = 1))
   AND (@pFocusedOnly = 0 OR IsFocused=1)
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND s.SchoolYear=e.SchoolYear
   AND s.DistrictCode=e.DistrictCode
   AND s.EvaluationTypeID=e.EvaluationTypeID
   AND (@pFocusedOnly = 0 OR s.FocusedFrameworkNodeID=e.FocusedFrameworkNodeID)
 ORDER BY s.SessionKey ASC



