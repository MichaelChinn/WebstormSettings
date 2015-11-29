IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactsForUserPromptResponse') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactsForUserPromptResponse.'
      DROP PROCEDURE dbo.GetArtifactsForUserPromptResponse
   END
GO
PRINT '.. Creating sproc GetArtifactsForUserPromptResponse.'
GO

CREATE PROCEDURE dbo.GetArtifactsForUserPromptResponse
	 @pUserID	BIGINT
	,@pArtifactTypeID SMALLINT
	,@pIncludePrivate BIT = 1
	,@pUserPromptResponseID BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vArtifact
 WHERE SEUserID=@pUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND UserPromptResponseID=@pUserPromptResponseID
   AND ArtifactTypeID=@pArtifactTypeID
   AND (@pIncludePrivate = 1 OR IsPublic=1)


