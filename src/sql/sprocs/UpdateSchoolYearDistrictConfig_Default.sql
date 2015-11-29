if exists (select * from sysobjects 
where id = object_id('dbo.UpdateSchoolYearDistrictConfig_Default') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateSchoolYearDistrictConfig_Default.'
      drop procedure dbo.UpdateSchoolYearDistrictConfig_Default
   END
GO
PRINT '.. Creating sproc UpdateSchoolYearDistrictConfig_Default.'
GO
CREATE PROCEDURE UpdateSchoolYearDistrictConfig_Default
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pSchoolYearIsDefault BIT

AS
SET NOCOUNT ON 

UPDATE dbo.SESchoolYearDistrictConfig
   SET SchoolYearIsDefault=@pSchoolYearIsDefault
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   
IF (@pSchoolYearIsDefault=1)
BEGIN

UPDATE dbo.SESchoolYearDistrictConfig
   SET SchoolYearIsDefault=0
 WHERE SchoolYear<>@pSchoolYear
   AND DistrictCode=@pDistrictCode
   
END
   


