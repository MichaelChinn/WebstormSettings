/*
select * from seuser u
  join aspnet_users u2 on u.aspnetUserid=u2.userid
  join aspnet_membership m on u2.userid=m.userID
  where u.username='101_edsUser' or u.username='116275_edsUser'
  where LastName='Smither'
    and FirstName = ' Chad'
    
update aspnet_membership set PasswordFormat=1 where userid='1328A23D-9E7F-4F70-8A86-1D683C682416'
sel
select * from seevaluation where evaluateeid=217

select * from sedistrictschool where districtcode='23403'
select * from sedistrictschool where schoolCode='4320'
select * from sedistrictschool where districtschoolname like '%North Mason%'
select * from seevaluationtype

select * from seframeworknode
*/

/* 
Create a table containing all of the principals from North Mason. Use it to join in queries
*/

create table #NMPR(UserID BIGINT)
insert into #NMPR(UserID)

/* 
217	     Jack		Smither			101_edsUser		3175	North Mason Senior High School          
1560	 Kristen	Sheridan		81448_edsUser	4320	Sand Hill Elementary                    
1567	 Thom		Worlund			97566_edsUser	3174	Hawkins Middle School                   
2103	 Chad		Collins			116275_edsUser	3175	North Mason Senior High School          
2709	 Julie		Wasserburger	116274_edsUser	2662	Belfair Elementary                      
3574	 anne		crosby			26199_edsUser	1680	PACE Academy (OPTIONS)                  
3625	 Mark		Swofford		32646_edsUser	3175	North Mason Senior High School          
*/

select u.SEUserID --, u.FirstName, u.LastName, u.UserName, u.SchoolCode, ds.DistrictSchoolName
  from dbo.SEUser u
  join dbo.SEEvaluation e on u.SEUserID=e.EvaluateeID
  join dbo.SEDistrictSchool ds on u.DistrictCode=ds.DistrictCode and u.SchoolCode=ds.SchoolCode
 where u.DistrictCode='23403'
   and e.EvaluationTYpeID=1
   and e.SchoolYear=2013



/* Messages */

create table #Message(MessageID bigint)
insert into #Message(MessageID)
 select mh.MessageID
   from MessageHeader mh
   join Message m on mh.MessageID=m.MessageID
   join #NMPR nmpr on mh.RecipientID=nmpr.UserID
  order by mh.RecipientID
  
select 'delete Message where MessageID=' + CONVERT(VARCHAR, m.MessageID)
  from #Message m
  
select 'delete MessageHeader where MessageID=' + CONVERT(VARCHAR, m.MessageID)
  from #Message m
  
/************************ DELETE MESSAGES ***********************************/
/*
delete MessageHeader where MessageID=3725
delete MessageHeader where MessageID=4129
delete MessageHeader where MessageID=616
delete MessageHeader where MessageID=4237
delete MessageHeader where MessageID=3560
delete MessageHeader where MessageID=2774
delete MessageHeader where MessageID=3308
delete MessageHeader where MessageID=3414
delete MessageHeader where MessageID=2773

delete Message where MessageID=3725
delete Message where MessageID=4129
delete Message where MessageID=616
delete Message where MessageID=4237
delete Message where MessageID=3560
delete Message where MessageID=2774
delete Message where MessageID=3308
delete Message where MessageID=3414
delete Message where MessageID=2773

*/

/* Artifacts */

select ArtifactID, ri.RepositoryItemID, OwnerID, ItemName from SEArtifact a
  join stateeval_repo.dbo.RepositoryItem ri on a.RepositoryItemID=ri.RepositoryItemID
  join #NMPR nmpr on ri.OwnerID=nmpr.UserID
 where a.SchoolYear=2013

/*
3838	4077	3574	school success plan
4232	4489	2103	Freshman "F" Report tri. 1 12/13
4234	4491	2103	Grade Report tri 1 12/12
*/

/****************************** DELETE ARTIFACTS **********************************/

/*
exec stateeval_repo.dbo.DeleteRepositoryItem 4077
exec FlushArtifactAlignment 3838
exec RemoveArtifact 3838
exec stateeval_repo.dbo.DeleteRepositoryItem 4489
exec RemoveArtifact 4232
exec FlushArtifactAlignment 4232
exec stateeval_repo.dbo.DeleteRepositoryItem 4491
exec RemoveArtifact 4234
exec FlushArtifactAlignment 4234
*/

/* DistrictCOnfiguration, SchoolConfiguration */

select * from SEDistrictConfiguration 
 where DistrictCode='23403'
   and SchoolYear=2013
   and EvaluationTypeID=1
   
   select * from SESchoolConfiguration 
 where DistrictCode='23403'
   and SchoolYear=2013

  
/*********************************** DELETE DistrictConfiguration ****************************************/ 
delete SEDistrictConfiguration 
 where DistrictCode='23403'
   and SchoolYear=2013
   and EvaluationTypeID=1
   
 delete SESchoolConfiguration 
 where DistrictCode='23403'
   and SchoolYear=2013
*/

/* SEEvalAssignmentRequest */
select * from SEEvalAssignmentRequest r
  join #nmpr nmpr on r.EvaluateeID=nmpr.UserID
  
 /* NOTE: No data found*/

  
/* SEEvalSession */
-- self-assessments
select * from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=1
   and s.SchoolYear=2013
   
select 'RemoveEvalSession ' + CONVERT(VARCHAR, s.EvalSessionID) + ', @sql_Error_message output '
 from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=1
   and s.SchoolYear=2013
   
/********************************* DELETE EVAL SESSIONS ************************************/

/*
declare @sql_Error_message varchar(max)
exec RemoveEvalSession 2080, @sql_Error_message output 
exec RemoveEvalSession 3065, @sql_Error_message output 
exec RemoveEvalSession 7473, @sql_Error_message output 
exec RemoveEvalSession 8187, @sql_Error_message output 
*/

-- observations
select * from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=0
   and s.SchoolYear=2013
   
   select 'RemoveEvalSession ' + CONVERT(VARCHAR, s.EvalSessionID) + ', @sql_Error_message output '
 from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=0
   and s.SchoolYear=2013
   
/*
declare @sql_Error_message varchar(max)
exec RemoveEvalSession 3397, @sql_Error_message output 
exec RemoveEvalSession 6197, @sql_Error_message output 
exec RemoveEvalSession 6276, @sql_Error_message output 
exec RemoveEvalSession 7280, @sql_Error_message output 
exec RemoveEvalSession 7281, @sql_Error_message output 
*/

/* SEEvaluation */

create table #eval(evaluationid bigint)
insert into #eval(evaluationid)
select e.EvaluationID from SEEvaluation e
  join #nmpr nmpr on e.EvaluateeID=nmpr.UserID
 where e.SchoolYear=2013
 
/* NOTE: DO NOT DELETE THIS. IT is created in SyncUserFromEDSInfo */
--delete SeEvalVisibility 
--  where EvaluationID in (select EvaluationID from #eval)

 
 /* semeasure */

select * from semeasure m
   join #nmpr nmpr on m.EvaluateeID=nmpr.UserID
 where m.SchoolYear=2013
 /* NOTE: No data */

/* NOTE: DO NOT DELETE THIS. IT is created in SyncUserFromEDSInfo */
--delete SEEvaluation 
--  where EvaluationID in (select EvaluationID from #eval)  
  
 /* Summative Scores */ 
select * from sesummativeframeworknodescore s
   join seframeworknode n on s.FrameworkNodeId=n.FrameworkNodeID
   join seframework f on n.FrameworkID=f.FrameworkID
   join #nmpr nmpr on s.EvaluateeID=nmpr.UserID
  where f.SchoolYear=2013
    and f.DistrictCode='23403'
    
 select * from sesummativerubricrowscore s
   join serubricrow rr on s.RubricRowID=rr.RubricRowID
   join serubricrowframeworknode rrfn on rr.RubricRowID=rrfn.RubricRowID
   join seframeworknode n on rrfn.FrameworkNodeId=n.FrameworkNodeID
   join seframework f on n.FrameworkID=f.FrameworkID
   join #nmpr nmpr on s.EvaluateeID=nmpr.UserID
  where f.SchoolYear=2013
    and f.DistrictCode='23403'
    
 /* NOTE: No Data */


/***************** TODO: delete framework, frameworknode, rubricrow, etc ********************/
 
/*
select *  from seuserprompt
   where districtcode='23403'
     and evaluationtypeid=1
          
select * from seuserprompttype 
*/
      
 create table #prompt(UserPromptID bigint)
insert into #Prompt(UserPromptID)
   select UserPromptID from seuserprompt
   where districtcode='23403'
     and evaluationtypeid=1
     
select * from seuserpromptrubricrowalignment a
  join #prompt p on a.UserPromptID=p.UserPromptID
     /* NOTE: No data */

select * from seuserpromptconferencedefault d
   join #nmpr nmpr on d.EvaluateeID=nmpr.UserID
/* NOTE: No data */

CREATE TABLE #response(UserPromptResponseID BIGINT)
INSERT #response(UserPromptResponseID)
SELECT UserPromptResponseID
  FROM dbo.SEUserPromptResponse	r
  JOIN #prompt p on r.UserPromptID=p.UserPromptID
  join #nmpr nmpr on r.EvaluateeID=nmpr.UserID

							  
SELECT 'DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM  #response

SELECT 'DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM  #response
  
SELECT 'DELETE dbo.SEUserPrompt WHERE UserPromptID=' + CONVERT(VARCHAR, UserPromptID)
  FROM  #prompt
  
/************************** DELETE UserPromptResponseEntry ************************************/
/*
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=9730
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=9731
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=28370
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=28371
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=28372
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=28373
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=31257
DELETE dbo.SEUserPromptResponseEntry WHERE UserPromptResponseID=31258

DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=9730
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=9731
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=28370
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=28371
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=28372
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=28373
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=31257
DELETE dbo.SEUserPromptResponse WHERE UserPromptResponseID=31258

DELETE dbo.SEUserPrompt WHERE UserPromptID=1660
DELETE dbo.SEUserPrompt WHERE UserPromptID=1661
DELETE dbo.SEUserPrompt WHERE UserPromptID=4054
DELETE dbo.SEUserPrompt WHERE UserPromptID=4055
DELETE dbo.SEUserPrompt WHERE UserPromptID=4056
DELETE dbo.SEUserPrompt WHERE UserPromptID=4057
DELETE dbo.SEUserPrompt WHERE UserPromptID=4556
DELETE dbo.SEUserPrompt WHERE UserPromptID=4557
*/

/*
select * from seframework where districtcode='23403'
select * from stateeval_proto.dbo.seframework where frameworkid=42
*/
exec FlushFramework '23403', 1, 2013, 1

exec LoadFrameworkSetForTeacherOrPrincipal @pSchoolYear =2013,@pEvalType='Principal'  , @pSfDistrictCode='bmarpr',@pDfDistrictCode='23403',@pdfBaseName='North Mason School District'

 



 
   
   

 

