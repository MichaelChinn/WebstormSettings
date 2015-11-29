IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictResources') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictResources.'
      DROP PROCEDURE dbo.GetDistrictResources
   END
GO
PRINT '.. Creating sproc GetDistrictResources.'
GO

CREATE PROCEDURE dbo.GetDistrictResources
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vResource 
 WHERE DistrictCode=@pDistrictCode
   AND SchoolCode=''
   AND SchoolYear=@pSchoolYear



