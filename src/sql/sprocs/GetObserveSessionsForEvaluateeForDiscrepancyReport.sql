IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetObserveSessionsForEvaluateeForDiscrepancyReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetObserveSessionsForEvaluateeForDiscrepancyReport.'
      DROP PROCEDURE dbo.GetObserveSessionsForEvaluateeForDiscrepancyReport
   END
GO
PRINT '.. Creating sproc GetObserveSessionsForEvaluateeForDiscrepancyReport.'
GO

CREATE PROCEDURE dbo.GetObserveSessionsForEvaluateeForDiscrepancyReport
	@pEvaluateeUserId	BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.EvaluationScoreTypeID=1 -- standard
   AND s.EvaluationTypeID=@pEvaluationTypeID
   --AND s.ObserveIsComplete=1
   AND s.ObserveIsPublic = 1
   AND s.SchoolYear = @pSchoolYear
 ORDER BY s.SessionKey ASC



