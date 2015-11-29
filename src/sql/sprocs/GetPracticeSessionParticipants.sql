IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionParticipants') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionParticipants.'
      DROP PROCEDURE dbo.GetPracticeSessionParticipants
   END
GO
PRINT '.. Creating sproc GetPracticeSessionParticipants.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionParticipants
	 @pPracticeSessionID BIGINT
AS

SET NOCOUNT ON 

SELECT u.*
  FROM dbo.vSEUser u
  JOIN dbo.SEPracticeSessionParticipant psp
    ON u.SEUserID=psp.UserID
 WHERE psp.PracticeSessionID=@pPracticeSessionID
