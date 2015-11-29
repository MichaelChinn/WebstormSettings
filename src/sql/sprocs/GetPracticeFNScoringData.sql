if exists (select * from sysobjects 
where id = object_id('dbo.GetPracticeFNScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeFNScoringData.'
      drop procedure dbo.GetPracticeFNScoringData
   END
GO
PRINT '.. Creating sproc GetPracticeFNScoringData.'
GO
CREATE PROCEDURE dbo.GetPracticeFNScoringData
    @pPracticeSessionID	BIGINT
	,@pFrameworkID  BIGINT
AS
SET NOCOUNT ON 
 
CREATE TABLE #NonAnchorSession(EvalSessionID BIGINT, UserID BIGINT)
INSERT dbo.#NonAnchorSession(EvalSessionID, UserID)
SELECT psp.EvalSessionID, psp.UserID
  FROM dbo.SEPracticeSessionParticipant psp
  JOIN dbo.SEPracticeSession ps ON psp.PracticeSessionID=ps.PracticeSessionID
 WHERE ps.PracticeSessionID=@pPracticeSessionID
  -- AND (ps.AnchorSessionID IS NULL OR psp.EvalSessionID<>ps.AnchorSessionID)
 
 -- Anchor Session can be either a participant or a separate anchor eval session created by the district admin
 CREATE TABLE #AnchorSession(EvalSessionID BIGINT, UserID BIGINT)
INSERT dbo.#AnchorSession(EvalSessionID, UserID)
SELECT s.EvalSessionID, s.EvaluatorUserID
  FROM dbo.SEPracticeSession ps
  JOIN dbo.SEEvalSession s ON ps.AnchorSessionID=s.EvalSessionID
 WHERE ps.PracticeSessionID=@pPracticeSessionID
 
--------------------- FrameworkNode Scores --------------------

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
SELECT fn.ShortName
	  ,fns.PerformanceLevelID AS AnchorScore
 FROM dbo.SEFrameworkNode fn
 JOIN dbo.SEFrameworkNodeScore fns
   ON fn.FrameworkNodeID=fns.FrameworkNodeID
 JOIN dbo.#AnchorSession s
   ON (fns.EvalSessionID=s.EvalSessionID AND fns.SEUserID=s.UserID)
WHERE fns.PerformanceLevelID IS NOT NULL
  AND fn.FrameworkID=@pFrameworkID

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
	  ,es.EvalSessionID
 FROM dbo.SEFrameworkNode fn
 JOIN dbo.SEFrameworkNodeScore fns
   ON fn.FrameworkNodeID=fns.FrameworkNodeID
 JOIN dbo.#NonAnchorSession es
   ON (fns.EvalSessionID=es.EvalSessionID AND fns.SEUserID=es.UserID)
WHERE fns.PerformanceLevelID IS NOT NULL
  AND fn.FrameworkID=@pFrameworkID
 
-- score count by shortname
SELECT DISTINCT x.ShortName, x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#FNSummativeScores x
 GROUP BY x.ShortName, x.NonAnchorScore

DROP TABLE #FNSummativeScores


--------------------- Session Scores --------------------

--------------------- Anchor Summative Scores ------------------
SELECT es.PerformanceLevelID AS AnchorScore
  FROM dbo.SEEvalSession es
  JOIN dbo.#AnchorSession s_anchor
    ON (es.EvalSessionID=s_anchor.EvalSessionID AND s_anchor.UserID=es.EvaluatorUserID)
 WHERE es.PerformanceLevelID IS NOT NULL

--------------------- All Non-Anchor Scorers ------------------
SELECT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#Scorer s
  JOIN dbo.SEUser u
    ON s.UserID=u.SEUserID
   
--------------------- Non-Anchor Summative Scores ------------------
SELECT es.EvaluatorUserID AS SEUserID
	  ,es.PerformanceLevelID AS NonAnchorScore
 FROM dbo.SEEvalSession es
 JOIN dbo.#NonAnchorSession es_no_anchor
   ON (es.EvalSessionID=es_no_anchor.EvalSessionID AND es_no_anchor.UserID=es.EvaluatorUserID)
 WHERE es.PerformanceLevelID IS NOT NULL


--------------------- Suumative Session Scores comparing anchor/non-anchor ------------------

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
SELECT s_non_anchor_2.PerformanceLevelID
	  ,s_non_anchor.UserID AS SEUserID
	  ,s_non_anchor.EvalSessionID
 	  ,s_anchor_2.PerformanceLevelID
	  ,s_anchor.UserID AS SEUserID 
	  ,s_anchor.EvalSessionID
  FROM dbo.#NonAnchorSession s_non_anchor
  JOIN dbo.#AnchorSession s_anchor
    ON s_non_anchor.EvalSessionID<>s_anchor.EvalSessionID
  JOIN dbo.SEEvalSEssion s_non_anchor_2
    ON s_non_anchor.EvalSessionID=s_non_anchor_2.EvalSessionID
  JOIN dbo.SEEvalSEssion s_anchor_2
    ON s_anchor.EvalSessionID=s_anchor_2.EvalSessionID
 WHERE s_non_anchor_2.PerformanceLevelID IS NOT NULL
   AND s_anchor_2.PerformanceLevelID IS NOT NULL
   
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

--------------------- Count of each Non-Anchor score by performance level ------------------
DELETE #SessionSummativeScores

INSERT INTO #SessionSummativeScores
       (NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
       )
SELECT s_non_anchor_2.PerformanceLevelID
	  ,s_non_anchor.UserID  AS EvaluatorUserID
	  ,s_non_anchor.EvalSessionID 
  FROM dbo.#NonAnchorSession s_non_anchor
  JOIN dbo.#AnchorSession s_anchor
    ON s_non_anchor.EvalSessionID<>s_anchor.EvalSessionID
  JOIN dbo.SEEvalSEssion s_non_anchor_2
    ON s_non_anchor.EvalSessionID=s_non_anchor_2.EvalSessionID
  JOIN dbo.SEEvalSEssion s_anchor_2
    ON s_anchor.EvalSessionID=s_anchor_2.EvalSessionID
 WHERE s_non_anchor_2.PerformanceLevelID IS NOT NULL

-- score count
SELECT DISTINCT x.NonAnchorScore, COUNT(x.NonAnchorScore) AS COUNT
  FROM dbo.#SessionSummativeScores x
 GROUP BY x.NonAnchorScore

DROP TABLE #SessionSummativeScores

GO


