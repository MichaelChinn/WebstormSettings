IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionParticipantEvalSessions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionParticipantEvalSessions.'
      DROP PROCEDURE dbo.GetPracticeSessionParticipantEvalSessions
   END
GO
PRINT '.. Creating sproc GetPracticeSessionParticipantEvalSessions.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionParticipantEvalSessions
	 @pPracticeSessionID BIGINT
AS

SET NOCOUNT ON 

SELECT es.*
  FROM dbo.vEvalSession es
  JOIN dbo.SEPracticeSessionParticipant psp
    ON es.EvalSessionID=psp.EvalSessionID
 WHERE psp.PracticeSessionID=@pPracticeSessionID
