IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkStatusForDistricts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkStatusForDistricts.'
      DROP PROCEDURE dbo.GetFrameworkStatusForDistricts
   END
GO
PRINT '.. Creating sproc GetFrameworkStatusForDistricts.'
GO

CREATE PROCEDURE dbo.GetFrameworkStatusForDistricts

AS

SET NOCOUNT ON 

CREATE TABLE #teacherframeworks (districtcode VARCHAR(5), frameworkName VARCHAR (100))
CREATE TABLE #principalFrameworks (districtcode VARCHAR(5), frameworkName VARCHAR (100))
CREATE TABLE #allDistricts (districtCode VARCHAR (5), teacher VARCHAR (100), principal VARCHAR (100))

INSERT #teacherFrameworks (districtcode, frameworkName)
SELECT districtcode, MAX(derivedfromframeworkName)
FROM dbo.seframework WHERE frameworkTYpeID IN (1, 2)
GROUP BY DistrictCode

INSERT #principalFrameworks (districtCode, frameworkName)
SELECT districtcode, MAX(derivedfromframeworkName)
FROM dbo.seframework WHERE frameworkTYpeID IN (3, 4)
GROUP BY DistrictCode

INSERT #allDistricts (districtCode)
SELECT districtcode FROM dbo.vDistrictName ORDER BY districtName

UPDATE #allDistricts
SET teacher = x.frameworkName
FROM #allDistricts ad
JOIN #teacherFrameworks x ON x.districtCode = ad.districtCode

UPDATE #allDistricts
SET principal = x.frameworkName
FROM #allDistricts ad
JOIN #principalFrameworks x ON x.districtCode = ad.districtCode

SELECT ad.districtCode, dn.DistrictName,
CASE 
	WHEN teacher LIKE 'cel%' THEN 'CEL'
	WHEN teacher LIKE 'dan%' THEN 'DAN'
	WHEN teacher LIKE 'mar%' THEN 'MAR'
	END AS TeacherFramework
	,
CASE 
	WHEN principal LIKE 'prin%' THEN 'AWSP'
	WHEN principal LIKE 'mprin%' THEN 'MAR'
	END AS principalFramework
,1 AS HasBeenUsed
 FROM #allDistricts ad
 JOIN vDistrictName dn ON dn.districtCode = ad.districtCode
ORDER BY dn.DistrictName


