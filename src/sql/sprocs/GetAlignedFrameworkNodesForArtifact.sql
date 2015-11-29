IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedFrameworkNodesForArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedFrameworkNodesForArtifact.'
      DROP PROCEDURE dbo.GetAlignedFrameworkNodesForArtifact
   END
GO
PRINT '.. Creating sproc GetAlignedFrameworkNodesForArtifact.'
GO

CREATE PROCEDURE dbo.GetAlignedFrameworkNodesForArtifact
	@pFrameworkID BIGINT
	,@pArtifactID BIGINT
AS

SET NOCOUNT ON 


SELECT DISTINCT fn.*
  FROM dbo.SEArtifactRubricRowAlignment arr
  JOIN dbo.SERubricRow rr ON arr.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.vFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE arr.ArtifactID=@pArtifactID
   AND fn.FrameworkID=@pFrameworkID
 


