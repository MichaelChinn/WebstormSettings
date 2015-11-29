
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vSEUserDistrictSchool')
    DROP VIEW dbo.vSEUserDistrictSchool
GO

CREATE VIEW dbo.vSEUserDistrictSchool
AS 

SELECT uds.SEUserID
	  ,uds.SchoolCode
	  ,uds.DistrictCode
	  ,uds.IsPrimary
	  ,dn.DistrictName
	  ,sn.SchoolName
 FROM dbo.SEUserDistrictSchool uds
 JOIN dbo.vDistrictName dn
   ON dn.DistrictCode = uds.DistrictCode
 LEFT OUTER JOIN dbo.vSchoolName sn
   ON sn.SchoolCode = uds.SchoolCode






