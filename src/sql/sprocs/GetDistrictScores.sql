IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictScores.'
      DROP PROCEDURE dbo.GetDistrictScores
   END
GO
PRINT '.. Creating sproc GetDistrictScores.'
GO

CREATE PROCEDURE dbo.GetDistrictScores
	 @pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT ds.districtSchoolName
	  ,ds.districtCode
  FROM dbo.SEEvaluation e
  JOIN dbo.SEDistrictSchool ds ON e.DistrictCode=ds.DistrictCode
 WHERE e.DistrictCode=@pDistrictCode
   AND e.SchoolYear=@pSchoolYear
   AND ds.IsSchool=0
 --  AND e.PerformanceLevelID IS NOT NULL

SELECT ds.districtSchoolName
	  ,ds.districtCode
	  ,f.DerivedFromFrameworkName
	  ,fn.ShortName
	  ,fns.PerformanceLevelID
  FROM dbo.SESummativeFrameworkNodeScore fns
  JOIN dbo.SEFrameworkNode fn ON fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEDistrictSchool ds ON f.DistrictCode=ds.DistrictCode
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND ds.IsSchool=0
  -- AND fns.PerformanceLevelID IS NOT NULL
 ORDER BY f.DerivedFromFrameworkName, fn.ShortName
 
 SELECT ds.districtSchoolName
	  ,ds.districtCode
	  ,f.DerivedFromFrameworkName
	  ,fn.ShortName
	  ,rrs.PerformanceLevelID
	  ,rr.IsStudentGrowthAligned
  FROM dbo.SESummativeRubricRowScore rrs
  JOIN dbo.SERubricRow rr ON rrs.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  JOIN dbo.SEDistrictSchool ds ON f.DistrictCode=ds.DistrictCode
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND ds.IsSchool=0
 --  AND rrs.PerformanceLevelID IS NOT NULL
 ORDER BY f.DerivedFromFrameworkName, fn.ShortName


