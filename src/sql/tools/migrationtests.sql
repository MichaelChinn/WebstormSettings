select distinct u.SEUserID, u2.LoweredUserName
  from SEArtifactRubricRowAlignment rra
  join SEArtifact a on rra.ArtifactID=a.ArtifactID
  join stateeval_repo.dbo.RepositoryItem ri on a.RepositoryItemID=ri.RepositoryItemId
  join seuser u on ri.OwnerID=u.seuserid
  join aspnet_Users u2 on u.ASPNetUserID=u2.UserId


select distinct u2.username, u.seuserid, e.TItle, evaluatee.FirstName + ' ' + evaluatee.LastName
 from sepreconferencequestion q
  join seevalsession e on q.evalsessionid=e.evalsessionid
  join seuser u on e.evaluatoruserid=u.seuserid
  join seuser evaluatee on e.EvaluateeUserId=evaluatee.SEUserID
  join aspnet_users u2 on u.aspnetuserid=u2.userid
  where e.evaluatoruserid=158
  
  select q.Question, u2.username, u.seuserid from sepreconferencequestion q
    join seuser u on u.seuserid=q.createdByUserID
    join aspnet_users u2 on u.aspnetuserid=u2.userid
    where q.EvalSessionID is null
    
      select q.Question, u2.username, u.seuserid , *
        from sereflection q
    join seuser u on u.seuserid=q.createdByUserID
    join aspnet_users u2 on u.aspnetuserid=u2.userid
    where q.evaluateeid is not null
      and q.CreatedByUserID=181
      
      select evaluatorpostconnotes, *  from seevalsession
      where evaluatorpostconnotes <> '' 
       and evaluatorpostconnotes IS NOT NULL
       and evaluateepreconnotes <> ''
       and evaluateepreconnotes IS NOT NULL
       
       
       select * from seuser
       
       select * from sedistrictschool where districtschoolname like '%Olympia%'
       select * from seuser where districtcode='34111'
       select * from seuser where lastname='34111'
       
       select * from sefinalscore where performancelevelid is not null
      
      select * from sepreconferencequestion q
      where preconferencequestionid=52
      
        where q.CreatedByUserID=158
        
        select * from sepostconferencereflection 
          where CreatedByUserID=158
    
 update aspnet_membership set Password='Teot+hQW/alZR0qJgHbyeIps4jY=', PasswordSalt='vuFtU+smxgqlRZh2i9dkrQ==', PasswordFormat=1 
 where userid='6936D48B-D8E4-44C9-A034-D9D2A930DAF3'
 
   select u.seuserid, u2.username, u.firstname + ' ' + u.lastname, u.districtcode, u.schoolcode, r.rolename
   from seuser u
   join aspnet_users u2 on u.aspnetuserid=u2.userid
   join aspnet_membership m on u2.userid=m.userid
   join aspnet_usersinroles ur on u2.userid=ur.userid
   join aspnet_roles r on ur.roleid=r.roleid
   where r.rolename='seschooladmin'
     and u.districtcode='04246'
     
     select u.seuserid, u2.username, u.firstname + ' ' + u.lastname, u.districtcode, u.schoolcode, ds.districtSchoolName, *
        from seuser u
       join aspnet_users u2 on u.aspnetuserid=u2.userid
       join aspnet_Membership m on u2.UserId=m.userid
       join SEDistrictSchool ds on u.DistrictCode=ds.districtCode and ds.isSchool=0 
       join aspnet_UsersInRoles ur on u2.UserId=ur.UserId
       join aspnet_Roles r on ur.RoleId=r.roleid
   where m.Password<>''
     and r.RoleName='seschoolprincipal'
      --where u2.username='43759_edsuser'
       --where u.seuserid in (7, 54, 46, 208)
       --where lastname = 'dejong'
       --where LastName like '%helm%'
       order by u.seuserid
       
            select u.LastName, u.seuserid, u2.username
             from seuser u
       join aspnet_users u2 on u.aspnetuserid=u2.userid
       where u.districtcode='01147'
       
       select * from sedistrictschool where districtschoolname like '%wenatchee%'
       select * from sedistrictschool where schoolcode='2902'
       select * from sedistrictschool where districtcode='29103'
       
       GetDistrictSchools '04246'
       
       select * from seschoolconfiguration where schoolyear=2013
       
       select * from sepreconferencequestion where question like '%Please provide%'
       select * from seuserprompt where prompt like '%please provide a brief%'
       
       select * from sepreconferencequestionresponse r
         join sepreconferencequestion q on r.preconferencequestionid=q.preconferencequestionid
         where q.createdbyuserid=
         
         select * from seuserpromptresponse pr
           join seuserprompt p on pr.userpromptid=p.userpromptid
           join seuserpromptresponseentry e on e.userpromptresponseid=pr.userpromptresponseid
           join seevalsession 
           and p.createdbyuserid=158
           and pr.evaluateeid=185
           and p.prompt like 'Did you %'
           
           select * from seevalsession where evalsessionid in (253)
           
           select * from seuserpromptresponseentry 
           where response like '%I adeq%'
           
           select * from seuserpromptresponse pr
             join seuserprompt p on pr.userpromptid=p.userpromptid
             where pr.userpromptresponseid=1085
             
             select * from seuserprompt where userpromptid=200
             
           select * from seuserprompt where createdbyuserid=158
           
           select * from sepreconferencequestion where createdbyuserid=216
           
           select * from seevaluation where schoolyear=2012 and evaluationtypeid=2
           select * from seuserpromptresponse where userpromptid=5 and schoolyear=2012
           
           select * from seuserpromptresponse where userpromptid=6 and schoolyear=2012
           
           select * from sedistrictconfiguration
           select * from seschoolconfiguration
           
           
           
           
  