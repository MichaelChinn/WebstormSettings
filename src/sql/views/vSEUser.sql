
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vSEUser')
    DROP VIEW dbo.vSEUser
GO

CREATE VIEW dbo.vSEUser
AS 

SELECT u.SEUserID
	  ,u.aspnetUserID
	  ,netu.UserName
	  ,u.FirstName
	  ,u.LastName
	  ,u.LastName + ', ' + u.FirstName AS DisplayName
	  ,u.HasMultipleBuildings
	  ,dn.DistrictName
	  ,sn.SchoolName
	  ,u.DistrictCode
	  ,ISNULL(u.SchoolCode, '') AS SchoolCode
      ,netm.Email      
      ,u.MessageEmailOverride
       ,u.CertificateNumber
      ,u.EmailAddressAlternate
      ,u.LoginName
	  ,u.MobileAccessKey
 FROM dbo.SEUser u (NOLOCK)
 LEFT JOIN dbo.aspnet_Users netu (NOLOCK)
   ON u.aspnetUserID=netu.UserID
 LEFT JOIN dbo.aspnet_Membership netm (NOLOCK)
   ON netu.UserID=netm.UserID
 LEFT OUTER JOIN dbo.vDistrictName dn (NOLOCK)
   ON dn.DistrictCode = u.DistrictCode
 LEFT OUTER JOIN dbo.vSchoolName sn (NOLOCK)
   ON sn.SchoolCode = u.SchoolCode



