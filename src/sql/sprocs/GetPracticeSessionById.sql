IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionById.'
      DROP PROCEDURE dbo.GetPracticeSessionById
   END
GO
PRINT '.. Creating sproc GetPracticeSessionById.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionById
	@pSessionId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vPracticeSession
 WHERE PracticeSessionID=@pSessionID

