GetStateScoreAggregatesTE

select * from SEDistrictSchool 
 where districtSchoolName like '%Othello%'
   And isSchool=1
   
select * from SEFramework 
   
select * from SEDistrictConfiguration where DistrictCode='14005'

select * from SEUser where LastName like '%Anacortes%'


select * from SEFinalScore where evaluateeid=221

select * from SEDistrictConfiguration 
where HasBeenSubmittedToStateTE=0

SELECT * 
  FROM dbo.vDistrictConfiguration
 WHERE DistrictCode='29103'
   AND EvaluationTypeID=1

select * from SEDistrictSchool where isSchool=0

update SEEvaluation 
   set PerformanceLevelID=2
      ,HasBeenSubmitted=1
  from dbo.SEEvaluation fs
  join dbo.SEUser u on fs.EvaluateeID=u.SEUserID
 where fs.EvaluationTypeID=2
    and u.SchoolCode IN (select distinct SchoolCode 
                          from SEDistrictSchool 
						 where districtCode in  ('01147') --('14005', '01147', '29103', '03017', '04246', '22009', '22017', '22200', '22207', '23403', '38267', '31201', '32326', '32356', '32362', '33049', '34003', '29103', '01160')
						   And isSchool=1)
						 
 
 update SESchoolConfiguration 
    set HasBeenSubmittedToDistrictTE=1
       ,SubmissionToDistrictDateTE=GETDATE()
  where SchoolCode IN (select distinct SchoolCode 
                      from SEDistrictSchool 
						 where districtCode in  ('01147')-- ('14005', '01147', '29103', '03017', '04246', '22009', '22017', '22200', '22207', '23403', '38267', '31201', '32326', '32356', '32362', '33049', '34003', '29103', '01160')
						   And isSchool=1)
  
  
  update SEFinalScore 
   set PerformanceLevelID=2
      ,HasBeenSubmitted=1
  from dbo.SEFinalScore fs
  join dbo.SEUser u on fs.EvaluateeID=u.SEUserID
 where fs.EvaluationTypeID=1
    and u.DistrictCode IN (select distinct DistrictCode 
                          from SEDistrictSchool 
						 where districtCode in  ('14005', '01147', '29103', '03017', '04246', '22009', '22017', '22200', '22207', '23403', '38267', '31201', '32326', '32356', '32362', '33049', '34003', '29103', '01160')
						   And isSchool=0)

  update SEDistrictConfiguration
     set HasBeenSubmittedToStatePE=1
        ,SubmissionToStateDatePE=GETDATE()
	where districtCode in  ('14005', '01147', '29103', '03017', '04246', '22009', '22017', '22200', '22207', '23403', '38267', '31201', '32326', '32356', '32362', '33049', '34003', '29103', '01160')
      
      
      select * from SEFinalScore where PerformanceLevelID=2
      
      select * from SEUser where SEUserID=186
      
      
      		 


