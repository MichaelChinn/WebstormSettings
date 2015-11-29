IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPrincipalsToImpersonateForDistrictViewer') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPrincipalsToImpersonateForDistrictViewer.'
      DROP PROCEDURE dbo.GetPrincipalsToImpersonateForDistrictViewer
   END
GO
PRINT '.. Creating sproc GetPrincipalsToImpersonateForDistrictViewer.'
GO

CREATE PROCEDURE dbo.GetPrincipalsToImpersonateForDistrictViewer
	@pDistrictCode	VARCHAR(20)
	,@pSchoolYear	SMALLINT
	,@pDistrictUserID BIGINT
	,@pRoleName VARCHAR(256)
AS

SET NOCOUNT ON 

SELECT u.*
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_UsersInRoles ur
    ON u.ASPNetUserID=ur.UserID
  JOIN dbo.aspnet_Roles r
    ON ur.RoleID=r.RoleID
  JOIN SEDistrictPRViewing v
    ON u.SchoolCode=v.SchoolCode
   JOIN dbo.SEDistrictSchool ds
    ON ds.SchoolCode=u.SchoolCode AND ds.IsSchool=1
 WHERE u.DistrictCode=@pDistrictCode
   AND v.SchoolYear=@pSchoolYear
   AND r.RoleName=@pRoleName
   AND v.DistrictUserID=@pDistrictUserID
 ORDER BY ds.DistrictSchoolName, u.LastName, u.FirstName

