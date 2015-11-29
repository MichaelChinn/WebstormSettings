IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictUserSchoolViewing') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictUserSchoolViewing.'
      DROP PROCEDURE dbo.GetDistrictUserSchoolViewing
   END
GO
PRINT '.. Creating sproc GetDistrictUserSchoolViewing.'
GO

CREATE PROCEDURE dbo.GetDistrictUserSchoolViewing
	@pDistrictCode	VARCHAR(20)
	,@pSchoolYear	SMALLINT
	,@pDistrictUserID BIGINT
AS

SET NOCOUNT ON 

SELECT s.SchoolName
	  ,s.schoolCode
	  ,s.districtCode
	  ,CASE WHEN (v.DistrictUserID IS NULL) THEN 0 ELSE 1 END AS IsViewable
	  ,*
  FROM dbo.vSchoolName s
  LEFT OUTER JOIN SEDistrictPRViewing v
    ON s.SchoolCode=v.SchoolCode AND v.DistrictUserID=@pDistrictUserID
 WHERE s.DistrictCode=@pDistrictCode
   AND (v.SchoolYear IS NULL OR v.SchoolYear=@pSchoolYear)
   AND (v.DistrictUserID IS NULL OR v.DistrictUserID=@pDistrictUserID)
 ORDER BY s.SchoolName

