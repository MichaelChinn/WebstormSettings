
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserOrientation')
    DROP VIEW dbo.vUserOrientation
GO

CREATE VIEW dbo.vUserOrientation
AS 

select distinct fc.FrameworkContextID,
 fc.SchoolYear,
 ulr.UserLocationRoleID,
 fc.DistrictCode,
 ulr.SchoolCode,
 fc.EvaluationTypeID,
 r.RoleId,
 r.RoleName, 
 u.SEUserID,
 ulr.DistrictName,
 ISNULL (ulr.SchoolName, '') as SchoolName
  from dbo.SEFrameworkContext fc
  join dbo.SEUserLocationRole ulr on fc.DistrictCode=ulr.DistrictCode
  join dbo.SEUser u on ulr.SEUserID=u.SEUserID
  join dbo.aspnet_Roles r on ulr.RoleID=r.RoleID
  join dbo.SEEvaluationTypeRole evalRole on r.roleid=evalRole.roleID
 where fc.EvaluationTypeID=evalRole.EvaluationTypeID
   and (r.RoleName='SEDistrictAdmin' OR fc.IsActive=1)

