IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.UnscheduleEvalSession_Observe') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UnscheduleEvalSession_Observe.'
      DROP PROCEDURE dbo.UnscheduleEvalSession_Observe
   END
GO
PRINT '.. Creating sproc UnscheduleEvalSession_Observe.'
GO

CREATE PROCEDURE dbo.UnscheduleEvalSession_Observe
	@pEvalSessionID BIGINT
AS

SET NOCOUNT ON 

UPDATE SEEvalSession
   SET ObserveStartTime=NULL
	  ,ObserveEndTime=NULL
	  ,ObserveLocation=''
 WHERE EvalSessionID=@pEvalSessionID

