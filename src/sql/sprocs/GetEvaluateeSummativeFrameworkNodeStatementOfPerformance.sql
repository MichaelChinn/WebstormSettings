IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeSummativeFrameworkNodeStatementOfPerformance') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeSummativeFrameworkNodeStatementOfPerformance.'
      DROP PROCEDURE dbo.GetEvaluateeSummativeFrameworkNodeStatementOfPerformance
   END
GO
PRINT '.. Creating sproc GetEvaluateeSummativeFrameworkNodeStatementOfPerformance.'
GO

CREATE PROCEDURE dbo.GetEvaluateeSummativeFrameworkNodeStatementOfPerformance
	@pEvaluateeUserID	BIGINT
	,@pFrameworkNodeID  BIGINT
AS

SET NOCOUNT ON 

SELECT fns.SummativeFrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.EvaluateeID
	  ,fns.SEUserID
	  ,fns.PerformanceLevelID
  FROM dbo.SESummativeFrameworkNodeScore fns
  JOIN dbo.SEFrameworkNode fn ON fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEEvaluation e ON e.EvaluateeID=fns.EvaluateeID AND e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear
 WHERE fns.EvaluateeID=@pEvaluateeUserID
   AND f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND (e.EvaluateePlanTypeID=1 OR e.FocusedFrameworkNodeID=fn.FrameworkNodeID)


