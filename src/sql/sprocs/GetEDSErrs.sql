IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEDSErrs') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEDSErrs.'
      DROP PROCEDURE dbo.GetEDSErrs
   END
GO
PRINT '.. Creating sproc GetEDSErrs.'
GO

CREATE PROCEDURE dbo.GetEDSErrs
	@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

-- SELECT * FROM edserror where districtcode='01147' order by districtCode

SELECT u.FirstName + ' ' + u.LastName AS Name,
	msg.errorMsg,
	msg.locationName,
	msg.roleString,
	d.DistrictSchoolName AS DistrictName,
	ISNULL(s.DistrictSchoolName, '') AS SchoolName
  FROM dbo.edsError msg
  JOIN dbo.vedsUsers u ON msg.personID=u.personID
  JOIN dbo.SEDistrictSchool d ON msg.DistrictCode=d.DistrictCode 
  LEFT OUTER JOIN dbo.SEDistrictSchool s ON msg.SchoolCOde=s.SchoolCode 
 WHERE msg.DistrictCode=@pDistrictCode
   AND d.IsSchool=0
   AND (s.IsSchool IS NULL OR s.IsSchool=1)
 ORDER BY u.LastName, u.FirstName


