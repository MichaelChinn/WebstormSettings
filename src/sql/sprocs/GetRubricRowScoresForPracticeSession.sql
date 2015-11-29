IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowScoresForPracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowScoresForPracticeSession.'
      DROP PROCEDURE dbo.GetRubricRowScoresForPracticeSession
   END
GO
PRINT '.. Creating sproc GetRubricRowScoresForPracticeSession.'
GO

CREATE PROCEDURE dbo.GetRubricRowScoresForPracticeSession
	@pPracticeSessionID BIGINT
   ,@pRubricRowID BIGINT
AS

SET NOCOUNT ON 

SELECT rrs.RubricRowID
	  ,rrs.PerformanceLevelID
	  ,rrs.SEUserID
	  ,rrs.EvalSessionID
	  ,u.FirstName + ' ' + u.LastName AS DisplayName
  FROM dbo.SERubricRowScore rrs
  JOIN dbo.SEEvalSession es
	ON rrs.EvalSessionID=es.EvalSessionID
  JOIN dbo.SEUser u
	ON rrs.SEUserID=u.SEUserID
  JOIN dbo.SEPracticeSessionParticipant psp
    ON rrs.EvalSessionID=psp.EvalSessionID
 WHERE psp.UserID=rrs.SEUserID
   AND psp.PracticeSessionID=@pPracticeSessionID
   AND rrs.RubricRowID=@pRubricRowID
 ORDER BY rrs.PerformanceLevelID DESC

