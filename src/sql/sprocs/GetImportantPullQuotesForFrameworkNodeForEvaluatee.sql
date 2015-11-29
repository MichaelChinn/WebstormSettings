IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetImportantPullQuotesForFrameworkNodeForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetImportantPullQuotesForFrameworkNodeForEvaluatee.'
      DROP PROCEDURE dbo.GetImportantPullQuotesForFrameworkNodeForEvaluatee
   END
GO
PRINT '.. Creating sproc GetImportantPullQuotesForFrameworkNodeForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetImportantPullQuotesForFrameworkNodeForEvaluatee
	@pEvaluateeId BIGINT
   ,@pFrameworkNodeId BIGINT
   ,@pIncludePrivate BIT
AS

SET NOCOUNT ON 

SELECT pq.*, s.ObserveStartTime, s.Title AS SessionTitle, s.SessionKey, s.SchoolYear AS SchoolYear
  FROM dbo.vPullQuote pq
  JOIN dbo.SEEvalSession s
	ON pq.EvalSessionID=s.EvalSessionID
 WHERE s.EvaluateeUserID=@pEvaluateeID
   AND pq.IsImportant=1
   AND s.EvaluationScoreTypeID=1 -- standard
   AND (@pIncludePrivate=1 OR (s.ObserveIsPublic = 1))
   AND pq.FrameworkNodeID=@pFrameworkNodeID
 ORDER BY pq.NodeSequence
 
