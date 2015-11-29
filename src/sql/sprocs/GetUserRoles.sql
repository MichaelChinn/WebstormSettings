IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetUserRoles') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserRoles.'
      DROP PROCEDURE dbo.GetUserRoles
   END
GO
PRINT '.. Creating sproc GetUserRoles.'
GO

CREATE PROCEDURE dbo.GetUserRoles
	@pUserId BIGINT
AS

SET NOCOUNT ON 

SELECT r.rolename 
  FROM aspnet_roles r
  JOIN aspnet_usersinroles ur ON r.roleid=ur.roleid
  JOIN seuser u ON ur.userid=u.aspnetuserid
  WHERE u.seuserid=@pUserID

