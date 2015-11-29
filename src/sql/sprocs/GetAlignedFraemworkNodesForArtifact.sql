IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedFraemworkNodesForArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedFraemworkNodesForArtifact.'
      DROP PROCEDURE dbo.GetAlignedFraemworkNodesForArtifact
   END
GO
PRINT '.. Creating sproc GetAlignedFraemworkNodesForArtifact.'
GO

CREATE PROCEDURE dbo.GetAlignedFraemworkNodesForArtifact
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
 


