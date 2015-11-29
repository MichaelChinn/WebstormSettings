IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionById.'
      DROP PROCEDURE dbo.GetEvalSessionById
   END
GO
PRINT '.. Creating sproc GetEvalSessionById.'
GO

CREATE PROCEDURE dbo.GetEvalSessionById
	@pSessionId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession
 WHERE EvalSessionID=@pSessionID

