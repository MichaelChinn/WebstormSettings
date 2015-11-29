IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UnscheduleEvalSession_PostConf') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UnscheduleEvalSession_PostConf.'
      DROP PROCEDURE dbo.UnscheduleEvalSession_PostConf
   END
GO
PRINT '.. Creating sproc UnscheduleEvalSession_PostConf.'
GO

CREATE PROCEDURE dbo.UnscheduleEvalSession_PostConf
	@pEvalSessionID BIGINT
AS

SET NOCOUNT ON 

UPDATE SEEvalSession
   SET PostConfStartTime=NULL
	  ,PostConfEndTime=NULL
	  ,PostConfLocation=''
 WHERE EvalSessionID=@pEvalSessionID

