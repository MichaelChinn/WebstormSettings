IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPrintScoresForEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPrintScoresForEvalSession.'
      DROP PROCEDURE dbo.GetPrintScoresForEvalSession
   END
GO
PRINT '.. Creating sproc GetPrintScoresForEvalSession.'
GO

CREATE PROCEDURE dbo.GetPrintScoresForEvalSession
	@pSessionID BIGINT
	,@pFrameworkID BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Scores(FrameworkNodeID BIGINT, FrameworkNodeSeq INT, RubricRowID BIGINT, RubricRowSeq INT, ShortName VARCHAR(200), Title VARCHAR(600), PL SMALLINT)
INSERT INTO #Scores(FrameworkNodeID, FrameworkNodeSeq, RubricRowID, RubricRowSeq, ShortName, Title, PL)
SELECT fn.FrameworkNodeId
	  ,fn.Sequence
      ,0
      ,0
      ,fn.ShortName
	  ,fn.Title
	  ,0
 FROM dbo.SEFrameworkNode fn (NOLOCK)
 WHERE fn.FrameworkID=@pFrameworkID

INSERT INTO #Scores(FrameworkNodeID, FrameworkNodeSeq, RubricRowID, RubricRowSeq, ShortName, Title, PL)
SELECT fn.FrameworkNodeID
	  ,fn.Sequence
	  ,rr.RubricRowID
	  ,rrfn.Sequence
	  ,''
	  ,rr.Title
	  ,0
 FROM dbo.SERubricRow rr (NOLOCK)
 JOIN dbo.SERubricRowFrameworkNode rrfn (NOLOCK)
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE fn.FrameworkID=@pFrameworkID

UPDATE #Scores
   SET PL=ISNULL(fns.PerformanceLevelID,0)
 FROM dbo.SEFrameworkNode fn (NOLOCK)
  JOIN dbo.SEFrameworkNodeScore fns (NOLOCK)
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
 WHERE fns.EvalSEssionID=@pSessionID
   AND fn.FrameworkID=@pFrameworkID
   AND (fn.FrameworkNodeID=#Scores.FrameworkNodeID AND #Scores.RubricRowID=0)

UPDATE #Scores
   SET PL=ISNULL(rrs.PerformanceLevelID,0)
 FROM dbo.SERubricRow rr (NOLOCK)
 JOIN dbo.SERubricRowFrameworkNode rrfn (NOLOCK)
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn (NOLOCK)
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs (NOLOCK)
	ON rr.RubricRowID=rrs.RubricRowID
  JOIN dbo.SEEvalSession es (NOLOCK)
	ON es.EvalSessionID=rrs.EvalSessionID
 WHERE fn.FrameworkID=@pFrameworkID
   AND rrs.EvalSessionID=@pSessionID
   AND (fn.FrameworkNodeID=#Scores.FrameworkNodeID AND rr.RubricRowID=#Scores.RubricRowID)

SELECT *
  FROM dbo.#Scores
 ORDER BY FrameworkNodeSeq, RubricRowSeq