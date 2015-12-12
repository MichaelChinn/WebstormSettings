
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserRoles')
    DROP VIEW dbo.vUserRoles
GO

CREATE VIEW dbo.vUserRoles
AS 

select se.seUserID, u.UserName, r.roleName, u.UserID from aspnet_UsersInRoles uir
join aspnet_Users u on u.UserId = uir.userId
join aspnet_Roles r on r.RoleId = uir.RoleId
join SEUser se on se.ASPNetUserID = u.userid


