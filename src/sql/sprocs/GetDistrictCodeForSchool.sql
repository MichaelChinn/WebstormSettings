if exists (select * from sysobjects 
where id = object_id('dbo.GetDistrictCodeForSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictCodeForSchool.'
      drop procedure dbo.GetDistrictCodeForSchool
   END
GO
PRINT '.. Creating sproc GetDistrictCodeForSchool.'
GO

CREATE PROCEDURE GetDistrictCodeForSchool
	@pSchoolCode VARCHAR(20)
AS
SET NOCOUNT ON 

if (@pSchoolCode = '0000')
	SELECT '00000'

ELSE

	SELECT DistrictCode
		from vSchoolName
		WHERE schoolCode = @pSchoolCode




