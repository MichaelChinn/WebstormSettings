IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetLearningWalkClassroomScoringElements') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkClassroomScoringElements.'
      DROP PROCEDURE dbo.GetLearningWalkClassroomScoringElements
   END
GO
PRINT '.. Creating sproc GetLearningWalkClassroomScoringElements.'
GO

CREATE PROCEDURE dbo.GetLearningWalkClassroomScoringElements
    @pLearningWalkClassroomID   BIGINT
   ,@pUserID		BIGINT
   ,@pFocusOnly     BIT = 0
AS

SET NOCOUNT ON 

DECLARE @SessionID BIGINT, @FrameworkID BIGINT

SELECT @SessionID = ps.AnchorSessionID
  FROM dbo.SELearningWalkClassroom c
  JOIN dbo.SEPracticeSession ps ON c.PracticeSessionID=ps.PracticeSessionID
 WHERE c.LearningWalkClassroomID=@pLearningWalkClassroomID
 
 SELECT @FrameworkID = f.FrameworkID
   FROM dbo.SEFramework f
   JOIN dbo.SEEvalSession s ON f.DistrictCode=s.DistrictCode
  WHERE s.SchoolYear=f.SchoolYear
    AND s.EvaluationTYpeID=f.EvaluationTypeID
    AND s.EvalSessionID=@SessionID
    AND f.FrameworkTypeID=1
 
CREATE TABLE dbo.#Data(
	 ID BIGINT
	,FrameworkNodeID BIGINT NULL
    ,ShortName VARCHAR(50)
    ,Title VARCHAR(600)
    ,PerformanceLevelID SMALLINT
    ,IsFrameworkNode BIT
    ,HasFocus BIT)

-- Add a row for each frameworknode
INSERT INTO dbo.#Data(ID, FrameworkNodeID, ShortName, Title, PerformanceLevelID, IsFrameworkNode, HasFocus)
SELECT DISTINCT
	   fn.FrameworkNodeID
	  ,fn.FrameworkNodeID
	  ,fn.ShortName
	  ,fn.Title
	  ,0
	  ,1
	  ,0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
    ON fn.FrameworkID=f.FrameworkID
 WHERE fn.FrameworkID=@FrameworkID 
 
 UPDATE #Data
    SET PerformanceLevelID=fns.PerformanceLevelID
   FROM dbo.SEFrameworkNodeScore fns
  WHERE #Data.ID=fns.FrameworkNodeID
    AND fns.EvalSessionID=@SessionID
    AND fns.SEUserID=@pUserID
    AND fns.LearningWalkClassroomID=@pLearningWalkClassroomID
   
-- Add a row for each rubricrow
INSERT INTO dbo.#Data(ID, FrameworkNodeID, ShortName, Title, PerformanceLevelID, IsFrameworkNode, HasFocus)
SELECT rr.RubricRowID
	  ,fn.FrameworkNodeID
	  ,rr.ShortName
	  ,rr.Title
	  ,0
	  ,0
	  ,0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f
    ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SERubricRowFrameworkNode rrfn 
    ON fn.FrameworkNodeID=rrfn.FrameworkNodeID 
  JOIN dbo.SERubricRow rr
    ON rrfn.RubricRowID=rr.RubricRowID
 WHERE fn.FrameworkID=@FrameworkID 
 
 UPDATE #Data
    SET PerformanceLevelID=rrs.PerformanceLevelID
   FROM dbo.SERubricRowScore rrs
  WHERE #Data.ID=rrs.RubricRowID
    AND rrs.EvalSessionID=@SessionID
    AND rrs.SEUserID=@pUserID
    AND rrs.LearningWalkClassroomID=@pLearningWalkClassroomID
	AND #Data.IsFrameworkNode=0
    
 UPDATE d
    SET HasFocus =CASE WHEN (x.COUNT=0) THEN 0 ELSE 1 END
   FROM #Data d
   JOIN (SELECT COUNT(rrf.RubricRowID) AS COUNT, rrfn.FrameworkNodeID
		   FROM dbo.SEEvalSessionRubricRowFocus rrf
		   JOIN dbo.SERubricRowFrameworkNode rrfn ON rrf.RubricRowID=rrfn.RubricRowID
		  WHERE rrf.EvalSessionID=@SessionID
		 GROUP BY rrfn.FrameworkNodeID) x ON (d.FrameworkNodeID=x.FrameworkNodeID)
 WHERE d.IsFrameworkNode = 1
  
  UPDATE d
    SET HasFocus =CASE WHEN (x.COUNT=0) THEN 0 ELSE 1 END
   FROM #Data d
   JOIN (SELECT COUNT(rrf.RubricRowID) AS COUNT, rrfn.RubricRowID
		   FROM dbo.SEEvalSessionRubricRowFocus rrf
		   JOIN dbo.SERubricRowFrameworkNode rrfn ON rrf.RubricRowID=rrfn.RubricRowID
		  WHERE rrf.EvalSessionID=@SessionID
		 GROUP BY rrfn.RubricRowID) x ON (d.ID=x.RubricRowID)
  WHERE d.IsFrameworkNode=0
 
SELECT ID
	  ,FrameworkNodeID
      ,ShortName
      ,Title
      ,IsFrameworkNode
      ,PerformanceLevelID
  FROM dbo.#Data
 WHERE (@pFocusOnly = 0 OR HasFocus=1)
 ORDER BY FrameworkNodeID, ID ASC
  
DROP TABLE dbo.#Data

