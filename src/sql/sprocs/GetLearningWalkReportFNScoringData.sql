if exists (select * from sysobjects 
where id = object_id('dbo.GetLearningWalkReportFNScoringData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkReportFNScoringData.'
      drop procedure dbo.GetLearningWalkReportFNScoringData
   END
GO
PRINT '.. Creating sproc GetLearningWalkReportFNScoringData.'
GO
CREATE PROCEDURE dbo.GetLearningWalkReportFNScoringData
	 @pPracticeSessionID BIGINT
	,@pFrameworkID  BIGINT
AS
SET NOCOUNT ON 

CREATE TABLE #Classroom(ClassroomID BIGINT)

INSERT INTO #Classroom(ClassroomID)
SELECT DISTINCT c.LearningWalkClassRoomID
  FROM  dbo.SELearningWalkClassRoom c
  JOIN dbo.SEPracticeSession ps ON c.PracticeSessionID=ps.PracticeSessionID
 WHERE ps.PracticeSessionID=@pPracticeSessionID
     
--------------------- EvalSession Summative Scores ------------------
SELECT c.ClassroomID
	  ,s.PerformanceLevelID
 FROM dbo.SELearningWalkSessionScore s
 JOIN dbo.#Classroom c ON c.ClassroomID=s.ClassroomID
WHERE s.PerformanceLevelID IS NOT NULL

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

SELECT 
	  fn.ClassroomID
     ,FN.ShortName
     ,FN.PerformanceLevelID
 FROM #FrameworkNodeScore fn


GO


