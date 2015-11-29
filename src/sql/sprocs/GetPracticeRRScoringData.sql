if exists (select * from sysobjects 
where id = object_id('dbo.GetPracticeRRScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeRRScoringData.'
      drop procedure dbo.GetPracticeRRScoringData
   END
GO
PRINT '.. Creating sproc GetPracticeRRScoringData.'
GO
CREATE PROCEDURE dbo.GetPracticeRRScoringData
    @pPracticeSessionID	SMALLINT
	,@pFrameworkID  BIGINT
	,@pFrameworkNodeShortName VARCHAR(20)
AS
SET NOCOUNT ON 

CREATE TABLE #NonAnchorSession(EvalSessionID BIGINT, UserID BIGINT)
INSERT dbo.#NonAnchorSession(EvalSessionID, UserID)
SELECT psp.EvalSessionID, psp.UserID
  FROM dbo.SEPracticeSessionParticipant psp
  JOIN dbo.SEPracticeSession ps ON psp.PracticeSessionID=ps.PracticeSessionID
 WHERE ps.PracticeSessionID=@pPracticeSessionID
   AND (ps.AnchorSessionID IS NULL OR psp.EvalSessionID<>ps.AnchorSessionID)
 
 CREATE TABLE #AnchorSession(EvalSessionID BIGINT, UserID BIGINT)
INSERT dbo.#AnchorSession(EvalSessionID, UserID)
SELECT psp.EvalSessionID, psp.UserID
  FROM dbo.SEPracticeSessionParticipant psp
  JOIN dbo.SEPracticeSession ps ON psp.PracticeSessionID=ps.PracticeSessionID
 WHERE ps.PracticeSessionID=@pPracticeSessionID
   AND (ps.AnchorSessionID IS NOT NULL AND psp.EvalSessionID=ps.AnchorSessionID)

--------------------- RubricRow Scores --------------------

--------------------- All Non-Anchor Scorers ------------------   
CREATE TABLE dbo.#Scorer(UserID BIGINT)
INSERT INTO dbo.#Scorer(UserID)
SELECT DISTINCT fns.SEUserID
 FROM dbo.SEFrameworkNode fn
 JOIN dbo.SEFrameworkNodeScore fns
   ON fn.FrameworkNodeID=fns.FrameworkNodeID
 JOIN dbo.#NonAnchorSession s
   ON (fns.EvalSessionID=s.EvalSessionID AND fns.SEUserID=s.UserID)
WHERE fns.PerformanceLevelID IS NOT NULL
  AND fn.FrameworkID=@pFrameworkID
   
INSERT INTO dbo.#Scorer(UserID)
SELECT DISTINCT es.EvaluatorUserID
 FROM dbo.SEEvalSession es
 JOIN dbo.#NonAnchorSession s
   ON (es.EvalSessionID=s.EvalSessionID AND es.EvaluatorUserID=s.UserID)
WHERE es.PerformanceLevelID IS NOT NULL
  AND es.EvaluatorUserID NOT IN (SELECT UserID FROM dbo.#Scorer)
   
--------------------- Anchor Summative Scores ------------------
SELECT rr.RubricRowId
      ,rr.Title
	  ,rrs.PerformanceLevelID AS AnchorScore
 FROM dbo.SERubricRow rr
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs
	ON rr.RubricRowID=rrs.RubricRowID
 JOIN dbo.#AnchorSession s
   ON (rrs.EvalSessionID=s.EvalSessionID AND rrs.SEUserID=s.UserID)
 WHERE rrs.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

--------------------- All Non-Anchor Scorers ------------------
SELECT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#Scorer s
  JOIN dbo.SEUser u
    ON s.UserID=u.SEUserID

--------------------- Non-Anchor Summative Scores ------------------
SELECT rr.RubricRowId
	  ,rr.Title
	  ,rrs.SEUserID
	  ,rrs.PerformanceLevelID AS NonAnchorScore
 FROM dbo.SERubricRow rr 
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs
	ON rr.RubricRowID=rrs.RubricRowID
 JOIN dbo.#NonAnchorSession es
   ON (rrs.EvalSessionID=es.EvalSessionID AND rrs.SEUserID=es.UserID)
 WHERE rrs.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

--------------------- Suumative Rubric Row Scores comparing anchor/non-anchor ------------------
CREATE TABLE dbo.#RRSummativeScores
       (RubricRowId		BIGINT
	   ,Title		VARCHAR(MAX)
       ,NonAnchorScore		SMALLINT
       ,NonAnchorUserID		BIGINT
	   ,NonAnchorEvalSessionID BIGINT
	   ,AnchorScore			SMALLINT
       ,AnchorUserID		BIGINT
       ,AnchorEvalSessionID BIGINT
       )

INSERT INTO dbo.#RRSummativeScores
       (RubricRowID
	   ,Title	
       ,NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
	   ,AnchorScore	
       ,AnchorUserID
	   ,AnchorEvalSessionID
       )
SELECT rr.RubricRowID
	  ,rr.Title
	  ,rrs_non_anchor_score.PerformanceLevelID
	  ,rrs_non_anchor_score.SEUserID 
	  ,s_non_anchor.EvalSessionID
 	  ,rrs_anchor_score.PerformanceLevelID
	  ,rrs_anchor_score.SEUserID 
	  ,s_anchor.EvalSessionID
 FROM dbo.SERubricRowScore rrs_non_anchor_score
 JOIN dbo.SERubricRowScore rrs_anchor_score
   ON rrs_non_anchor_score.RubricRowID=rrs_anchor_score.RubricRowID
 JOIN dbo.SERubricRow rr
   ON rrs_non_anchor_score.RubricRowID=rr.RubricRowID
 JOIN dbo.#AnchorSession s_anchor
   ON (rrs_anchor_score.EvalSessionID=s_anchor.EvalSessionID AND rrs_anchor_score.SEUserID=s_anchor.UserID)
 JOIN dbo.#NonAnchorSession s_non_anchor
   ON (rrs_non_anchor_score.EvalSEssionID=s_non_anchor.EvalSessionID AND rrs_non_anchor_score.SEUserID=s_non_anchor.UserID)   
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rrs_anchor_score.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
WHERE fn.FrameworkID=@pFrameworkID
  AND rrs_non_anchor_score.PerformanceLevelID IS NOT NULL
  AND fn.ShortName=@pFrameworkNodeShortName

-- exact by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE x.NonAnchorScore=x.AnchorScore
 GROUP BY x.RubricRowId, x.Title

-- adjacent by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.RubricRowId, x.Title

-- adjacent-high by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.RubricRowId, x.Title

-- adjacent-low by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)=1
 GROUP BY x.RubricRowId, x.Title

-- non-adjacent by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.RubricRowId, x.Title

-- non-adjacent-high by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE (x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.RubricRowId, x.Title

-- non-adjacent-low by Title
SELECT DISTINCT x.RubricRowId, x.Title, COUNT(*) As Count
  FROM dbo.#RRSummativeScores x
 WHERE (x.AnchorScore-x.NonAnchorScore)>1
 GROUP BY x.RubricRowId, x.Title

--------------------- Count of each Non-Anchor score by performance level ------------------
DELETE #RRSummativeScores

INSERT INTO #RRSummativeScores
       (RubricRowID	
	   ,Title	
       ,NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
       )
SELECT rr.RubricRowID
	  ,rr.Title
	  ,rrs.PerformanceLevelID
	  ,rrs.SEUserID 
	  ,es.EvalSessionID
 FROM dbo.SERubricRow rr
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRowScore rrs
	ON rr.RubricRowID=rrs.RubricRowID
 JOIN dbo.#NonAnchorSession es
   ON (rrs.EvalSessionID=es.EvalSessionID AND rrs.SEUserID=es.UserID)
 WHERE rrs.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

-- score count by Title
SELECT DISTINCT x.RubricRowId, x.Title, x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#RRSummativeScores x
 GROUP BY x.RubricRowId, x.Title, x.NonAnchorScore

DROP TABLE #RRSummativeScores

--------------------- FrameworkNode Scores --------------------

--------------------- Anchor Summative Scores ------------------
SELECT fn.ShortName
	  ,fns.PerformanceLevelID AS AnchorScore
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.#AnchorSession s
    ON (fns.EvalSessionID=s.EvalSessionID AND fns.SEUserID=s.UserID)
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

--------------------- All Non-Anchor Scorers ------------------   
SELECT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#Scorer s
  JOIN dbo.SEUser u
    ON s.UserID=u.SEUserID

--------------------- Non-Anchor Summative Scores ------------------
SELECT fn.ShortName
	  ,fns.SEUserID
	  ,fns.PerformanceLevelID AS NonAnchorScore
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.#NonAnchorSession s
    ON (fns.EvalSessionID=s.EvalSessionID AND fns.SEUserID=s.UserID)
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

--------------------- Suumative FrameworkNode Scores comparing anchor/non-anchor ------------------

CREATE TABLE #FNSummativeScores
       (FrameworkNodeId			BIGINT
	   ,ShortName				VARCHAR(20)
       ,NonAnchorScore			SMALLINT
       ,NonAnchorUserID			BIGINT
	   ,NonAnchorEvalSessionID	BIGINT
	   ,AnchorScore				SMALLINT
       ,AnchorUserID			BIGINT
       ,AnchorEvalSessionID		BIGINT
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
	  ,s_non_anchor.EvalSessionID
 	  ,fns_anchor_score.PerformanceLevelID
	  ,fns_anchor_score.SEUserID 
	  ,s_anchor.EvalSessionID
 FROM dbo.SEFrameworkNodeScore fns_non_anchor_score
 JOIN dbo.SEFrameworkNodeScore fns_anchor_score
   ON fns_non_anchor_score.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
 JOIN dbo.#AnchorSession s_anchor
   ON (fns_anchor_score.EvalSessionID=s_anchor.EvalSessionID AND fns_anchor_score.SEUserID=s_anchor.UserID)
 JOIN dbo.#NonAnchorSession s_non_anchor
   ON (fns_non_anchor_score.EvalSEssionID=s_non_anchor.EvalSessionID AND fns_non_anchor_score.SEUserID=s_non_anchor.UserID)   
 JOIN dbo.SEFrameworkNode fn
   ON fns_non_anchor_score.FrameworkNodeID=fn.FrameworkNodeID
WHERE fn.FrameworkID=@pFrameworkID
  AND fns_non_anchor_score.PerformanceLevelID IS NOT NULL
  AND fn.ShortName=@pFrameworkNodeShortName
 
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

--------------------- Count of each Non-Anchor score by performance level ------------------
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
	  ,fns.PerformanceLevelID
	  ,fns.SEUserID 
	  ,s.EvalSessionID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.#NonAnchorSession s
    ON (fns.EvalSessionID=s.EvalSessionID AND fns.SEUserID=s.UserID)
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.ShortName=@pFrameworkNodeShortName

-- score count by shortname
SELECT DISTINCT x.ShortName, x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#FNSummativeScores x
 GROUP BY x.ShortName, x.NonAnchorScore

DROP TABLE #FNSummativeScores

GO


