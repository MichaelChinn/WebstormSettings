IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionFromEvalSessionId') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionFromEvalSessionId.'
      DROP PROCEDURE dbo.GetPracticeSessionFromEvalSessionId
   END
GO
PRINT '.. Creating sproc GetPracticeSessionFromEvalSessionId.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionFromEvalSessionId
	@pEvalSessionId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vPracticeSession s
  JOIN dbo.SEPracticeSessionParticipant p ON s.PracticeSessionID=p.PracticeSessionID
 WHERE p.EvalSessionID=@pEvalSessionID

