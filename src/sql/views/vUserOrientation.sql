
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
 ds_district.DistrictSchoolName as DistrictName,
 ISNULL (ds_school.DistrictSchoolName, '') as SchoolName
  from dbo.SEFrameworkContext fc
  join dbo.SEUserLocationRole ulr on fc.DistrictCode=ulr.DistrictCode
  join dbo.SEDistrictSchool ds_district on ulr.DistrictCode=ds_district.DistrictCode and ds_district.isSchool=0
  left outer join dbo.SEDistrictSchool ds_school on ulr.SchoolCode=ds_school.SchoolCode and ds_school.isSchool=1
  join dbo.SEUser u on ulr.SEUserID=u.SEUserID
  join dbo.aspnet_Roles r on ulr.RoleID=r.RoleID
  join dbo.SEEvaluationTypeRole evalRole on r.roleid=evalRole.roleID
 where fc.EvaluationTypeID=evalRole.EvaluationTypeID
   and (r.RoleName='SEDistrictAdmin' OR fc.IsActive=1)

