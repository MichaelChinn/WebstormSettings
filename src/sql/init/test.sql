select * from vUserOrientation where seuserid=39

select * from seuser where lastname like '%North Thurston%'

select * from seuser where seuserid=48

update seevaluation set evaluatorid=39 where evaluateeid=61
select * from sewfstate

select * from sedistrictschool where districtcode='21302'

delete seartifactbundle
select * from seartifactbundle

select * from seevalsession

exec AssignEvaluatorToEvaluatee  @pEvaluateeUserID =82,@pEvaluatorUserID=48, @pEvaluationTypeID = 2, @pSchoolYear=2016, @pDistrictCode='21302'

select u.* from seevaluation e
  join seuser u on e.evaluateeid=u.seuserid
  where e.EvaluatorID IS NULL

  select * from seevaluation where evaluateeid=92
  select seuserid, username, districtcode, count(schoolcode) from SEUserLocationRole 
  where schoolcode='3010'
  group by seuserid, username, districtcode

  select * from seuserlocationrole where username like '%TMS%'
  select * from seuser where username like '34003_%' OR username like '3010_%' order by username

  select * from seuserlocationrole where SEUserID=58
  select * from seuser where seuserid=92

  select * from sedistrictschool where schoolcode='2754'

  select * from SEFrameworkContext

select * from SEUserLocationRole where SchoolCode=1559

select * from vUserOrientation where seuserid=58
select * from SELinkedItemType
select * from serubricrowscore
select * from seframeworknodescore

delete serubricrowscore



