IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPullQuotesForFrameworkNodeForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPullQuotesForFrameworkNodeForEvaluatee.'
      DROP PROCEDURE dbo.GetPullQuotesForFrameworkNodeForEvaluatee
   END
GO
PRINT '.. Creating sproc GetPullQuotesForFrameworkNodeForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetPullQuotesForFrameworkNodeForEvaluatee
	@pEvaluateeId BIGINT
	,@pFrameworkNodeID BIGINT
	,@pIncludePrivate BIT
AS

SET NOCOUNT ON 

SELECT pq.*, s.ObserveStartTime, s.Title AS SessionTitle
  FROM dbo.vPullQuote pq
  JOIN dbo.SEEvalSession s
	ON pq.EvalSessionID=s.EvalSessionID
 WHERE s.EvaluateeUserID=@pEvaluateeID
   AND pq.FrameworkNodeID=@pFrameworkNodeID
   AND s.EvaluationScoreTypeID=1 -- standard
   AND (@pIncludePrivate=1 OR (s.ObserveIsPublic = 1))
 --  AND s.ObserveIsComplete=1

