IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPrintScoresForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPrintScoresForEvaluatee.'
      DROP PROCEDURE dbo.GetPrintScoresForEvaluatee
   END
GO
PRINT '.. Creating sproc GetPrintScoresForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetPrintScoresForEvaluatee
	@pEvaluateeID BIGINT
	,@pFrameworkID BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Scores(EvalSessionID BIGINT, FrameworkNodeID BIGINT, FrameworkNodeSeq INT, RubricRowID BIGINT, RubricRowSeq INT, ShortName VARCHAR(200), Title VARCHAR(600), PL SMALLINT)
INSERT INTO #Scores(EvalSessionID, FrameworkNodeID, FrameworkNodeSeq, RubricRowID, RubricRowSeq, ShortName, Title, PL)
SELECT s.EvalSessionID
      ,fn.FrameworkNodeId
	  ,fn.Sequence
      ,0
      ,0
      ,fn.ShortName
	  ,fn.Title
	  ,0
 FROM dbo.SEFrameworkNode fn
 JOIN dbo.SEEvalSession s
   ON s.EvaluateeUserID=@pEvaluateeID
 WHERE fn.FrameworkID=@pFrameworkID
   AND s.EvaluationScoreTypeID=1 -- standard
  -- AND s.ObserveIsComplete=1


INSERT INTO #Scores(EvalSessionID, FrameworkNodeID, FrameworkNodeSeq, RubricRowID, RubricRowSeq, ShortName, Title, PL)
SELECT s.EvalSessionID
      ,fn.FrameworkNodeID
	  ,fn.Sequence
	  ,rr.RubricRowID
	  ,rrfn.Sequence
	  ,''
	  ,rr.Title
	  ,0
 FROM dbo.SERubricRow rr 
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 JOIN dbo.SEEvalSession s
   ON s.EvaluateeUserID=@pEvaluateeID
 WHERE fn.FrameworkID=@pFrameworkID

UPDATE #Scores
   SET PL=ISNULL(fns.PerformanceLevelID,0)
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
 WHERE fn.FrameworkID=@pFrameworkID
   AND fn.FrameworkNodeID=#Scores.FrameworkNodeID 
   AND #Scores.RubricRowID=0
   AND fns.EvalSEssionID=#Scores.EvalSessionID

UPDATE #Scores
   SET PL=ISNULL(rrs.PerformanceLevelID,0)
 FROM dbo.SERubricRow rr 
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs
	ON rr.RubricRowID=rrs.RubricRowID
  JOIN dbo.SEEvalSession es
	ON es.EvalSessionID=rrs.EvalSessionID
 WHERE fn.FrameworkID=@pFrameworkID
   AND fn.FrameworkNodeID=#Scores.FrameworkNodeID 
   AND rr.RubricRowID=#Scores.RubricRowID
   AND rrs.EvalSessionID = #Scores.EvalSessionID

SELECT scores.*, s.EvalSessionID, s.Title, s.EvaluatorDisplayName, s.ObserveStartTime, s.ObserveEndTime
  FROM dbo.#Scores scores
  JOIN dbo.vEvalSession s
    ON scores.EvalSessionID=s.EvalSessionID
 ORDER BY scores.EvalSessionID, scores.FrameworkNodeSeq, scores.RubricRowSeq