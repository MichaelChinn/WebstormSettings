USE StateEval_PrePro
DROP TABLE marlatest
CREATE TABLE marLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,MarDomain	   VARCHAR(MAX)
,MarShort      VARCHAR(MAX)
,MarDomSeq	   VARCHAR(MAX)
,MarRowSeq     VARCHAR(MAX)
,rowtitle      varchar(max)
,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE marlatest


BULK INSERT marlatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\marlatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw', FIRSTROW=2)


update marlatest set criteria =  replace (criteria, '"', '')
update marlatest set rowtitle =  replace (rowtitle, '"', '')
update marlatest set level1   =  replace (level1  , '"', '')
update marlatest set level2   =  replace (level2  , '"', '')
update marlatest set level3   =  replace (level3  , '"', '')
update marlatest set level4   =  replace (level4  , '"', '')

SELECT * FROM marlatest ORDER BY rowtitle

select criteria from marlatest except select  title from stateeval_proto.dbo.seframeworknode where frameworkID = 38


select rowtitle from marlatest except select  title from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'
select evidence from marlatest except select  description from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'
select level1   from marlatest except select  pl1descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'
select level2   from marlatest except select  pl2descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'
select level3   from marlatest except select  pl3descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'
select level4   from marlatest except select  pl4descriptor   from stateeval_proto.dbo.serubricRow where belongstodistrict = 'bmar'

SELECT distinct rowtitle,  level1, level2, level3, level4 FROM dbo.marLatest
EXCEPT
SELECT title,  pl1descriptor, pl2descriptor, pl3descriptor, pl4descriptor FROM stateeval_proto.dbo.serubricrow 
WHERE BelongsToDistrict='bmar'




