if exists (select * from sysobjects 
where id = object_id('dbo.SetEvaluationRecommendations') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvaluationRecommendations.'
      drop procedure dbo.SetEvaluationRecommendations
   END
GO
PRINT '.. Creating sproc SetEvaluationRecommendations.'
GO
CREATE PROCEDURE dbo.SetEvaluationRecommendations
	@pEvaluationID BIGINT
   ,@pRecommendations VARCHAR(MAX)

AS

SET NOCOUNT ON 

UPDATE SEEvaluation SET EvaluatorRecommendations=@pRecommendations WHERE EvaluationID=@pEvaluationID
