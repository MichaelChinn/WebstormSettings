IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolParticipantSessionCountForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolParticipantSessionCountForUser.'
      DROP PROCEDURE dbo.GetTrainingProtocolParticipantSessionCountForUser
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolParticipantSessionCountForUser.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolParticipantSessionCountForUser
	 @pProtocolID BIGINT,
	 @pUserID BIGINT,
	 @pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT COUNT(psp.UserID)
  FROM dbo.SEPracticeSessionParticipant psp
  JOIN dbo.SEPracticeSession p ON psp.PracticeSessionID=p.PracticeSessionID
 WHERE p.TrainingProtocolID=@pProtocolID
   AND psp.UserID=@pUserID
   AND p.SchoolYear=@pSchoolYear
