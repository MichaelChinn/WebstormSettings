IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionPullQuotesForFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionPullQuotesForFrameworkNode.'
      DROP PROCEDURE dbo.GetEvalSessionPullQuotesForFrameworkNode
   END
GO
PRINT '.. Creating sproc GetEvalSessionPullQuotesForFrameworkNode.'
GO

CREATE PROCEDURE dbo.GetEvalSessionPullQuotesForFrameworkNode
	@pSessionID	BIGINT
	,@pFrameworkNodeID BIGINT
	,@pPrioritized BIT = 0
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vPullQuote
 WHERE EvalSessionID=@pSessionID
   AND FrameworkNodeID=@pFrameworkNodeID
   AND (@pPrioritized = 0 OR IsImportant=1)

