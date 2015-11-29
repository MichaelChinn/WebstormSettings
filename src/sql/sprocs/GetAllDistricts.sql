if exists (select * from sysobjects 
where id = object_id('dbo.GetAllDistricts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAllDistricts.'
      drop procedure dbo.GetAllDistricts
   END
GO
PRINT '.. Creating sproc GetAllDistricts.'
GO
CREATE PROCEDURE GetAllDistricts
AS
SET NOCOUNT ON 

SELECT DISTINCT
	   DistrictName
      ,DistrictCode
  FROM dbo.vDistrictName
 WHERE DistrictCOde is not null
 ORDER BY DistrictName




