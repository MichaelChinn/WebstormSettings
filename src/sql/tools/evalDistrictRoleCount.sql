
select ds.districtSchoolName, sch.districtSchoolName, r.RoleName, COUNT(*) AS Count
  from dbo.SEUser u
  join dbo.SEDistrictSchool ds on u.DistrictCode=ds.DistrictCode and ds.isSchool=0
  join dbo.SEDistrictSchool sch on u.SchoolCode=sch.schoolCode and sch.isSchool=1
  join aspnet_Users u2 on u.ASPNetUserID=u2.UserId
  join aspnet_UsersInRoles ur on u2.UserId=ur.UserId
  join aspnet_Roles r on ur.RoleId=r.RoleId
  WHERE r.ROleName IN ('SESchoolPrincipal', 'SESchoolTeacher', 'SEDistrictEvaluator')
  group by ds.districtSchoolName, sch.districtSchoolName, r.RoleName
  order by ds.districtSchoolName, sch.districtSchoolName, r.RoleName
  
    select ds.DistrictSchoolName, 
         sch.districtSchoolName,
	     s.SchoolYear,
		 COUNT(*) As COUNT,
         CASE WHEN (s.IsSelfAssess=1) THEN 'Self-Assess' ELSE 'Observation' END AS SessionType
    from SEEvalSession s
    join sedistrictschool ds on s.districtcode=ds.districtcode and ds.isschool=0
    join dbo.SEDistrictSchool sch on s.SchoolCode=sch.schoolCode and sch.isSchool=1
    group by ds.districtSchoolName, sch.districtSchoolName, s.SchoolYear, s.IsSelfAssess
    order by ds.districtSchoolName, sch.districtSchoolName, s.SchoolYear, s.IsSelfAssess
    
        select ds.DistrictSchoolName, 
        sch.districtSchoolName,
	     a.SchoolYear,
		 COUNT(*) As COUNT
    from vArtifact a
    join sedistrictschool ds on a.DistrictCode=ds.districtcode and ds.isschool=0
    join SEUser u on a.UserID=u.seuserid
     join dbo.SEDistrictSchool sch on u.SchoolCode=sch.schoolCode and sch.isSchool=1
   group by ds.districtSchoolName, sch.districtSchoolName, a.SchoolYear
    order by ds.districtSchoolName, sch.districtSchoolName, a.SchoolYear
      
        select ds.DistrictSchoolName, 
			sch.districtSchoolName, 
	     e.SchoolYear,
		 COUNT(*) As COUNT
    from SEEvaluation e
    join SEUser u on e.EvaluateeID=u.seuserid
    join sedistrictschool ds on e.DistrictCode=ds.districtcode and ds.isschool=0
      join dbo.SEDistrictSchool sch on u.SchoolCode=sch.schoolCode and sch.isSchool=1
    WHERE e.PerformanceLevelID IS NOT NULL
    group by ds.districtSchoolName, sch.districtSchoolName, e.SchoolYear
    order by ds.districtSchoolName, sch.districtSchoolName, e.SchoolYear
    
    select ds.DistrictSchoolName, 
		sch.districtSchoolName, 
	     f.SchoolYear,
		 COUNT(*) As COUNT
    from dbo.SESummativeFrameworkNodeScore e
    JOIN dbo.SEFrameworkNode fn ON e.FrameworkNodeID=fn.FrameworkNodeID
    JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
    JOIN SEUser u ON e.SEUserID=u.SEUserID
    join sedistrictschool ds on u.DistrictCode=ds.districtcode and ds.isschool=0
    join dbo.SEDistrictSchool sch on u.SchoolCode=sch.schoolCode and sch.isSchool=1
    WHERE e.PerformanceLevelID IS NOT NULL
    group by ds.districtSchoolName, sch.districtSchoolName, f.SchoolYear
    order by ds.districtSchoolName, sch.districtSchoolName, f.SchoolYear
  
  
  