
select * from ELMAH_ERROR 
where AllXml like '%Authentication failed%168.212.224.254%'
order by TimeUtc desc

select * from ELMAH_Error where [USER] like '20767_edsUser%'
delete ELMAH_Error where [USER] like '20767_edsUser%'

select * from ELMAH_Error where AllXml like '%MissingFrameworkException%'
select * from ELMAH_Error where AllXml like '%ROLES_MISMATCH%'
select * from ELMAH_Error where AllXml like '%Invalid length%The client disconnected%'
select * from ELMAH_Error where AllXml like '%Invalid viewstate%The client disconnected%'
select * from ELMAH_Error where AllXml like '%firefox%'
select * from ELMAH_Error where AllXml like '%Authentication failed during StateEval service call%'
select * from ELMAH_Error where AllXml like '%SamlSecurityToken %' order by TimeUtc desc

delete ELMAH_Error where AllXml like '%Invalid viewstate%The client disconnected%'
delete ELMAH_Error where AllXml like '%Invalid length%The client disconnected%'
delete ELMAH_Error where AllXml like '%ROLES_MISMATCH%'
delete ELMAH_Error where AllXml like '%MissingFrameworkException%'
delete ELMAH_Error where AllXml like '%firefox%'
delete ELMAH_Error where AllXml like '%Authentication failed during StateEval service call%'
delete ELMAH_Error where AllXml like '%Authentication failed%iPad%'

delete ELMAH_Error where TimeUtc < '2012-10-05 04:05:31.950'

select * from ELMAH_Error where [USER] = '65357_edsUser'
delete ELMAH_Error where [USER] = '65357_edsUser'

SELECT m.Sender, m.SEnderId, h.RecipientID, m.Subject, m.Body, m.MessageTypeID, m.SendTime, 
	h.EmailSent, h.EmailSentDateTime, dt.NAME	
	,'update MessageHeader set EmailSent=1 where MessageID=' + CONVERT(VARCHAR, m.MessageID)
 FROM message m
 join messageheader h ON m.messageid=h.messageid
 JOIN dbo.MessageTypeRecipientConfig c ON (m.MessageTypeID=c.MessageTypeID AND h.RecipientID=c.RecipientID)
 JOIN dbo.EmailDeliveryType dt ON c.EmailDeliveryTypeID=dt.EmailDeliveryTypeID
 WHERE h.EmailSent=0
   AND m.SendTime < '2013-09-17 09:29:48.490'
   --AND c.EmailDeliveryTypeID <> 4
ORDER BY m.SendTime

SELECT * FROM dbo.EmailDeliveryType

SELECT * FROM dbo.SEEvalSessionLockState

SELECT * FROM seevalsession WHERE evaluateeuserid=16103

select * from ELMAH_Error
  WHERE AllXml like '%SelfAssess%'
    and AllXml like '%Invalid length for a Base-64 char array%'
    order by User

select u.firstname + ' ' + u.lastname, m.email, district.districtSchoolName, school.districtSchoolName, * from seuser u
  join aspnet_users u2 on u.aspnetuserid=u2.userid
  join aspnet_membership m on u2.userid=m.userid
  join aspnet_usersinroles ur on u2.userid=ur.userid
  join aspnet_roles r on ur.roleid=r.roleid
  join SEDistrictSchool district on (u.DistrictCode=district.districtCode and district.isSchool=0)
  left outer join SEDistrictSchool school on (u.DistrictCode=school.districtCode and school.schoolCode=u.SchoolCode)
  --where CertificateNumber='399730A'
 --where u.LastName='lindberg' order by u.firstname
-- where u.FirstName='Mona'
 --where u2.UserName='1132'
  where u.SEUserID in (267)
  
  select DB_ID ( 'StateEval' ) 
  
  select * from aspnet_UsersInRoles where UserId='B133CD56-42E5-43E6-AD20-E1B93F830B53'
  -- delete aspnet_UsersInRoles where UserId='B133CD56-42E5-43E6-AD20-E1B93F830B53'
  
   select * from SEUserDistrictSchool uds
    join sedistrictschool dsd on uds.districtCode=dsd.districtcode and dsd.isschool=0
    join sedistrictschool dss on uds.schoolcode=dss.schoolcode
    where SEUserID in (5829, 17558)

update aspnet_membership
set password = 'Teot+hQW/alZR0qJgHbyeIps4jY='
,PasswordFormat=1
, passwordSalt = 'vuFtU+smxgqlRZh2i9dkrQ=='
where UserId='A5C05E58-47BB-48EC-9AF0-418831CF50AA'

select u.firstname + ' ' + u.lastname, m.email, * from seuser u
  join aspnet_users u2 on u.aspnetuserid=u2.userid
  join aspnet_membership m on u2.userid=m.userid
  join aspnet_usersinroles ur on u2.userid=ur.userid
  join aspnet_roles r on ur.roleid=r.roleid  
  where u.schoolCode='2134'
  (r.rolename = 'SESchoolAdmin')
   and u.districtcode='04246'
   and u.SchoolCode='2134'
    and u.seuserid not in (select evaluateeid from seevaluation)

select * from SERubricRowScore where EvalSessionID in (
select evalsessionid from SEEvalSession where AnchorSessionID in (1034, 1114))

select * from SEEvalSession where AnchorSessionID in (1034, 1114)

select * from SEEvalSession 
where EvaluatorUserID=1132
where EvalSessionID=1132

select * from SEUserPrompt
select * from SEUserPromptResponse

select RowNumber from Trace where TextData like '%ScoreFrameworkNode%'

select * from SEUser where DistrictCode='18303'

select * from SEDistrictSchool where districtCode='18303'
select * from SEDistrictSchool where districtschoolname like '%Wenatchee%'

select username from aspnet_users where username like '%North Kit%'

update aspnet_users set username='North Kitsap School District' where username='North Kitsap SD'







  

