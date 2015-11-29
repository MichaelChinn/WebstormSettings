IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworksForSchoolYear') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworksForSchoolYear.'
      DROP PROCEDURE dbo.GetFrameworksForSchoolYear
   END
GO
PRINT '.. Creating sproc GetFrameworksForSchoolYear.'
GO

CREATE PROCEDURE dbo.GetFrameworksForSchoolYear
	@pSchoolYear SMALLINT
   ,@pFrameworkTypeID SMALLINT

AS

SET NOCOUNT ON 
   
CREATE TABLE #Frameworks(DistrictCode VARCHAR(20), FrameworkID BIGINT)
INSERT INTO #Frameworks(DistrictCode)
SELECT DISTINCT ds.DistrictCode
  FROM dbo.SEDistrictSchool ds
 WHERE ds.IsSchool=0

UPDATE #Frameworks
   SET FrameworkID=f.FrameworkID
  FROM dbo.SEFramework f
 WHERE f.DistrictCode=#Frameworks.DistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.FrameworkTypeID=@pFrameworkTypeID
  
SELECT ds.DistrictSchoolName
      ,ds.DistrictCode
      ,f2.Name
	  ,f2.DerivedFromFrameworkName
	  ,f2.SchoolYear
	  ,f2.FrameworkID
	  ,ISNULL(f2.FrameworkTypeID, 0) AS FrameworkTypeID
  FROM dbo.#Frameworks f 
  JOIN  dbo.SEDistrictSchool ds ON ds.DistrictCode=f.DistrictCode
  LEFT OUTER JOIN dbo.SEFramework f2 ON f.FrameworkID=f2.FrameworkID
  ORDER BY ds.DistrictSchoolName





