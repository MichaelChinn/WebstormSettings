IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkByDistrictCode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkByDistrictCode.'
      DROP PROCEDURE dbo.GetFrameworkByDistrictCode
   END
GO
PRINT '.. Creating sproc GetFrameworkByDistrictCode.'
GO

CREATE PROCEDURE dbo.GetFrameworkByDistrictCode
	@pDistrictCode VARCHAR(10)
   ,@pFrameworkTypeID SMALLINT
   ,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vFramework
 WHERE DistrictCode=@pDistrictCode
   AND FrameworkTypeID=@pFrameworkTypeID
   AND SchoolYear=@pSchoolYear

