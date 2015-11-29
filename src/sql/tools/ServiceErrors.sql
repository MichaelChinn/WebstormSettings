select d.districtSchoolName, u.Username, u.LastName, u.FirstName, m.Email, e.TimeUtc, CAST(GetDate() - GetUtcDate() + e.TimeUtc AS DATETIME) AS TimePST
 from ELMAH_Error e
  join seuser u on e.[User]=u.username
  join aspnet_Membership m on u.ASPNetUserID=m.UserID
  join SEDistrictSchool d on u.DistrictCode=d.districtCode and d.isSchool=0
 where Message like '%Service Error%UpdateRubricRowAnnotation%'
  and e.TimeUtc > '2015-02-15 22:59:44.763'
 -- and d.districtCode='17405'
   order by  e.TimeUtc desc
   
--select u.FirstName, u.LastName, d.districtSchoolName, COUNT(*)
select d.districtSchoolName, COUNT(*) AS ErrorCount
 from ELMAH_Error e
  join seuser u on e.[User]=u.username
  join aspnet_Membership m on u.ASPNetUserID=m.UserID
  join SEDistrictSchool d on u.DistrictCode=d.districtCode and d.isSchool=0
 where Message like '%Service Error%UpdateRubricRowAnnotation%'
  and e.TimeUtc > '2015-03-01 22:59:44.763'
--  and d.districtCode='17405'
  -- group by u.FirstName, u.LastName, d.districtSchoolName
  group by d.districtSchoolName
   order by COUNT(*) desc