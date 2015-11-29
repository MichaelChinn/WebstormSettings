IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UnscheduleEvalSession_PreConf') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UnscheduleEvalSession_PreConf.'
      DROP PROCEDURE dbo.UnscheduleEvalSession_PreConf
   END
GO
PRINT '.. Creating sproc UnscheduleEvalSession_PreConf.'
GO

CREATE PROCEDURE dbo.UnscheduleEvalSession_PreConf
	@pEvalSessionID BIGINT
AS

SET NOCOUNT ON 

UPDATE SEEvalSession
   SET PreConfStartTime=NULL
	  ,PreConfEndTime=NULL
	  ,PreConfLocation=''
 WHERE EvalSessionID=@pEvalSessionID

