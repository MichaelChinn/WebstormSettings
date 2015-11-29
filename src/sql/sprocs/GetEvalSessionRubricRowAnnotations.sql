IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionRubricRowAnnotations') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionRubricRowAnnotations.'
      DROP PROCEDURE dbo.GetEvalSessionRubricRowAnnotations
   END
GO
PRINT '.. Creating sproc GetEvalSessionRubricRowAnnotations.'
GO

CREATE PROCEDURE dbo.GetEvalSessionRubricRowAnnotations
	@pEvalSessionID	BIGINT
	,@pFocusOnly BIT = 0
AS

SET NOCOUNT ON 

IF (@pFocusOnly = 0)
BEGIN

SELECT *
  FROM dbo.vRubricRowAnnotation (NOLOCK)
 WHERE EvalSessionID=@pEvalSessionID
 
 END
 ELSE
 BEGIN
 
 SELECT ra.*
  FROM dbo.vRubricRowAnnotation ra (NOLOCK)
  JOIN dbo.SEEvalSessionRubricRowFocus rrf ON ra.RubricRowID=rrf.RubricRowID
 WHERE ra.EvalSessionID=@pEvalSessionID
   AND rrf.EvalSessionID=@pEvalSessionID
   
 END


