


/****** Object:  View [dbo].[vSEUser]    Script Date: 03/05/2012 10:41:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER VIEW [dbo].[vSEUser]
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
 FROM dbo.SEUser u
 LEFT JOIN dbo.aspnet_Users netu
   ON u.aspnetUserID=netu.UserID
 LEFT JOIN dbo.aspnet_Membership netm 
   ON netu.UserID=netm.UserID
 LEFT OUTER JOIN dbo.vDistrictName dn
   ON dn.DistrictCode = u.DistrictCode
 LEFT OUTER JOIN dbo.vSchoolName sn
   ON sn.SchoolCode = u.SchoolCode





GO


