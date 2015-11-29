select * from seuser where districtcode='34003'


select * from sedistrictconfiguration 

select * from seuser

select * from aspnet_roles

select * from seuserlocationrole

select * from seuser where firstname='p' and districtcode='34003' and schoolcode='3010'

select dc.SchoolYear, ds.DistrictCode, ds.SchoolCode, dc.EvaluationTypeID, r.RoleName
  from sedistrictconfiguration dc
  join SEUserDistrictSchool ds on dc.DistrictCode=ds.DistrictCode
  join SEUser u on ds.SEUserID=u.SEUserID
  join aspnet_UsersInRoles ur on u.ASPNetUserID=ur.UserID
  join aspnet_Roles r on ur.RoleID=r.RoleID
  join SEEvaluationTypeRole evalRole on r.roleid=evalRole.roleID
 where  u.SeUserID=45
   and dc.EvaluationTypeID=evalRole.EvaluationTypeID

 order by SchoolYear, EvaluationTypeID

 select * from vUserOrientation
  where SEUserID=273


 