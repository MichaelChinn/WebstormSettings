IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactById.'
      DROP PROCEDURE dbo.GetArtifactById
   END
GO
PRINT '.. Creating sproc GetArtifactById.'
GO

CREATE PROCEDURE dbo.GetArtifactById
	@pArtifactId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vArtifact
 WHERE ArtifactID=@pArtifactID

