IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactsForArtifactReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactsForArtifactReport.'
      DROP PROCEDURE dbo.GetArtifactsForArtifactReport
   END
GO
PRINT '.. Creating sproc GetArtifactsForArtifactReport.'
GO

CREATE PROCEDURE dbo.GetArtifactsForArtifactReport
	 @pUserID	BIGINT
	,@pIncludePrivate BIT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT a.*
  FROM dbo.vArtifact a
  LEFT OUTER JOIN dbo.SEEvalSession s on a.EvalSessionID=s.EvalSessionID
 WHERE (@pIncludePrivate = 1 OR IsPublic=1)
   AND a.ArtifactTypeID<>36 -- mobile transfer
   AND a.SchoolYear=@pSchoolYear
   AND a.DistrictCode=@pDistrictCode
   AND ((a.EvalSessionID IS NULL AND a.UserID=@pUserID) OR
        (a.EvalSessionID IS NOT NULL AND s.EvaluateeUserID=a.UserID AND s.EvaluateeUserID=@pUserID) OR
        (a.EvalSessionID IS NOT NULL AND s.EvaluatorUserID=a.UserID AND s.EvaluateeUserID=@pUserID))
 ORDER BY a.InitialUpload ASC



