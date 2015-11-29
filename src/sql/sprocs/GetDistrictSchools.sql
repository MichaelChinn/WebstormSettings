if exists (select * from sysobjects 
where id = object_id('dbo.GetDistrictSchools') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictSchools.'
      drop procedure dbo.GetDistrictSchools
   END
GO
PRINT '.. Creating sproc GetDistrictSchools.'
GO
CREATE PROCEDURE GetDistrictSchools
	@pDistrictCode varchar(50)
AS
SET NOCOUNT ON 

SELECT DISTINCT
	   *
  FROM dbo.vSchoolName
 WHERE @pDistrictCode = DistrictCode
 ORDER BY SchoolName




