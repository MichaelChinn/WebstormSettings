IF EXISTS ( SELECT  TABLE_NAME
            FROM    INFORMATION_SCHEMA.VIEWS
            WHERE   TABLE_NAME = N'vLocationRoleClaim' ) 
    DROP VIEW dbo.vLocationRoleClaim
GO

CREATE VIEW dbo.vLocationRoleClaim
AS
    SELECT  ers.LocationRoleClaimID ,
            
            ers.userName ,
            ers.Location,
            ers.LocationCode,
            ers.RoleString ,
            cu.seUserID
    FROM    dbo.LocationRoleClaim ers
            LEFT OUTER JOIN dbo.aspnet_users au ON au.userName =  ers.UserName
            LEFT JOIN dbo.seUser cu ON cu.ASPNetUserID = au.UserId

