if exists (select * from sysobjects 
where id = object_id('dbo.GetSessionUserPromptResponses') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionUserPromptResponses.'
      drop procedure dbo.GetSessionUserPromptResponses
   END
GO
PRINT '.. Creating sproc GetSessionUserPromptResponses.'
GO
CREATE PROCEDURE GetSessionUserPromptResponses
	 @pPromptTypeID SMALLINT,
	 @pEvalSessionID BIGINT,
	 @pUserID BIGINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.PromptTypeID=@pPromptTypeID
   AND r.EvaluateeID=@pUserID
   AND r.EvalSessionID=@pEvalSessionID
 ORDER BY r.Sequence ASC

   
