IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vDistrictName')
   BEGIN
      PRINT '.. Dropping View vDistrictName.'
	  DROP VIEW dbo.vDistrictName
   END
GO
PRINT '.. Creating View vDistrictName.'
GO
CREATE VIEW dbo.vDistrictName
AS 

	SELECT
		rtrim(DistrictSchoolName) as DistrictName,
		districtCode
	FROM
		dbo.SEDistrictSchool
	WHERE
		IsSchool = 0


