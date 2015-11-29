IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluationWorkflowHistory') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationWorkflowHistory.'
      DROP PROCEDURE dbo.GetEvaluationWorkflowHistory
   END
GO
PRINT '.. Creating sproc GetEvaluationWorkflowHistory.'
GO

CREATE PROCEDURE dbo.GetEvaluationWorkflowHistory
	@pEvaluationId	BIGINT
AS

SET NOCOUNT ON 


SELECT e.* 
  FROM dbo.vEvaluationWfHistory e
 WHERE e.EvaluationID=@pEvaluationID
 ORDER BY e.TIMESTAMP DESC

