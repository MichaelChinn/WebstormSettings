if exists (select * from sysobjects 
where id = object_id('dbo.UpdateSchoolYearDistrictConfig_Visible') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateSchoolYearDistrictConfig_Visible.'
      drop procedure dbo.UpdateSchoolYearDistrictConfig_Visible
   END
GO
PRINT '.. Creating sproc UpdateSchoolYearDistrictConfig_Visible.'
GO
CREATE PROCEDURE UpdateSchoolYearDistrictConfig_Visible
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pSchoolYearIsVisible BIT

AS
SET NOCOUNT ON 

UPDATE dbo.SESchoolYearDistrictConfig
   SET SchoolYearIsVisible=@pSchoolYearIsVisible
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   
   


