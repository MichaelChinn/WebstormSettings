IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPracticeSessionByRandomNumber') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPracticeSessionByRandomNumber.'
      DROP PROCEDURE dbo.GetPracticeSessionByRandomNumber
   END
GO
PRINT '.. Creating sproc GetPracticeSessionByRandomNumber.'
GO

CREATE PROCEDURE dbo.GetPracticeSessionByRandomNumber
	@pSessionId	BIGINT
	,@pRandomDigits SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vPracticeSession
 WHERE PracticeSessionID=@pSessionID AND RandomDigits = @pRandomDigits

