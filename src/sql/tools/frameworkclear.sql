

DECLARE @districtCode VARCHAR(20), @schoolYear SMALLINT, @evalType SMALLINT

SELECT @districtCode = '17407'
SELECT @schoolYear = 2014
SELECT @evalType = 1

/* 
Create a table containing all of the principals from district. Use it to join in queries
*/
-- drop table #NMPR
-- drop table #Message
create table #NMPR(UserID BIGINT)
insert into #NMPR(UserID)


select u.SEUserID --, u.FirstName, u.LastName, u.UserName, u.SchoolCode, ds.DistrictSchoolName
  from dbo.SEUser u
  join dbo.SEEvaluation e on u.SEUserID=e.EvaluateeID
  join dbo.SEDistrictSchool ds on u.DistrictCode=ds.DistrictCode and u.SchoolCode=ds.SchoolCode
 where u.DistrictCode=@districtCode
   and e.EvaluationTypeID=@evalType
   and e.SchoolYear=@schoolYear


/* Messages */
/*
create table #Message(MessageID bigint)
insert into #Message(MessageID)
 select mh.MessageID
   from MessageHeader mh
   join Message m on mh.MessageID=m.MessageID
   join #NMPR nmpr on mh.RecipientID=nmpr.UserID
 WHERE mh.SendTime >='2013-08-22 08:13:13.550'
  order by mh.RecipientID
  
select 'delete Message where MessageID=' + CONVERT(VARCHAR, m.MessageID)
  from #Message m
  
select 'delete MessageHeader where MessageID=' + CONVERT(VARCHAR, m.MessageID)
  from #Message m
 */
  
/************************ DELETE MESSAGES ***********************************/

/* Artifacts */
/*
select ArtifactID, ri.RepositoryItemID, OwnerID, ItemName from SEArtifact a
  join stateeval_repo.dbo.RepositoryItem ri on a.RepositoryItemID=ri.RepositoryItemID
  join #NMPR nmpr on ri.OwnerID=nmpr.UserID
 where a.SchoolYear=@schoolYear
   AND a.districtCode=@districtCode
*/

/****************************** DELETE ARTIFACTS **********************************/

/*
exec stateeval_repo.dbo.DeleteRepositoryItem 4077
exec FlushArtifactAlignment 3838
exec RemoveArtifact 3838
*/

/* DistrictCOnfiguration, SchoolConfiguration */
/*
select * from SEDistrictConfiguration 
 where DistrictCode=@districtCode
   and SchoolYear=@schoolYear
   and EvaluationTypeID=@evalType
   
   select * from SESchoolConfiguration 
 where DistrictCode=@districtCode
   and SchoolYear=@schoolYear
*/
  
/*********************************** DELETE DistrictConfiguration ****************************************/ 
/*
delete SEDistrictConfiguration 
 where DistrictCode=@districtCode
   and SchoolYear=@schoolYear
   and EvaluationTypeID=@evalType
   
 delete SESchoolConfiguration 
 where DistrictCode=@districtCode
   and SchoolYear=@schoolYear
*/

/* SEEvalSession */
-- self-assessments
/*
select * from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=1
   and s.SchoolYear=@schoolYear
   AND districtCode=@districtCode
   AND s.EvaluationTypeID=@evalType
*/
 /*
select 'RemoveEvalSession ' + CONVERT(VARCHAR, s.EvalSessionID) + ', @sql_Error_message output '
 from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=1
   and s.SchoolYear=@schoolYear
   AND districtCode=@districtCode
   AND s.EvaluationTypeID=@evalType
  */
   
/********************************* DELETE EVAL SESSIONS ************************************/

/*
declare @sql_Error_message varchar(max)
exec RemoveEvalSession 2080, @sql_Error_message output 
exec RemoveEvalSession 3065, @sql_Error_message output 
exec RemoveEvalSession 7473, @sql_Error_message output 
exec RemoveEvalSession 8187, @sql_Error_message output 
*/

-- observations
/*
select * from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=0
   and s.SchoolYear=@schoolYear
   AND districtCode=@districtCode
   AND s.EvaluationTypeID=@evalType
  */
   /*
   select 'RemoveEvalSession ' + CONVERT(VARCHAR, s.EvalSessionID) + ', @sql_Error_message output '
 from SEEvalSession s
  join #nmpr nmpr on s.EvaluateeUserID=nmpr.UserID
 where s.IsSelfAssess=0
   and s.SchoolYear=@schoolYear
   AND districtCode=@districtCode
   AND s.EvaluationTypeID=@evalType
   */
   
/*
declare @sql_Error_message varchar(max)
exec RemoveEvalSession 3397, @sql_Error_message output 
exec RemoveEvalSession 6197, @sql_Error_message output 
exec RemoveEvalSession 6276, @sql_Error_message output 
exec RemoveEvalSession 7280, @sql_Error_message output 
exec RemoveEvalSession 7281, @sql_Error_message output 
*/
   
 /* Summative Scores */ 
select * from sesummativeframeworknodescore s
   join seframeworknode n on s.FrameworkNodeId=n.FrameworkNodeID
   join seframework f on n.FrameworkID=f.FrameworkID
   join #nmpr nmpr on s.EvaluateeID=nmpr.UserID
  where f.SchoolYear=@schoolYear
    and f.DistrictCode=@districtCode
    AND f.EvaluationTypeID=@evalType
    
 select * from sesummativerubricrowscore s
   join serubricrow rr on s.RubricRowID=rr.RubricRowID
   join serubricrowframeworknode rrfn on rr.RubricRowID=rrfn.RubricRowID
   join seframeworknode n on rrfn.FrameworkNodeId=n.FrameworkNodeID
   join seframework f on n.FrameworkID=f.FrameworkID
   join #nmpr nmpr on s.EvaluateeID=nmpr.UserID
  where f.SchoolYear=@schoolYear
    and f.DistrictCode=@districtCode
    AND f.EvaluationTypeID=@evalType
    


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
   where districtcode=@districtCode
     and evaluationtypeid=@evalType
     AND schoolYear=@schoolYear
     
select * from seuserpromptrubricrowalignment a
  join #prompt p on a.UserPromptID=p.UserPromptID

select * from seuserpromptconferencedefault d
   join #nmpr nmpr on d.EvaluateeID=nmpr.UserID

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
select * from seframework where districtcode='23403'
select * from stateeval_proto.dbo.seframework where frameworkid=42
*/

/**/
SELECT n.ShortName, e.*
  FROM SEEvaluation e
  JOIN SEFrameworkNode n ON e.FocusedFrameworkNodeID=n.FrameworkNodeID
 WHERE e.EvaluationTypeID=1
   AND e.SchoolYear=2014
   AND e.DIstrictCode='17407'
   AND e.FocusedFrameworkNodeID IS NOT NULL
   
UPDATE e
   SET FocusedFrameworkNodeID=NULL
      ,FocusedSGFrameworkNodeID=NULL
  FROM SEEvaluation e
  WHERE e.EvaluationTypeID=1
   AND e.SchoolYear=2014
   AND e.DIstrictCode='17407'
   AND e.FocusedFrameworkNodeID IS NOT NULL
   */
     
--exec FlushFramework '17407', 1, 2014, 1


 



 
   
   

 

