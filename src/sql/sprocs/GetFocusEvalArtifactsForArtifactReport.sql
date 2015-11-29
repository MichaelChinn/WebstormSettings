IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalArtifactsForArtifactReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalArtifactsForArtifactReport.'
      DROP PROCEDURE dbo.GetFocusEvalArtifactsForArtifactReport
   END
GO
PRINT '.. Creating sproc GetFocusEvalArtifactsForArtifactReport.'
GO

CREATE PROCEDURE dbo.GetFocusEvalArtifactsForArtifactReport
	@pUserID	BIGINT
	,@pFocusNodeID		BIGINT
	,@pSGNodeId	BIGINT
AS

SET NOCOUNT ON 

SELECT DISTINCT a.*
  FROM dbo.vArtifact a
  JOIN dbo.SEArtifactRubricRowAlignment rra
	ON a.ArtifactID=rra.ArtifactID
  JOIN dbo.SERubricRowFrameworkNode rrfn
    ON rra.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRow rr
    ON rrfn.RubricRowID=rr.RubricRowID
 WHERE rrfn.FrameworkNodeID IN (@pFocusNodeID, @pSGNodeId)
   -- if (sgnode <> focusnode) only include SG rows from SGNode
   AND (@pSGNodeId = @pFocusNodeID OR ((fn.FrameworkNodeID=@pFocusNodeID) OR (fn.FrameworkNodeID=@pSGNodeID AND rr.IsStudentGrowthAligned=1)))
   AND a.SEUserID=@pUserID
 ORDER BY a.ItemName ASC




