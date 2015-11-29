IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactsForUserForSummaryScreen') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactsForUserForSummaryScreen.'
      DROP PROCEDURE dbo.GetArtifactsForUserForSummaryScreen
   END
GO
PRINT '.. Creating sproc GetArtifactsForUserForSummaryScreen.'
GO

CREATE PROCEDURE dbo.GetArtifactsForUserForSummaryScreen
	@pUserID	BIGINT
	,@pAlignmentNodeId BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

CREATE TABLE #Artifact(ArtifactID BIGINT, SessionTitle VARCHAR(200))
INSERT INTO #Artifact(ArtifactID,SessionTitle)
SELECT ArtifactID, ''
  FROM dbo.SEArtifact
 WHERE UserID=@pUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvalSessionID IS NULL
   AND IsPublic=1

-- Add the ones that are from an evaluator in an eval session
INSERT INTO #Artifact(ArtifactID, SessionTitle)
SELECT ArtifactID
      ,s.Title
  FROM dbo.SEArtifact a
  JOIN dbo.SEEvalSession s ON a.EvalSessionID=s.EvalSessionID
 WHERE s.EvaluateeUserID=@pUserID
   AND s.SchoolYear=@pSchoolYear
   AND s.DistrictCode=@pDistrictCode

SELECT DISTINCT a.* , a2.SessionTitle
  FROM dbo.vArtifact a
  JOIN dbo.SEArtifactRubricRowAlignment rra
	ON a.ArtifactID=rra.ArtifactID
  JOIN dbo.SERubricRowFrameworkNode rrfn
    ON rra.RubricRowID=rrfn.RubricRowID
  JOIN dbo.#Artifact a2
	ON a.ArtifactID=a2.ArtifactID
 WHERE rrfn.FrameworkNodeID=@pAlignmentNodeId


