if exists (select * from sysobjects 
where id = object_id('dbo.SetEvaluationReflections') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvaluationReflections.'
      drop procedure dbo.SetEvaluationReflections
   END
GO
PRINT '.. Creating sproc SetEvaluationReflections.'
GO
CREATE PROCEDURE dbo.SetEvaluationReflections
	@pEvaluationID BIGINT
   ,@pReflections VARCHAR(MAX)

AS

SET NOCOUNT ON 

UPDATE SEEvaluation SET EvaluateeReflections=@pReflections WHERE EvaluationID=@pEvaluationID
