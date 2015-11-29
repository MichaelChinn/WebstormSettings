IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionParticipantEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionParticipantEvalSession.'
      DROP PROCEDURE dbo.GetPracticeSessionParticipantEvalSession
   END
GO
PRINT '.. Creating sproc GetPracticeSessionParticipantEvalSession.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionParticipantEvalSession
	 @pPracticeSessionID BIGINT,
	 @pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT es.*
  FROM dbo.vEvalSession es
  JOIN dbo.SEPracticeSessionParticipant psp
    ON es.EvalSessionID=psp.EvalSessionID
 WHERE psp.PracticeSessionID=@pPracticeSessionID
   AND psp.UserID=@pUserID
