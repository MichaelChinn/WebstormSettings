if exists (select * from sysobjects 
where id = object_id('dbo.GetGroupSummativeScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGroupSummativeScoringData.'
      drop procedure dbo.GetGroupSummativeScoringData
   END
GO
PRINT '.. Creating sproc GetGroupSummativeScoringData.'
GO
CREATE PROCEDURE dbo.GetGroupSummativeScoringData
    @pAnchorSessionID	SMALLINT
AS
SET NOCOUNT ON 

CREATE TABLE dbo.#AnchorSession(EvalSessionID BIGINT)

INSERT INTO dbo.#AnchorSession(EvalSessionID)
SELECT es.EvalSessionID
  FROM dbo.SEEvalSession es
 WHERE EvalSessionID=@pAnchorSessionID


-- SUMMATIVE FRAMEWORK NODE SCORE -- 

CREATE TABLE #FNSummativeScores
       (FrameworkNodeId		BIGINT
	   ,ShortName		VARCHAR(20)
       ,NonAnchorScore		SMALLINT
       ,NonAnchorUserID		BIGINT
	   ,NonAnchorEvalSessionID BIGINT
	   ,AnchorScore			SMALLINT
       ,AnchorUserID		BIGINT
       ,AnchorEvalSessionID BIGINT
       )

INSERT INTO #FNSummativeScores
       (FrameworkNodeID
	   ,ShortName	
       ,NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
	   ,AnchorScore	
       ,AnchorUserID
	   ,AnchorEvalSessionID
       )
SELECT fn.FrameworkNodeID
	  ,fn.ShortName
	  ,fns_non_anchor_score.PerformanceLevelID
	  ,fns_non_anchor_score.SEUserID 
	  ,es_non_anchor.EvalSessionID
 	  ,fns_anchor_score.PerformanceLevelID
	  ,fns_anchor_score.SEUserID 
	  ,@pAnchorSessionID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_non_anchor_score
	ON fn.FrameworkNodeID=fns_non_anchor_score.FrameworkNodeID
  JOIN dbo.SEFrameworkNodeScore fns_anchor_score
	ON fn.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
  JOIN dbo.SEEvalSession es_non_anchor
	ON es_non_anchor.EvalSessionID=fns_non_anchor_score.EvalSessionID
 WHERE fns_non_anchor_score.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
   AND f.FrameworkTypeID=1
   AND es_non_anchor.AnchorSessionID=@pAnchorSessionID
   AND fns_non_anchor_score.PerformanceLevelID IS NOT NULL
  
-- get the anchor summative scores
SELECT fn.ShortName
	  ,fns_anchor_score.PerformanceLevelID AS AnchorScore
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_anchor_score
	ON fn.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
  JOIN dbo.SEEvalSession es_anchor
	ON es_anchor.EvalSessionID=fns_anchor_score.EvalSessionID
 WHERE es_anchor.EvalSessionID=@pAnchorSessionID
   AND fns_anchor_score.PerformanceLevelID IS NOT NULL
   AND f.FrameworkTypeID=1

-- all non-anchor scorers from drift-detect sessions
SELECT DISTINCT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#FNSummativeScores rrs
  JOIN dbo.SEUser u
	ON rrs.NonAnchorUserID=u.SEUserID

-- get the non-anchor summative scores by scorer
SELECT fn.ShortName
	  ,fns_non_anchor_score.SEUserID
	  ,fns_non_anchor_score.PerformanceLevelID AS NonAnchorScore
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_non_anchor_score
	ON fn.FrameworkNodeID=fns_non_anchor_score.FrameworkNodeID
  JOIN dbo.SEEvalSession es_non_anchor
	ON es_non_anchor.EvalSessionID=fns_non_anchor_score.EvalSessionID
 WHERE es_non_anchor.AnchorSessionID=@pAnchorSessionID
   AND fns_non_anchor_score.PerformanceLevelID IS NOT NULL
   AND f.FrameworkTypeID=1
  
-- exact by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE x.NonAnchorScore=x.AnchorScore
 GROUP BY x.ShortName

-- adjacent by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.ShortName

-- adjacent-high by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.ShortName

-- adjacent-low by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)=1
 GROUP BY x.ShortName

-- non-adjacent by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.ShortName

-- non-adjacent-high by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.ShortName

-- non-adjacent-low by shortname
SELECT DISTINCT x.ShortName, COUNT(*) As Count
  FROM dbo.#FNSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)>1
 GROUP BY x.ShortName

-- now just get a count of each of the nonanchor scores by performancelevel
DELETE #FNSummativeScores
INSERT INTO #FNSummativeScores
       (FrameworkNodeID	
	   ,ShortName	
       ,NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
       )
SELECT fn.FrameworkNodeID
	  ,fn.ShortName
	  ,fns_non_anchor_score.PerformanceLevelID
	  ,fns_non_anchor_score.SEUserID 
	  ,es_non_anchor.EvalSessionID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_non_anchor_score
	ON fn.FrameworkNodeID=fns_non_anchor_score.FrameworkNodeID
  JOIN dbo.SEEvalSession es_non_anchor
	ON es_non_anchor.EvalSessionID=fns_non_anchor_score.EvalSessionID
  JOIN dbo.#AnchorSession anchor
	ON es_non_anchor.AnchorSessionID=anchor.EvalSessionID
 WHERE fns_non_anchor_score.PerformanceLevelID IS NOT NULL
   AND f.FrameworkTypeID=1
 
-- score count by shortname
SELECT DISTINCT x.ShortName, x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#FNSummativeScores x
 GROUP BY x.ShortName, x.NonAnchorScore

DROP TABLE #FNSummativeScores


CREATE TABLE dbo.#AnchorSession2(EvalSessionID BIGINT, EvaluatorUserID BIGINT, PerformanceLevelID SMALLINT)

INSERT INTO dbo.#AnchorSession2(EvalSessionID, EvaluatorUserID, PerformanceLevelID)
SELECT es.EvalSessionID
	  ,es.EvaluatorUserID
	  ,es.PerformanceLevelID
  FROM dbo.SEEvalSession es
 WHERE EvalSessionID=@pAnchorSessionID
   AND es.PerformanceLevelID IS NOT NULL


-- SUMMATIVE EVAL SESSION SOCRE --

CREATE TABLE #SessionSummativeScores
       (NonAnchorScore		SMALLINT
       ,NonAnchorUserID		BIGINT
	   ,NonAnchorEvalSessionID BIGINT
	   ,AnchorScore			SMALLINT
       ,AnchorUserID		BIGINT
       ,AnchorEvalSessionID BIGINT
       )

INSERT INTO #SessionSummativeScores
       (NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
	   ,AnchorScore	
       ,AnchorUserID
	   ,AnchorEvalSessionID
       )

SELECT es_non_anchor.PerformanceLevelID
	  ,es_non_anchor.EvaluatorUserID AS SEUserID
	  ,es_non_anchor.EvalSessionID
 	  ,es_anchor.PerformanceLevelID
	  ,es_anchor.EvaluatorUserID AS SEUserID 
	  ,es_anchor.EvalSessionID
  FROM dbo.SEEvalSession es_non_anchor
  JOIN dbo.#AnchorSession2 es_anchor
	ON es_non_anchor.AnchorSessionID=es_anchor.EvalSessionID
 WHERE es_non_anchor.PerformanceLevelID IS NOT NULL

  
-- get the anchor summative score
SELECT es_anchor.PerformanceLevelID AS AnchorScore
 FROM dbo.SEEvalSession es_anchor
 WHERE es_anchor.EvalSessionID=@pAnchorSessionID
   AND es_anchor.PerformanceLevelID IS NOT NULL

-- all non-anchor scorers from drift-detect sessions

SELECT DISTINCT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#SessionSummativeScores sss
  JOIN dbo.SEUser u
	ON sss.NonAnchorUserID=u.SEUserID

-- get the non-anchor summative scores by scorer
SELECT es_non_anchor.EvaluatorUserID AS SEUserID
	  ,es_non_anchor.PerformanceLevelID AS NonAnchorScore
 FROM dbo.SEEvalSession es_non_anchor
 WHERE es_non_anchor.AnchorSessionID=@pAnchorSessionID
   AND es_non_anchor.PerformanceLevelID IS NOT NULL

-- exact 
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE x.NonAnchorScore=x.AnchorScore

-- adjacent 
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)=1

-- adjacent-high
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)=1

-- adjacent-low
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)=1

-- non-adjacent
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)>1

-- non-adjacent-high
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)>1

-- non-adjacent-low
SELECT COUNT(*) As Count
  FROM dbo.#SessionSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)>1

-- now just get a count of each of the nonanchor scores by performancelevel
DELETE #SessionSummativeScores
INSERT INTO #SessionSummativeScores
       (NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
       )
SELECT es_non_anchor.PerformanceLevelID
	  ,es_non_anchor.EvaluatorUserID 
	  ,es_non_anchor.EvalSessionID
 FROM dbo.SEEvalSession es_non_anchor
  JOIN dbo.#AnchorSession anchor
	ON es_non_anchor.AnchorSessionID=anchor.EvalSessionID
 WHERE es_non_anchor.PerformanceLevelID IS NOT NULL

-- score count
SELECT DISTINCT x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#SessionSummativeScores x
 GROUP BY x.NonAnchorScore

DROP TABLE #SessionSummativeScores

GO


