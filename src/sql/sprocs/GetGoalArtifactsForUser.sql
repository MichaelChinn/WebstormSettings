IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetGoalArtifactsForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalArtifactsForUser.'
      DROP PROCEDURE dbo.GetGoalArtifactsForUser
   END
GO
PRINT '.. Creating sproc GetGoalArtifactsForUser.'
GO

CREATE PROCEDURE dbo.GetGoalArtifactsForUser
	@pSEUserID	BIGINT
	,@pIncludePrivate BIT = 1
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT a.* 
  FROM dbo.vArtifact a
 WHERE a.SchoolYear=@pSchoolYear
   AND a.DistrictCode=@pDistrictCode
   AND a.SEUserID=@pSEUserID
   AND a.ArtifactTypeID IN (5, 6)
   AND (@pIncludePrivate = 1 OR IsPublic=1)
    

   

