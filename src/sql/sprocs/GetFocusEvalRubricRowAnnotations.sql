IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalRubricRowAnnotations') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalRubricRowAnnotations.'
      DROP PROCEDURE dbo.GetFocusEvalRubricRowAnnotations
   END
GO
PRINT '.. Creating sproc GetFocusEvalRubricRowAnnotations.'
GO

CREATE PROCEDURE dbo.GetFocusEvalRubricRowAnnotations
	 @pEvaluateeID	BIGINT
	,@pFocusNodeID		BIGINT
	,@pSGNodeId	BIGINT
	,@pIncludePrivate BIT
	,@pIncludeAssessAnnotations BIT
	,@pIncludeObsAnnotations BIT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vRubricRowAnnotation rra (NOLOCK)
 WHERE rra.FrameworkNodeID IN (@pFocusNodeID, @pSGNodeId) 
   AND rra.EvaluateeUserId=@pEvaluateeID
   AND rra.EvaluationScoreTypeID=1 -- standard
--   AND (@pIncludePrivate=1 OR (rra.ObserveIsPublic = 1))
   -- if (sgnode <> focusnode) only include SG rows from SGNode
  AND (@pSGNodeId = @pFocusNodeID OR ((rra.FrameworkNodeID=@pFocusNodeID) OR (rra.FrameworkNodeID=@pSGNodeID AND rra.IsStudentGrowthAligned=1)))
  AND ((rra.IsSelfAssess=1 AND @pIncludeAssessAnnotations=1) OR
       (rra.IsSelfAssess=0 AND @pIncludeObsAnnotations=1))
ORDER BY rra.FNSequence, rra.RRSequence

