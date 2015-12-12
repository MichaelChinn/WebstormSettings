select evaluatee.FirstName + ' ' + evaluatee.LastName, es.Title, es.* from seevalsession es
  join SEUser  evaluatee on es.evaluateeuserid=evaluatee.seuserid
   where EvaluatorUserID=158 
 order by evaluatee.LastName, es.Title

select * from seuser u
join aspnet_Users u2 on u.ASPNetUserID =u2.UserId
join aspnet_Membership m on u2.UserId=m.userid
join aspnet_UsersInRoles ur on u2.UserId=ur.UserId
join aspnet_Roles r on ur.RoleId=r.roleid
 where u.SEUserID=158
 
 delete SEEvalSession where EvalSessionID=201
 
 select * from SERubricRowScore where EvalSessionID=201
 
 select * from SEDistrictSchool where districtCode='32356'

DELETE dbo.SEPreConferenceQuestionResponse
 WHERE EvalSessionID=195
 
DELETE dbo.SEEvalSessionWfHistory
 WHERE EvalSessionID=195
 
DELETE dbo.SEEvalSession
 WHERE EvalSessionID=195
 
 DELETE dbo.SEPreConferenceQuestionResponse
 WHERE EvalSessionID=194
 
DELETE dbo.SEEvalSessionWfHistory
 WHERE EvalSessionID=194
 
 delete SEEvalSessionFrameworkNodeFocus where EvalSessionID=194
 
DELETE dbo.SEEvalSession
 WHERE EvalSessionID=194
 
 
 
 