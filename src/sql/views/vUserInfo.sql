
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserInfo')
    DROP VIEW dbo.vUserInfo
GO

CREATE VIEW dbo.vUserInfo
AS 

SELECT su.*
	, u.*
	, m.password
	, m.passwordSalt
	, m.passwordFormat
	, r.RoleName 
FROM aspnet_users u
JOIN seUser su ON su.ASPNetUserID = u.UserId
JOIN aspnet_membership m ON m.userID = u.userID
JOIN aspnet_usersInROles uir on uir.userID = u.userID
JOIN aspnet_roles r ON  r.roleID = uir.RoleId
	




