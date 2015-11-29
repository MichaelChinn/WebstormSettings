IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionsForParticipant') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionsForParticipant.'
      DROP PROCEDURE dbo.GetPracticeSessionsForParticipant
   END
GO
PRINT '.. Creating sproc GetPracticeSessionsForParticipant.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionsForParticipant
	 @pUserId	BIGINT
	,@pSchoolYear SMALLINT
	,@pType SMALLINT = 0
AS

SET NOCOUNT ON 

SELECT ps.*
  FROM dbo.vPracticeSession ps
  JOIN dbo.SEPracticeSessionParticipant psp ON ps.PracticeSessionID=psp.PracticeSessionID
 WHERE psp.UserID=@pUserID
   AND ps.SchoolYear=@pSchoolYear
   AND (@pType = 0 OR (@pType=ps.PracticeSessionTypeID))
 ORDER BY ps.CreationDateTime DESC


