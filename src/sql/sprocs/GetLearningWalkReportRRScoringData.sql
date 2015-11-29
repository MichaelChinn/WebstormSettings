if exists (select * from sysobjects 
where id = object_id('dbo.GetLearningWalkReportRRScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkReportRRScoringData.'
      drop procedure dbo.GetLearningWalkReportRRScoringData
   END
GO
PRINT '.. Creating sproc GetLearningWalkReportRRScoringData.'
GO
CREATE PROCEDURE dbo.GetLearningWalkReportRRScoringData
	 @pPracticeSessionID BIGINT
	,@pFrameworkID  BIGINT
	,@pFrameworkNodeID BIGINT
AS
SET NOCOUNT ON 

CREATE TABLE #Classroom(ClassroomID BIGINT)

INSERT INTO #Classroom(ClassroomID)
SELECT DISTINCT c.LearningWalkClassRoomID
  FROM  dbo.SELearningWalkClassRoom c
  JOIN dbo.SEPracticeSession ps ON c.PracticeSessionID=ps.PracticeSessionID

--------------------- FN Summative  Scores ------------------
CREATE TABLE #FrameworkNodeScore(ShortName VARCHAR(20), ClassroomID BIGINT, PerformanceLevelID SMALLINT)

INSERT INTO  #FrameworkNodeScore(ShortName, ClassroomID, PerformanceLevelID)
SELECT DISTINCT 
	   fn.ShortName
	  ,fns.LearningWalkClassroomID
	  ,fns.PerformanceLevelID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.#Classroom c
    ON fns.LearningWalkClassroomID=c.ClassroomID
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fns.FrameworkNodeID=@pFrameworkNodeID
 
 --------------------- RR Summative  Scores ------------------
CREATE TABLE #RubricRowScore(RubricRowID BIGINT, ShortName VARCHAR(20), ClassroomID BIGINT, PerformanceLevelID SMALLINT)

INSERT INTO  #RubricRowScore(RubricRowID, ShortName, ClassroomID, PerformanceLevelID)
SELECT DISTINCT 
	   rr.RubricRowID
	  ,fn.ShortName
	  ,fns.LearningWalkClassroomID
	  ,fns.PerformanceLevelID
 FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFrameworkNodeScore fns
	ON fn.FrameworkNodeID=fns.FrameworkNodeID
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
 JOIN dbo.SERubricRowScore rrs   
   ON rrs.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SERubricRow rr
   ON rrs.RubricRowID=rr.RubricRowID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.#Classroom c
    ON fns.LearningWalkClassroomID=c.ClassroomID
 WHERE fns.PerformanceLevelID IS NOT NULL
   AND fn.FrameworkID=@pFrameworkID
   AND fn.FrameworkNodeID=@pFrameworkNodeID
   AND fns.LearningWalkClassroomID=rrs.LearningWalkClassroomID

--------------------- FrameworkNode Score ------------------
SELECT 
	  ClassroomID
     ,ShortName
     ,PerformanceLevelID
 FROM #FrameworkNodeScore

--------------------- RubricRow Scores ------------------

SELECT 
	  ClassroomID
	 ,RubricRowID AS Id
     ,ShortName
     ,PerformanceLevelID
 FROM #RubricRowScore
 
GO


