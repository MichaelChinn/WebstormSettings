IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkNodeScoresForPracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkNodeScoresForPracticeSession.'
      DROP PROCEDURE dbo.GetFrameworkNodeScoresForPracticeSession
   END
GO
PRINT '.. Creating sproc GetFrameworkNodeScoresForPracticeSession.'
GO

CREATE PROCEDURE dbo.GetFrameworkNodeScoresForPracticeSession
	@pPracticeSessionID BIGINT
   ,@pFrameworkNodeID BIGINT
AS

SET NOCOUNT ON 

SELECT fns.FrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.PerformanceLevelID
	  ,fns.SEUserID
	  ,fns.EvalSessionID
	  ,u.FirstName + ' ' + u.LastName AS DisplayName
  FROM dbo.SEFrameworkNodeScore fns
  JOIN dbo.SEEvalSession es
	ON fns.EvalSessionID=es.EvalSessionID
  JOIN dbo.SEUser u
	ON fns.SEUserID=u.SEUserID
  JOIN dbo.SEPracticeSessionParticipant psp
    ON fns.EvalSessionID=psp.EvalSessionID
 WHERE psp.UserID=fns.SEUserID
   AND psp.PracticeSessionID=@pPracticeSessionID
   AND fns.FrameworkNodeID=@pFrameworkNodeID
 ORDER BY fns.PerformanceLevelID DESC

