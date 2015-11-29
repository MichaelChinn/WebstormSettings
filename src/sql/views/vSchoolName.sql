IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vSchoolName')
   BEGIN
      PRINT '.. Dropping View vSchoolName.'
	  DROP VIEW dbo.vSchoolName
   END
GO
PRINT '.. Creating View vSchoolName.'
GO
CREATE VIEW dbo.vSchoolName
AS 
	SELECT
		rtrim(DistrictSchoolName) as SchoolName
		,districtCode
		,schoolCode
		,isSecondary
	FROM
		dbo.SEDistrictSchool
	WHERE
		IsSchool = 1
