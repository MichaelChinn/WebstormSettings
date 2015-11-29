if exists (select * from sysobjects 
where id = object_id('dbo.GetSchoolYearDistrictConfig') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolYearDistrictConfig.'
      drop procedure dbo.GetSchoolYearDistrictConfig
   END
GO
PRINT '.. Creating sproc GetSchoolYearDistrictConfig.'
GO
CREATE PROCEDURE GetSchoolYearDistrictConfig
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear SMALLINT = NULL
	,@pVisibleOnly BIT = 0

AS
SET NOCOUNT ON 

 SELECT *
   FROM vSchoolYearDistrictConfig
  WHERE DistrictCode=@pDistrictCode
    AND (@pSchoolYear IS NULL OR SchoolYear=@pSchoolYear)
    AND (@pVisibleOnly=0 OR SchoolYearIsVisible=1)
  ORDER BY SchoolYear


