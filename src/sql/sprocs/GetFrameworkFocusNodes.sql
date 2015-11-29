IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkFocusNodes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkFocusNodes.'
      DROP PROCEDURE dbo.GetFrameworkFocusNodes
   END
GO
PRINT '.. Creating sproc GetFrameworkFocusNodes.'
GO

CREATE PROCEDURE dbo.GetFrameworkFocusNodes
	@pEvalSessionID BIGINT
	,@pFrameworkTypeID BIGINT
	,@pEvaluationRoleTypeID SMALLINT
AS

SET NOCOUNT ON 

SELECT DISTINCT fn.*
  FROM dbo.SEEvalSessionRubricRowFocus rrf
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rrf.RubricRowID=rrfn.RubricRowID
  JOIN dbo.vFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.FrameworkTypeID=@pFrameworkTypeID
   AND rrf.EvalSessionID=@pEvalSessionID
   AND rrf.EvaluationRoleTypeID=@pEvaluationRoleTypeID
