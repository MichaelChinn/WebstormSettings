if exists (select * from sysobjects 
where id = object_id('dbo.GetSSRFNScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSSRFNScoringData.'
      drop procedure dbo.GetSSRFNScoringData
   END
GO
PRINT '.. Creating sproc GetSSRFNScoringData.'
GO
CREATE PROCEDURE dbo.GetSSRFNScoringData
    @pEvaluatorID BIGINT = NULL
	,@pFrameworkID  BIGINT
	,@pAssignedOnly BIT = NULL
	,@pEvalTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20) = NULL
AS
SET NOCOUNT ON 

CREATE TABLE #User(UserID BIGINT)
IF (@pSchoolCode IS NOT NULL)
BEGIN
INSERT INTO #User(UserID)
SELECT DISTINCT u.SEUserID
  FROM  dbo.SEUser u
  JOIN dbo.SEEvaluation e ON e.EvaluateeID=u.SEUserID
  JOIN dbo.SEUserDistrictSchool uds ON u.SEUserID=uds.SEUserID
 WHERE e.EvaluationTypeID=@pEvalTypeID
   AND e.SchoolYear=@pSchoolYear
   AND e.DistrictCode=@pDistrictCode
   AND ((@pAssignedOnly=0 AND uds.DistrictCode=@pDistrictCode AND uds.SchoolCode=@pSchoolCode) OR e.EvaluatorID=@pEvaluatorID)
END
ELSE
BEGIN
INSERT INTO #User(UserID)
SELECT DISTINCT u.SEUserID
  FROM  dbo.SEUser u
  JOIN dbo.SEEvaluation e ON e.EvaluateeID=u.SEUserID
  JOIN dbo.SEUserDistrictSchool uds ON u.SEUserID=uds.SEUserID
 WHERE e.EvaluationTypeID=@pEvalTypeID
   AND e.SchoolYear=@pSchoolYear
   AND e.DistrictCode=@pDistrictCode
   AND uds.DistrictCode=@pDistrictCode
END
   
CREATE TABLE #FrameworkNodeSummativeScore(ShortName VARCHAR(20), UserID BIGINT, PerformanceLevelID SMALLINT)
   
--------------------- Summative Final Scores ------------------
SELECT e.EvaluateeID AS UserID
	  ,e.PerformanceLevelID
 FROM dbo.SEEvaluation e
 JOIN dbo.#User u ON e.EvaluateeID=u.UserID
WHERE e.PerformanceLevelID IS NOT NULL
  AND e.SchoolYear=@pSchoolYear
  AND e.DistrictCode=@pDistrictCode

--------------------- Summative  Scores ------------------
INSERT INTO  #FrameworkNodeSummativeScore(ShortName, UserID, PerformanceLevelID)
SELECT DISTINCT 
	   fn.ShortName
	  ,fns.EvaluateeID
	  ,fns.PerformanceLevelID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SESummativeFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.#User u
    ON fns.EvaluateeID=u.UserID
  JOIN dbo.SEEvaluation e ON e.EvaluateeID=u.UserID AND e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND f.SchoolYear=@pSchoolYear
   AND f.DistrictCode=@pDistrictCode
   AND (e.EvaluateePlanTypeID=1 OR e.FocusedFrameworkNodeID=fn.FrameworkNodeID)

SELECT 
	  fn.UserID
     ,FN.ShortName
     ,FN.PerformanceLevelID
 FROM #FrameworkNodeSummativeScore fn


GO


