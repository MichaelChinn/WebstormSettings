if exists (select * from sysobjects 
where id = object_id('dbo.GetSessionUserPromptResponse') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionUserPromptResponse.'
      drop procedure dbo.GetSessionUserPromptResponse
   END
GO
PRINT '.. Creating sproc GetSessionUserPromptResponse.'
GO
CREATE PROCEDURE GetSessionUserPromptResponse
	 @pUserPromptID BIGINT,
	 @pEvalSessionID BIGINT,
	 @pEvaluateeID BIGINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.UserPromptID=@pUserPromptID
   AND r.EvaluateeID=@pEvaluateeID
   AND r.EvalSessionID=@pEvalSessionID

   
