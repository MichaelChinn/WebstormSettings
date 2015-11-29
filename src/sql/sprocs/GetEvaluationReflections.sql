if exists (select * from sysobjects 
where id = object_id('dbo.GetEvaluationReflections') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationReflections.'
      drop procedure dbo.GetEvaluationReflections
   END
GO
PRINT '.. Creating sproc GetEvaluationReflections.'
GO
CREATE PROCEDURE dbo.GetEvaluationReflections
	@pEvaluationID bigint

AS

SET NOCOUNT ON 

SELECT EvaluateeReflections FROM SEEvaluation WHERE EvaluationID=@pEvaluationID
