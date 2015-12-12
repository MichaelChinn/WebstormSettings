if exists (select * from sysobjects 
where id = object_id('dbo.GetSchoolDistricts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolDistricts.'
      drop procedure dbo.GetSchoolDistricts
   END
GO
PRINT '.. Creating sproc GetSchoolDistricts.'
GO
CREATE PROCEDURE GetSchoolDistricts
	@pDistrictCode VARCHAR(20) = NULL

AS
SET NOCOUNT ON 

SELECT DISTINCT
	   schoolCode, districtCode, schoolName AS [Name]
  FROM dbo.vSchoolName
 WHERE @pDistrictCode IS NULL OR districtCode=@pDistrictCode
 ORDER BY schoolCode

