delete MessageHeader where MessageID=17723
delete MessageHeader where MessageID=17724
delete MessageHeader where MessageID=12601
delete MessageHeader where MessageID=22772
delete MessageHeader where MessageID=20866
delete MessageHeader where MessageID=21527
delete MessageHeader where MessageID=22076
delete MessageHeader where MessageID=22077
delete MessageHeader where MessageID=22078
delete MessageHeader where MessageID=18716
delete MessageHeader where MessageID=20295
delete MessageHeader where MessageID=20296
delete MessageHeader where MessageID=20297
delete MessageHeader where MessageID=20299
delete MessageHeader where MessageID=20294
delete MessageHeader where MessageID=21405
delete MessageHeader where MessageID=21406
delete MessageHeader where MessageID=19739
delete MessageHeader where MessageID=19744
delete MessageHeader where MessageID=19715
delete MessageHeader where MessageID=19716
delete MessageHeader where MessageID=19732
delete MessageHeader where MessageID=19733
delete MessageHeader where MessageID=24337
delete MessageHeader where MessageID=12804
delete MessageHeader where MessageID=12805
delete MessageHeader where MessageID=12806
delete MessageHeader where MessageID=14083
delete MessageHeader where MessageID=11034
delete MessageHeader where MessageID=11027
delete MessageHeader where MessageID=24557
delete MessageHeader where MessageID=24558
delete MessageHeader where MessageID=24559
delete MessageHeader where MessageID=24560
delete MessageHeader where MessageID=24561
delete MessageHeader where MessageID=24562
delete MessageHeader where MessageID=24563
delete MessageHeader where MessageID=24564
delete MessageHeader where MessageID=24565
delete MessageHeader where MessageID=24568
delete MessageHeader where MessageID=24610
delete MessageHeader where MessageID=24611
delete MessageHeader where MessageID=24612
delete MessageHeader where MessageID=24556
delete MessageHeader where MessageID=24566
delete MessageHeader where MessageID=24567
delete MessageHeader where MessageID=24571
delete MessageHeader where MessageID=24609

delete Message where MessageID=17723
delete Message where MessageID=17724
delete Message where MessageID=12601
delete Message where MessageID=22772
delete Message where MessageID=20866
delete Message where MessageID=21527
delete Message where MessageID=22076
delete Message where MessageID=22077
delete Message where MessageID=22078
delete Message where MessageID=18716
delete Message where MessageID=20295
delete Message where MessageID=20296
delete Message where MessageID=20297
delete Message where MessageID=20299
delete Message where MessageID=20294
delete Message where MessageID=21405
delete Message where MessageID=21406
delete Message where MessageID=19739
delete Message where MessageID=19744
delete Message where MessageID=19715
delete Message where MessageID=19716
delete Message where MessageID=19732
delete Message where MessageID=19733
delete Message where MessageID=24337
delete Message where MessageID=12804
delete Message where MessageID=12805
delete Message where MessageID=12806
delete Message where MessageID=14083
delete Message where MessageID=11034
delete Message where MessageID=11027
delete Message where MessageID=24557
delete Message where MessageID=24558
delete Message where MessageID=24559
delete Message where MessageID=24560
delete Message where MessageID=24561
delete Message where MessageID=24562
delete Message where MessageID=24563
delete Message where MessageID=24564
delete Message where MessageID=24565
delete Message where MessageID=24568
delete Message where MessageID=24610
delete Message where MessageID=24611
delete Message where MessageID=24612
delete Message where MessageID=24556
delete Message where MessageID=24566
delete Message where MessageID=24567
delete Message where MessageID=24571
delete Message where MessageID=24609

delete SEDistrictConfiguration 
 where DistrictCode='17407'
   and SchoolYear=2014
   and EvaluationTypeID=1
   
 delete SESchoolConfiguration 
 where DistrictCode='17407'
   and SchoolYear=2014
   
DECLARE @sql_Error_message VARCHAR(200) 
EXEC RemoveEvalSession 26199, @sql_Error_message output 
EXEC RemoveEvalSession 35243, @sql_Error_message output 
EXEC RemoveEvalSession 36102, @sql_Error_message output 

UPDATE e
   SET e.FocusedFrameworkNodeID=NULL
      ,e.FocusedSGFrameworkNodeID=NULL
  FROM SEEvaluation e
  WHERE e.EvaluationTypeID=1
   AND e.SchoolYear=2014
   AND e.DIstrictCode='17407'
   AND e.FocusedFrameworkNodeID IS NOT NULL
   
   exec FlushFramework '17407', 1, 2014, 1
   
   
   
      