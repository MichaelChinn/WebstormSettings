IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeSummativeFrameworkNodeScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeSummativeFrameworkNodeScores.'
      DROP PROCEDURE dbo.GetEvaluateeSummativeFrameworkNodeScores
   END
GO
PRINT '.. Creating sproc GetEvaluateeSummativeFrameworkNodeScores.'
GO

CREATE PROCEDURE dbo.GetEvaluateeSummativeFrameworkNodeScores
	@pEvaluateeUserID	BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT fns.SummativeFrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.EvaluateeID
	  ,fns.SEUserID
	  ,fns.PerformanceLevelID
	  ,fns.StatementOfPerformance
  FROM dbo.SESummativeFrameworkNodeScore fns
  JOIN dbo.SEFrameworkNode fn ON fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEEvaluation e ON e.EvaluateeID=fns.EvaluateeID AND e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear
 WHERE fns.EvaluateeID=@pEvaluateeUserID
   AND f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND (@pSchoolYear=2013 OR e.EvaluateePlanTypeID=1 OR e.EvaluateePlanTypeID IS NULL OR e.FocusedFrameworkNodeID=fn.FrameworkNodeID)


