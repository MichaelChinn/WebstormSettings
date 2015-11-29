
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserOrientation')
    DROP VIEW dbo.vUserOrientation
GO

CREATE VIEW dbo.vUserOrientation
AS 

select distinct fc.FrameworkContextID,
 fc.SchoolYear,
 ds.UserDistrictSchoolID,
 fc.DistrictCode,
 ds.SchoolCode,
 fc.EvaluationTypeID,
 r.RoleId,
 r.RoleName, 
 u.SEUserID,
 ds.DistrictName,
 ISNULL (ds.SchoolName, '') as SchoolName
  from dbo.SEFrameworkContext fc
  join dbo.SEUserDistrictSchool ds on fc.DistrictCode=ds.DistrictCode
  join dbo.SEUser u on ds.SEUserID=u.SEUserID
  JOIN dbo.SEUserLocationRole ulr ON ulr.seUserid = u.SEUserID
  join dbo.aspnet_Roles r on ulr.RoleID=r.RoleID
  join dbo.SEEvaluationTypeRole evalRole on r.roleid=evalRole.roleID
 where fc.EvaluationTypeID=evalRole.EvaluationTypeID
   and (r.RoleName='SEDistrictAdmin' OR fc.IsActive=1)

