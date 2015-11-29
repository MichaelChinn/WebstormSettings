if exists (select * from sysobjects 
where id = object_id('dbo.GetIndividualSummativeScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetIndividualSummativeScoringData.'
      drop procedure dbo.GetIndividualSummativeScoringData
   END
GO
PRINT '.. Creating sproc GetIndividualSummativeScoringData.'
GO
CREATE PROCEDURE dbo.GetIndividualSummativeScoringData
	 @pDistrictCode		VARCHAR(20)
	,@pSchoolCode	VARCHAR(20)
	,@pEvalTypeID SMALLINT
    ,@pAnchorSessionID	SMALLINT

AS
SET NOCOUNT ON 

CREATE TABLE dbo.#AnchorSession(EvalSessionID BIGINT)

INSERT INTO dbo.#AnchorSession(EvalSessionID)
SELECT es.EvalSessionID
  FROM dbo.SEEvalSession es
 WHERE EvalSessionID=@pAnchorSessionID
   AND es.EvaluationTypeID=@pEvalTypeID

CREATE TABLE #SummativeScores
       (FrameworkNodeId		BIGINT
	   ,StateCriteria		VARCHAR(20)
       ,NonAnchorScore		SMALLINT
       ,NonAnchorUserID		BIGINT
	   ,NonAnchorEvalSessionID BIGINT
	   ,AnchorScore			SMALLINT
       ,AnchorUserID		BIGINT
       ,AnchorEvalSessionID BIGINT
       )

INSERT INTO #SummativeScores
       (FrameworkNodeID
	   ,StateCriteria	
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
	  ,anchor.EvalSessionID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_non_anchor_score
	ON fn.FrameworkNodeID=fns_non_anchor_score.FrameworkNodeID
  JOIN dbo.SEFrameworkNodeScore fns_anchor_score
	ON fn.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
  JOIN dbo.#AnchorSession anchor
	ON fns_anchor_score.EvalSessionID=anchor.EvalSessionID
  JOIN dbo.SEEvalSession es_non_anchor
	ON es_non_anchor.EvalSessionID=fns_non_anchor_score.EvalSessionID
 WHERE fns_non_anchor_score.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
   AND f.FrameworkTypeID=1
   AND es_non_anchor.AnchorSessionID=anchor.EvalSessionID
  
-- get the anchor summative scores
SELECT fn.ShortName AS StateCriteria
	  ,fns_anchor_score.PerformanceLevelID AS AnchorScore
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEFrameworkNodeScore fns_anchor_score
	ON fn.FrameworkNodeID=fns_anchor_score.FrameworkNodeID
  JOIN dbo.SEEvalSession es_anchor
	ON es_anchor.EvalSessionID=fns_anchor_score.EvalSessionID
 WHERE f.FrameworkTypeID=1
   AND es_anchor.EvalSessionID=@pAnchorSessionID

-- all non-anchor scorers from validity sessions

SELECT DISTINCT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#SummativeScores rrs
  JOIN dbo.SEUser u
	ON rrs.NonAnchorUserID=u.SEUserID

-- exact by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#SummativeScores x
 WHERE x.NonAnchorScore=x.AnchorScore
 GROUP BY x.NonAnchorUserID, x.StateCriteria

-- adjacent by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#SummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.NonAnchorUserID, x.StateCriteria

-- non-adjacent by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#SummativeScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.NonAnchorUserID, x.StateCriteria

DROP TABLE #SummativeScores


