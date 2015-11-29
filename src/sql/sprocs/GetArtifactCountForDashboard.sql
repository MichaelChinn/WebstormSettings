IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactCountForDashboard') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactCountForDashboard.'
      DROP PROCEDURE dbo.GetArtifactCountForDashboard
   END
GO
PRINT '.. Creating sproc GetArtifactCountForDashboard.'
GO

CREATE PROCEDURE dbo.GetArtifactCountForDashboard
	 @pUserID	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pViewerType SMALLINT
AS

SET NOCOUNT ON 
 
DECLARE @ArtifactTypeID_EVALUATOR_UPLOAD SMALLINT
SELECT @ArtifactTypeID_EVALUATOR_UPLOAD = 35

-- viewertype 1: evaluatee, 2: assigned-evaluator, 3: other viewer

SELECT COUNT(a.ArtifactID) 
  FROM dbo.SEArtifact a (NOLOCK)
  LEFT OUTER JOIN dbo.SEEvalSession s (NOLOCK) on a.EvalSessionID=s.EvalSessionID
       -- evaluatee can see all, except evaluator artifacts must be public (set by evaluator)
       -- assigned evaluators can see all public ones from evaluatee, plus evaluator artifacts
       -- other views can just see public ones
 WHERE ((@pViewerType = 1 AND ((ArtifactTypeID <> @ArtifactTypeID_EVALUATOR_UPLOAD) OR (a.IsPublic=1))) OR
        (@pViewerType = 2 AND ((ArtifactTypeID = @ArtifactTypeID_EVALUATOR_UPLOAD) OR (a.IsPublic=1))) OR
        (@pViewerType = 3 AND a.IsPublic=1))
   AND a.ArtifactTypeID<>36 -- mobile transfer
   AND a.SchoolYear=@pSchoolYear
   AND a.DistrictCode=@pDistrictCode
   AND ((a.EvalSessionID IS NULL AND a.UserID=@pUserID) OR
        (a.EvalSessionID IS NOT NULL AND s.EvaluateeUserID=a.UserID AND s.EvaluateeUserID=@pUserID) OR
        (a.EvalSessionID IS NOT NULL AND s.EvaluatorUserID=a.UserID AND s.EvaluateeUserID=@pUserID))

