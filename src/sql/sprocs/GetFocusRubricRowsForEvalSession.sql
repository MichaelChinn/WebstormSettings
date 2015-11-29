IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusRubricRowsForEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusRubricRowsForEvalSession.'
      DROP PROCEDURE dbo.GetFocusRubricRowsForEvalSession
   END
GO
PRINT '.. Creating sproc GetFocusRubricRowsForEvalSession.'
GO

CREATE PROCEDURE dbo.GetFocusRubricRowsForEvalSession
	@pEvalSessionID BIGINT
	,@pFrameworkID BIGINT = NULL
	,@pEvaluationRoleTypeID SMALLINT
AS

SET NOCOUNT ON 

IF (@pFrameworkID IS NOT NULL)
BEGIN

SELECT rr.*, fn.FrameworkNodeID
  FROM dbo.SEEvalSessionRubricRowFocus rrf
  JOIN dbo.vRubricRow rr ON rrf.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE rrf.EvalSessionID=@pEvalSessionID
   AND rrf.EvaluationRoleTypeID=@pEvaluationRoleTypeID
   AND fn.FrameworkID=@pFrameworkID
   
END
ELSE
BEGIN

SELECT rr.*
  FROM dbo.SEEvalSessionRubricRowFocus rrf
  JOIN dbo.vRubricRow rr ON rrf.RubricRowID=rr.RubricRowID
 WHERE rrf.EvalSessionID=@pEvalSessionID
   AND rrf.EvaluationRoleTypeID=@pEvaluationRoleTypeID
    
END
   

