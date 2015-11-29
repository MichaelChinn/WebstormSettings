IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedRubricRowsForArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedRubricRowsForArtifact.'
      DROP PROCEDURE dbo.GetAlignedRubricRowsForArtifact
   END
GO
PRINT '.. Creating sproc GetAlignedRubricRowsForArtifact.'
GO

CREATE PROCEDURE dbo.GetAlignedRubricRowsForArtifact
	@pFrameworkID BIGINT
	,@pArtifactID BIGINT
AS

SET NOCOUNT ON 

SELECT rr.*, fn.FrameworkNodeID
  FROM dbo.SEArtifactRubricRowAlignment arr
  JOIN dbo.vRubricRow rr ON arr.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE arr.ArtifactID=@pArtifactID
   AND fn.FrameworkID=@pFrameworkID



