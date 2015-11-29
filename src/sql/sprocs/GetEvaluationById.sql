IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluationById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationById.'
      DROP PROCEDURE dbo.GetEvaluationById
   END
GO
PRINT '.. Creating sproc GetEvaluationById.'
GO

CREATE PROCEDURE dbo.GetEvaluationById
	@pEvaluationId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvaluation
 WHERE EvaluationId=@pEvaluationId
