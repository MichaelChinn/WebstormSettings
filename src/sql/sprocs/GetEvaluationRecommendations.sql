if exists (select * from sysobjects 
where id = object_id('dbo.GetEvaluationRecommendations') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationRecommendations.'
      drop procedure dbo.GetEvaluationRecommendations
   END
GO
PRINT '.. Creating sproc GetEvaluationRecommendations.'
GO
CREATE PROCEDURE dbo.GetEvaluationRecommendations
	@pEvaluationID bigint

AS

SET NOCOUNT ON 

SELECT EvaluatorRecommendations FROM SEEvaluation WHERE EvaluationID=@pEvaluationID
