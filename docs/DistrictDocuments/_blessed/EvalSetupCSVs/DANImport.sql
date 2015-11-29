USE StateEval_PrePro
DROP TABLE danIFWlatest

CREATE TABLE danIFWLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,rowtitle      varchar(max)
,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE danIFWLatest

BULK INSERT danIFWLatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\danIFWLatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw')

UPDATE danIFWlatest SET
level1 = REPLACE (level1, '"', '')
,level2 = REPLACE (level2, '"', '')
,level3 = REPLACE (level3, '"', '')
,level4 = REPLACE (level4, '"', '')


USE StateEval_PrePro
DROP TABLE danStatelatest

CREATE TABLE danStateLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,rowtitle      varchar(max)
,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE danStateLatest

BULK INSERT danStateLatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\danStateLatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw', FIRSTROW=2)

UPDATE danStatelatest SET
rowtitle = REPLACE (rowtitle, '"', '')
,criteria = REPLACE(criteria, '"', '')
,level1 = REPLACE (level1, '"', '')
,level2 = REPLACE (level2, '"', '')
,level3 = REPLACE (level3, '"', '')
,level4 = REPLACE (level4, '"', '')

SELECT * FROM danifwlatest i
JOIN danstatelatest s ON 
s.level1 =i.level1 AND
s.level2 = i.level2 AND
s.level3 = i.level3 AND
s.level4 = i.level4 

--state criteria text
select criteria from danstatelatest except select  title from stateeval_proto.dbo.seframeworknode where frameworkID = 34


select rowtitle from danstatelatest except select  title from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'
select evidence from danstatelatest except select  description from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'
select level1   from danstatelatest except select  pl1descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'
select level2   from danstatelatest except select  pl2descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'
select level3   from danstatelatest except select  pl3descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'
select level4   from danstatelatest except select  pl4descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bdan'

SELECT rowtitle, evidence, level1, level2, level3, level4 FROM dbo.danStateLatest
EXCEPT
SELECT title, DESCRIPTION, pl1descriptor, pl2descriptor, pl3descriptor, pl4descriptor FROM stateeval_proto.dbo.serubricrow 
WHERE BelongsToDistrict='bdan'

update stateeval_proto.dbo.serubricRow set pl1descriptor = rtrim('Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential.  Goals do not identify multiple, high quality sources of data to monitor, adjust, and evaluate achievement of goals.'), pl2descriptor=rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals rely on limited source or low-quality data to monitor, adjust, and evaluate achievement of goals.   ') where belongstodistrict = 'bdan' and title ='SG 3.1 Establish Student Growth Goal(s)'
update stateeval_proto.dbo.serubricRow set pl1descriptor = rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.                                                                                                                                                     '), pl2descriptor=rtrim('Multiple sources of growth or achievement data from at least two points in time show some evidence of growth for some students.                                                                                         ') where belongstodistrict = 'bdan' and title ='SG 3.2 Achievement of Student Growth Goal(s)'
update stateeval_proto.dbo.serubricRow set pl1descriptor = rtrim('Does not establish student growth goals or establishes inappropriate goals for whole classroom.  Goals do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.                                           '), pl2descriptor=rtrim('Establishes appropriate student growth goals for whole classroom.  Goals rely on limited sources of data or low quality sources of data to monitor, adjust, and evaluate achievement of goals.                          ') where belongstodistrict = 'bdan' and title ='SG 6.1 Establish Student Growth Goal(s)'
update stateeval_proto.dbo.serubricRow set pl1descriptor = rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.                                                                                                                                                     '), pl2descriptor=rtrim('Multiple sources of growth or achievement data from at least two points in time show some evidence of growth for some students.                                                                                         ') where belongstodistrict = 'bdan' and title ='SG 6.2 Achievement of Student Growth Goal(s)'
update stateeval_proto.dbo.serubricRow set pl1descriptor = rtrim('Does not collaborate or reluctantly collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.       '), pl2descriptor=rtrim('Does not consistently collaborate with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, measures, to monitor growth and achievement during the year.') where belongstodistrict = 'bdan' and title ='SG 8.1 Establish Student Growth Goals, Implement and Monitor Growth'



