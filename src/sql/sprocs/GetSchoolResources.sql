IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSchoolResources') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolResources.'
      DROP PROCEDURE dbo.GetSchoolResources
   END
GO
PRINT '.. Creating sproc GetSchoolResources.'
GO

CREATE PROCEDURE dbo.GetSchoolResources
	@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vResource 
 WHERE DistrictCode=@pDistrictCode
   AND SchoolCode=@pSchoolCode
   AND SchoolYear=@pSchoolYear



