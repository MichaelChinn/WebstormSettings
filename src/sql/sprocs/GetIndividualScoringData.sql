if exists (select * from sysobjects 
where id = object_id('dbo.GetIndividualScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetIndividualScoringData.'
      drop procedure dbo.GetIndividualScoringData
   END
GO
PRINT '.. Creating sproc GetIndividualScoringData.'
GO
CREATE PROCEDURE dbo.GetIndividualScoringData
	 @pDistrictCode		VARCHAR(20)
	,@pSchoolCode	VARCHAR(20)
	,@pEvalTypeID SMALLINT
    ,@pAnchorSessionID	SMALLINT

AS
SET NOCOUNT ON 

CREATE TABLE dbo.#AnchorSession(EvalSessionID BIGINT)

IF (@pAnchorSessionID IS NOT NULL)
BEGIN
	INSERT INTO dbo.#AnchorSession(EvalSessionID)
	SELECT es.EvalSessionID
	  FROM dbo.SEEvalSession es
	 WHERE EvalSessionID=@pAnchorSessionID
	   AND es.EvaluationTypeID=@pEvalTypeID
END
ELSE
BEGIN
	INSERT INTO dbo.#AnchorSession(EvalSessionID)
	SELECT es.EvalSessionID
	  FROM dbo.SEEvalSession es
	  JOIN dbo.SEEvaluationScoreType st
		ON es.EvaluationScoreTypeID=st.EvaluationScoreTypeID
	 WHERE es.DistrictCode=@pDistrictCode
	   AND es.SchoolCode=@pSchoolCode
	   AND st.Name='Anchor'
	   AND es.EvaluationTypeID=@pEvalTypeID
END

CREATE TABLE #RubricRowScores
       (RubricRowID			BIGINT
	   ,StateCriteria		VARCHAR(20)
       ,NonAnchorScore		SMALLINT
       ,NonAnchorUserID		BIGINT
	   ,NonAnchorEvalSessionID BIGINT
	   ,AnchorScore			SMALLINT
       ,AnchorUserID		BIGINT
       ,AnchorEvalSessionID BIGINT
       )

INSERT INTO #RubricRowScores
       (RubricRowID	
	   ,StateCriteria	
       ,NonAnchorScore	
       ,NonAnchorUserID
	   ,NonAnchorEvalSessionID
	   ,AnchorScore	
       ,AnchorUserID
	   ,AnchorEvalSessionID
       )

SELECT rr.RubricRowID
	  ,fn.ShortName
	  ,rrs_non_anchor_score.PerformanceLevelID
	  ,rrs_non_anchor_score.SEUserID 
	  ,es_non_anchor.EvalSessionID
 	  ,rrs_anchor_score.PerformanceLevelID
	  ,rrs_anchor_score.SEUserID 
	  ,anchor.EvalSessionID
 FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
	ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f
	ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SERubricRowScore rrs_non_anchor_score
	ON rr.RubricRowID=rrs_non_anchor_score.RubricRowID
  JOIN dbo.SERubricRowScore rrs_anchor_score
	ON rr.RubricRowID=rrs_anchor_score.RubricRowID
  JOIN dbo.#AnchorSession anchor
	ON rrs_anchor_score.EvalSessionID=anchor.EvalSessionID
  JOIN dbo.SEEvalSession es_non_anchor
	ON es_non_anchor.EvalSessionID=rrs_non_anchor_score.EvalSessionID
 WHERE rrs_non_anchor_score.RubricRowID=rrs_anchor_score.RubricRowID
   AND f.FrameworkTypeID=1
   AND es_non_anchor.AnchorSessionID=anchor.EvalSessionID
   

-- all non-anchor scorers from validity sessions

SELECT DISTINCT u.SEUserID, u.FirstName, u.LastName
  FROM dbo.#RubricRowScores rrs
  JOIN dbo.SEUser u
	ON rrs.NonAnchorUserID=u.SEUserID

-- exact by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#RubricRowScores x
 WHERE x.NonAnchorScore=x.AnchorScore
 GROUP BY x.NonAnchorUserID, x.StateCriteria

-- adjacent by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#RubricRowScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)=1
 GROUP BY x.NonAnchorUserID, x.StateCriteria

-- non-adjacent by criteria
SELECT DISTINCT x.NonAnchorUserID AS SEUserID, x.StateCriteria, COUNT(*) As Count
  FROM dbo.#RubricRowScores x
 WHERE ABS(x.NonAnchorScore-x.AnchorScore)>1
 GROUP BY x.NonAnchorUserID, x.StateCriteria

DROP TABLE #RubricRowScores


