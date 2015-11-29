DROP TABLE awsplatest


CREATE TABLE awspLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,rowtitle      varchar(max)
--,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE awspLatest

BULK INSERT awspLatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\awspLatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw', FIRSTROW=2)


update awspLatest set criteria = rtrim('Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district learning goals.                             ') where criteria = '"Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district learning goals."'                             
update awspLatest set criteria = rtrim('Leading development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements.') where criteria = '"Leading development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements."'
update awspLatest set criteria = rtrim('Monitoring, assisting and evaluating effective instruction and assessment practices.                                                                             ') where criteria = '"Monitoring, assisting and evaluating effective instruction and assessment practices."'                                                                             
     

update awspLatest set criteria =  replace (criteria, '"', '')
update awspLatest set rowtitle =  replace (rowtitle, '"', '')
update awspLatest set level1   =  replace (level1  , '"', '')
update awspLatest set level2   =  replace (level2  , '"', '')
update awspLatest set level3   =  replace (level3  , '"', '')
update awspLatest set level4   =  replace (level4  , '"', '')

select criteria from awsplatest except select  title from stateeval_proto.dbo.seframeworknode where frameworkID = 39


select rowtitle from awspLatest except select  title from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bprin'
select level1   from awspLatest except select  pl1descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bprin'
select level2   from awspLatest except select  pl2descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bprin'
select level3   from awspLatest except select  pl3descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bprin'
select level4   from awspLatest except select  pl4descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bprin'

SELECT distinct rowtitle,  level1, level2, level3, level4 FROM dbo.awsplatest
EXCEPT
SELECT title,  pl1descriptor, pl2descriptor, pl3descriptor, pl4descriptor FROM stateeval_proto.dbo.serubricrow 
WHERE BelongsToDistrict='bprin'

