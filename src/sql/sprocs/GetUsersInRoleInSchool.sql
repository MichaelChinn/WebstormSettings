IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetUsersInRoleInSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUsersInRoleInSchool.'
      DROP PROCEDURE dbo.GetUsersInRoleInSchool
   END
GO
PRINT '.. Creating sproc GetUsersInRoleInSchool.'
GO

CREATE PROCEDURE dbo.GetUsersInRoleInSchool
	 @pSchoolCode	VARCHAR(20)
	,@pRole			VARCHAR(50)
AS

SET NOCOUNT ON 


SELECT u.* 
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
  JOIN dbo.aspnet_UsersInRoles ur
    ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r
    ON ur.RoleID=r.RoleID
  JOIN dbo.SEUserDistrictSchool uds
	ON u.SEUserID=uds.SEUserID
 WHERE r.RoleName=@pRole
   AND uds.SchoolCode=@pSchoolCode
 ORDER BY u.LastName, u.FirstName
