IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetImportantPullQuotesForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetImportantPullQuotesForEvaluatee.'
      DROP PROCEDURE dbo.GetImportantPullQuotesForEvaluatee
   END
GO
PRINT '.. Creating sproc GetImportantPullQuotesForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetImportantPullQuotesForEvaluatee
	@pEvaluateeId BIGINT
   ,@pFrameworkId BIGINT
   ,@pIncludePrivate BIT
   ,@pIncludeFocusOnly BIT
AS

SET NOCOUNT ON 

SELECT pq.*, s.ObserveStartTime, u.FirstName + ' ' + u.LastName + ' - ' + s.Title AS SessionTitle, s.SessionKey, s.SchoolYear AS SchoolYear
  FROM dbo.vPullQuote pq
  JOIN dbo.SEEvalSession s
	ON pq.EvalSessionID=s.EvalSessionID
  JOIN dbo.SEUser u
    ON s.EvaluatorUserID=u.SEUserID
  JOIN dbo.SEEvaluation e
    ON (e.EvaluateeID=s.EvaluateeUserID AND s.DistrictCode=e.DistrictCode AND s.EvaluationTypeID=e.EvaluationTypeID AND s.SchoolYear=e.SchoolYear)
 WHERE s.EvaluateeUserID=@pEvaluateeID
   AND pq.IsImportant=1
   AND s.EvaluationScoreTypeID=1 -- standard
   -- AND s.ObserveIsComplete=1
   AND ((@pIncludePrivate=1 AND s.ObserveIsPublic IN (0,1)) OR
        (s.ObserveIsPublic=1))
   AND pq.FrameworkID=@pFrameworkID
   AND (@pIncludeFocusOnly = 0 OR (e.FocusedFrameworkNodeID=s.FocusedFrameworkNodeID))
 ORDER BY pq.NodeSequence
 
