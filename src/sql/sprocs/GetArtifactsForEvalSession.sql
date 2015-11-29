IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactsForEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactsForEvalSession.'
      DROP PROCEDURE dbo.GetArtifactsForEvalSession
   END
GO
PRINT '.. Creating sproc GetArtifactsForEvalSession.'
GO

CREATE PROCEDURE dbo.GetArtifactsForEvalSession
	@pSessionID BIGINT
	,@pRubricRowID BIGINT = NULL
	,@pUserID BIGINT = NULL
	,@pArtifactTypeID SMALLINT = 0
AS

SET NOCOUNT ON 

IF (@pRubricRowID IS NULL)
BEGIN

SELECT * 
  FROM dbo.vArtifact (NOLOCK)
 WHERE EvalSessionID=@pSessionID
   AND (@pUserID IS NULL OR UserID=@pUserID)
   AND (@pArtifactTypeID = 36 OR ArtifactTypeID<>36) -- mobile transfer
   AND (@pArtifactTypeID = 0 OR @pArtifactTypeID=ArtifactTypeID)
 ORDER BY UserID, LastUpload
 
END
ELSE
BEGIN

SELECT a.* 
  FROM dbo.vArtifact a(NOLOCK)
  JOIN dbo.SEArtifactRubricRowAlignment arr (NOLOCK) ON a.ArtifactID=arr.ArtifactID
 WHERE a.EvalSessionID=@pSessionID
   AND arr.RubricRowID=@pRubricRowID
   AND (@pUserID IS NULL OR a.UserID=@pUserID)
   AND (@pArtifactTypeID = 36 OR a.ArtifactTypeID<>36) -- mobile transfer
   AND (@pArtifactTypeID = 0 OR @pArtifactTypeID=a.ArtifactTypeID)
 ORDER BY a.UserID, a.LastUpload
 
END

