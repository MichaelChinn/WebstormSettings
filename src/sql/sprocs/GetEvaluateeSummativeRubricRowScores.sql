IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeSummativeRubricRowScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeSummativeRubricRowScores.'
      DROP PROCEDURE dbo.GetEvaluateeSummativeRubricRowScores
   END
GO
PRINT '.. Creating sproc GetEvaluateeSummativeRubricRowScores.'
GO

CREATE PROCEDURE dbo.GetEvaluateeSummativeRubricRowScores
	@pEvaluateeUserID	BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT rrs.SummativeRubricRowScoreID
	  ,rrs.RubricRowID
	  ,rrs.EvaluateeID
	  ,rrs.SEUserID
	  ,rrs.PerformanceLevelID
	  ,rr.IsStudentGrowthAligned
  FROM dbo.SESummativeRubricRowScore rrs
  JOIN dbo.SERubricRow rr ON rrs.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE rrs.EvaluateeID=@pEvaluateeUserID
   AND f.SchoolYear=@pSchoolYear
   AND f.DistrictCode=@pDistrictCode



