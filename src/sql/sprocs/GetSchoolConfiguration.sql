IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSchoolConfiguration') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolConfiguration.'
      DROP PROCEDURE dbo.GetSchoolConfiguration
   END
GO
PRINT '.. Creating sproc GetSchoolConfiguration.'
GO

CREATE PROCEDURE dbo.GetSchoolConfiguration
	@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT

AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vSchoolConfiguration
 WHERE DistrictCode=@pDistrictCode
   AND SchoolCode=@pSchoolCode
   AND SchoolYear=@pSchoolYear






