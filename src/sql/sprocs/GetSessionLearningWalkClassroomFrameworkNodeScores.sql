IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSessionLearningWalkClassroomFrameworkNodeScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionLearningWalkClassroomFrameworkNodeScores.'
      DROP PROCEDURE dbo.GetSessionLearningWalkClassroomFrameworkNodeScores
   END
GO
PRINT '.. Creating sproc GetSessionLearningWalkClassroomFrameworkNodeScores.'
GO

CREATE PROCEDURE dbo.GetSessionLearningWalkClassroomFrameworkNodeScores
	@pSessionID	BIGINT
   ,@pClassroomID BIGINT
   ,@pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT FrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.PerformanceLevelID
	  ,fns.EvalSessionID
	  ,fns.SEUserID
  FROM dbo.SEFrameworkNodeScore fns
 WHERE fns.EvalSessionID=@pSessionID
   AND fns.LearningWalkClassroomID=@pClassroomID
   AND fns.SEUserID=@pUserID

