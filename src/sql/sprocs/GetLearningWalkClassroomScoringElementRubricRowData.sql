IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetLearningWalkClassroomScoringElementRubricRowData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkClassroomScoringElementRubricRowData.'
      DROP PROCEDURE dbo.GetLearningWalkClassroomScoringElementRubricRowData
   END
GO
PRINT '.. Creating sproc GetLearningWalkClassroomScoringElementRubricRowData.'
GO

CREATE PROCEDURE dbo.GetLearningWalkClassroomScoringElementRubricRowData
	@pRubricRowID BIGINT
   ,@pLearningWalkClassroomID   BIGINT
   ,@pUserID		BIGINT
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
	  PerformanceLevelTitle VARCHAR(20)
	 ,DescriptorText VARCHAR(MAX)
	 ,PerformanceLevelID SMALLINT
)

INSERT INTO #Data(PerformanceLevelTitle, DescriptorText, PerformanceLevelID)
SELECT 'UNSATISFACTORY'
      ,rr.PL1Descriptor
      ,1 AS PerformanceLevelID
  FROM dbo.SERubricRow rr 
 WHERE rr.RubricRowID=@pRubricRowID

INSERT INTO #Data(PerformanceLevelTitle, DescriptorText, PerformanceLevelID)
SELECT 'BASIC'
      ,rr.PL2Descriptor
      ,2 AS PerformanceLevelID
  FROM dbo.SERubricRow rr 
 WHERE rr.RubricRowID=@pRubricRowID
   
INSERT INTO #Data(PerformanceLevelTitle, DescriptorText, PerformanceLevelID)
SELECT 'PROFICIENT'
      ,rr.PL3Descriptor
      ,3 AS PerformanceLevelID
  FROM dbo.SERubricRow rr 
 WHERE rr.RubricRowID=@pRubricRowID
   
INSERT INTO #Data(PerformanceLevelTitle, DescriptorText, PerformanceLevelID)
SELECT 'DISTINGUISHED'
      ,rr.PL4Descriptor
      ,4 AS PerformanceLevelID
  FROM dbo.SERubricRow rr 
 WHERE rr.RubricRowID=@pRubricRowID
   

SELECT PerformanceLevelTitle
	  ,DescriptorText
	  ,PerformanceLevelID
	  ,@pRubricRowID AS RubricRowID
  FROM dbo.#Data
 ORDER BY PerformanceLevelID DESC
  
DROP TABLE dbo.#Data

