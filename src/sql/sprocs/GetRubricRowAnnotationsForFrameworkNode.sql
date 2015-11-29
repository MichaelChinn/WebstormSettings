IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowAnnotationsForFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowAnnotationsForFrameworkNode.'
      DROP PROCEDURE dbo.GetRubricRowAnnotationsForFrameworkNode
   END
GO
PRINT '.. Creating sproc GetRubricRowAnnotationsForFrameworkNode.'
GO

CREATE PROCEDURE dbo.GetRubricRowAnnotationsForFrameworkNode
	@pFrameworkNodeID	BIGINT
	,@pEvaluateeID	BIGINT
	,@pIncludePrivate BIT
	,@pIncludeAssessAnnotations BIT
	,@pIncludeObsAnnotations BIT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vRubricRowAnnotation rra (NOLOCK)
 WHERE rra.FrameworkNodeID =@pFrameworkNodeID 
   AND rra.EvaluateeUserId=@pEvaluateeID
   AND rra.EvaluationScoreTypeID=1 -- standard
   AND (@pIncludePrivate=1 OR (rra.ObserveIsPublic = 1))
  AND ((rra.IsSelfAssess=1 AND @pIncludeAssessAnnotations=1) OR
       (rra.IsSelfAssess=0 AND @pIncludeObsAnnotations=1))
 ORDER BY rra.RRSequence

