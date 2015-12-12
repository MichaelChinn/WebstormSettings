select * from sedistrictschool where districtschoolname like '%Cle%'
select * from sedistrictschool where districtcode='19404'

/* 

Need to remove

SEFramework
SEFrameworkNode
SERubricRow
SERubricRowFrameworkNode

No changes needed to
EvaluationMap
Message
MessageHEader
SEArtifact
SEDistrictConfiguration
SEEvalSession
SEEvaluation
SEUserPrompt

select * from evaluationmap

select * from Message m
  join SEUser u on m.SEnderID=u.SEUserID
  where u.DistrictCode='19404'

select * from SEArtifact a
  join stateeval_repo.dbo.repositoryitem ri on a.RepositoryItemID=ri.repositoryitemid
  join SEUser u on ri.ownerid=u.SEUserID
  where u.DistrictCode='19404'
  
select * from sedistrictconfiguration where districtcode='19404'

select * from seevalsession where districtcode='19404'

select * from seevalsession es
  join seuser tor on es.evaluatoruserid=tor.seuserid
  join seuser tee on es.evaluateeuserid=tee.seuserid
  where tor.districtcode='19404' or tee.districtcode='19404'
  
select * from seuserprompt where districtcode='19404'
  */
  