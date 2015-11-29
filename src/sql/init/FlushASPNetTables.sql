
DECLARE @ApplicationId UNIQUEIDENTIFIER, @UserId UNIQUEIDENTIFIER

EXEC aspnet_Applications_CreateApplication 'SE', @ApplicationId OUTPUT


DELETE dbo.aspnet_Membership
 WHERE ApplicationId=@ApplicationId

DELETE dbo.aspnet_UsersInRoles
  FROM dbo.aspnet_UsersInRoles ur
  JOIN dbo.aspnet_Roles r 
    ON ur.RoleID=r.RoleId
 WHERE r.ApplicationId=@ApplicationId

DELETE dbo.aspnet_Users
  FROM dbo.aspnet_Users
 WHERE ApplicationId=@ApplicationId

DELETE dbo.aspnet_Roles
 WHERE ApplicationId=@ApplicationId

DELETE dbo.aspnet_Applications
 WHERE ApplicationID=@ApplicationId