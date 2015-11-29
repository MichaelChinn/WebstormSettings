IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalArtifactsForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalArtifactsForUser.'
      DROP PROCEDURE dbo.GetFocusEvalArtifactsForUser
   END
GO
PRINT '.. Creating sproc GetFocusEvalArtifactsForUser.'
GO

CREATE PROCEDURE dbo.GetFocusEvalArtifactsForUser
	@pUserID	BIGINT
	,@pFocusNodeID		BIGINT
	,@pSGNodeId	BIGINT
AS

SET NOCOUNT ON 

SELECT DISTINCT a.*, fn.Sequence
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
 ORDER BY fn.Sequence




