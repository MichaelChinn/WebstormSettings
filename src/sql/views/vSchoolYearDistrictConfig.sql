IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vSchoolYearDistrictConfig')
   BEGIN
      PRINT '.. Dropping View vSchoolYearDistrictConfig.'
	  DROP VIEW dbo.vSchoolYearDistrictConfig
   END
GO
PRINT '.. Creating View vSchoolYearDistrictConfig.'
GO
CREATE VIEW dbo.vSchoolYearDistrictConfig
AS 

SELECT SchoolYearDistrictConfigID
	  ,SchoolYear
	  ,DistrictCode
	  ,SchoolYearIsVisible
	  ,SchoolYearIsDefault
  FROM dbo.SESchoolYearDistrictConfig
		


