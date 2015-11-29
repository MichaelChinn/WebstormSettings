IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalArtifactsForSummaryScreen') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalArtifactsForSummaryScreen.'
      DROP PROCEDURE dbo.GetFocusEvalArtifactsForSummaryScreen
   END
GO
PRINT '.. Creating sproc GetFocusEvalArtifactsForSummaryScreen.'
GO

CREATE PROCEDURE dbo.GetFocusEvalArtifactsForSummaryScreen
	@pUserID	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(200)
	,@pFocusNodeID		BIGINT
	,@pSGNodeId	BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Artifact(ArtifactID BIGINT, SessionTitle VARCHAR(200))
INSERT INTO #Artifact(ArtifactID, SessionTitle)
SELECT ArtifactID, ''
  FROM dbo.SEArtifact
 WHERE UserID=@pUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvalSessionID IS NULL

-- Add the ones that are from an evaluator in an eval session
INSERT INTO #Artifact(ArtifactID, SessionTitle)
SELECT ArtifactID
      ,s.Title
  FROM dbo.SEArtifact a
  JOIN dbo.SEEvalSession s ON a.EvalSessionID=s.EvalSessionID
 WHERE s.EvaluateeUserID=@pUserID
   AND s.SchoolYear=@pSchoolYear
   AND s.DistrictCode=@pDistrictCode

SELECT DISTINCT a.*, a2.SessionTitle, fn.Sequence
  FROM dbo.vArtifact a
  JOIN dbo.#Artifact a2
    ON a.ArtifactID=a2.ArtifactID
  JOIN dbo.SEArtifactRubricRowAlignment rra
	ON a.ArtifactID=rra.ArtifactID
  JOIN dbo.SERubricRowFrameworkNode rrfn
    ON rra.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRow rr
    ON rrfn.RubricRowID=rr.RubricRowID
 WHERE rrfn.FrameworkNodeID IN (@pFocusNodeID, @pSGNodeId)
   -- if (sgnode <> focusnode) only include SG rows from SGNode
   AND (@pSGNodeId = @pFocusNodeID OR ((fn.FrameworkNodeID=@pFocusNodeID) OR (fn.FrameworkNodeID=@pSGNodeID AND rr.IsStudentGrowthAligned=1)))
 ORDER BY fn.Sequence




