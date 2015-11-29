IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeFrameworkNodeScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeFrameworkNodeScores.'
      DROP PROCEDURE dbo.GetEvaluateeFrameworkNodeScores
   END
GO
PRINT '.. Creating sproc GetEvaluateeFrameworkNodeScores.'
GO

CREATE PROCEDURE dbo.GetEvaluateeFrameworkNodeScores
	@pEvaluateeUserID	BIGINT
	,@pFrameworkNodeID	BIGINT
	,@pEvaluationTypeID SMALLINT
AS

SET NOCOUNT ON 

SELECT fns.FrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.PerformanceLevelID
	  ,fns.SEUserID
	  ,fns.EvalSessionID
  FROM dbo.SEFrameworkNodeScore fns
  JOIN dbo.SEEvalSession es
	ON fns.EvalSessionID=es.EvalSessionID
 WHERE es.EvaluateeUserID=@pEvaluateeUserID
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND fns.FrameworkNodeID=@pFrameworkNodeID

