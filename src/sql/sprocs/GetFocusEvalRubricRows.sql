IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalRubricRows') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalRubricRows.'
      DROP PROCEDURE dbo.GetFocusEvalRubricRows
   END
GO
PRINT '.. Creating sproc GetFocusEvalRubricRows.'
GO

CREATE PROCEDURE dbo.GetFocusEvalRubricRows
	 @pEvaluateeID		BIGINT
	,@pFocusNodeID		BIGINT
	,@pSGNodeID	BIGINT
AS

SET NOCOUNT ON 

SELECT rr.RubricRowID
	  ,rr.Title
	  ,rr.Description
	  ,rr.IsStudentGrowthAligned
	  ,rr.PL4Descriptor
	  ,rr.PL3Descriptor
	  ,rr.PL2Descriptor
	  ,rr.PL1Descriptor
	  ,rr.IsStateAligned
	  ,rr.ShortName
 FROM dbo.SERubricRow rr
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
WHERE rrfn.FrameworkNodeID IN (@pFocusNodeID, @pSGNodeId)
   -- if (sgnode <> focusnode) only include SG rows from SGNode
  AND (@pSGNodeId = @pFocusNodeID OR ((fn.FrameworkNodeID=@pFocusNodeID) OR (fn.FrameworkNodeID=@pSGNodeID AND rr.IsStudentGrowthAligned=1)))
 ORDER BY fn.Sequence, rrfn.Sequence


