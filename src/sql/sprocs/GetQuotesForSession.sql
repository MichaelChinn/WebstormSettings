IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetQuotesForSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetQuotesForSession.'
      DROP PROCEDURE dbo.GetQuotesForSession
   END
GO
PRINT '.. Creating sproc GetQuotesForSession.'
GO

CREATE PROCEDURE dbo.GetQuotesForSession
	@pSessionID BIGINT
	,@pFrameworkNodeID BIGINT = NULL
   
AS

SET NOCOUNT ON 

IF (@pFrameworkNodeID IS NULL)
BEGIN
SELECT * 
  FROM dbo.vPullQuote
 WHERE EvalSessionId = @pSessionID
END
ELSE
BEGIN
SELECT * 
  FROM dbo.vPullQuote
 WHERE EvalSessionId = @pSessionID
   AND FrameworkNodeID=@pFrameworkNodeID
END
  




