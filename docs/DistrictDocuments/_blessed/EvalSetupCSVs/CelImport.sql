USE StateEval_PrePro
DROP TABLE celIFWLatest

CREATE TABLE celIFWLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,rowtitle      varchar(max)
,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE celIFWLatest

BULK INSERT celIFWLatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\celIFWLatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw')

UPDATE celIFWLatest SET
level1 = REPLACE (level1, '"', '')
,level2 = REPLACE (level2, '"', '')
,level3 = REPLACE (level3, '"', '')
,level4 = REPLACE (level4, '"', '')


USE StateEval_PrePro
DROP TABLE celStateLatest

CREATE TABLE celStateLatest
(criteria      varchar(max) 
,critshortname varchar(max)
,sequence      varchar(max)
,rowtitle      varchar(max)
,evidence      VARCHAR(MAX)
,level1        varchar(max)
,level2        varchar(max)
,level3        varchar(max)
,level4        varchar(max))
TRUNCATE TABLE celStateLatest

BULK INSERT celStateLatest
FROM 'D:\dev\SE\seTrunk\docs\DistrictDocuments\_blessed\EvalSetupCSVs\celStateLatest.txt'
WITH (fieldTerminator='\t', CODEPAGE='raw')

SELECT criteria FROM celstatelatest WHERE criteria LIKE '"%'
SELECT rowtitle FROM celstatelatest WHERE rowtitle LIKE '"%'
SELECT evidence FROM celstatelatest WHERE evidence LIKE '"%'

SELECT level1 FROM celstatelatest WHERE level1 LIKE '"%'
SELECT level2 FROM celstatelatest WHERE level2 LIKE '"%'
SELECT level3 FROM celstatelatest WHERE level3 LIKE '"%'
SELECT level4 FROM celstatelatest WHERE level4 LIKE '"%'

UPDATE celStateLatest SET
criteria = REPLACE (criteria, '"', '')
,rowtitle = REPLACE (rowtitle, '"', '')
,evidence = REPLACE(evidence,'"', '')
,level1 = REPLACE (level1, '"', '')
,level2 = REPLACE (level2, '"', '')
,level3 = REPLACE (level3, '"', '')
,level4 = REPLACE (level4, '"', '')

UPDATE celIFWLatest SET
criteria = REPLACE (criteria, '"', '')
,rowtitle = REPLACE (rowtitle, '"', '')
,evidence = REPLACE(evidence,'"', '')
,level1 = REPLACE (level1, '"', '')
,level2 = REPLACE (level2, '"', '')
,level3 = REPLACE (level3, '"', '')
,level4 = REPLACE (level4, '"', '')



SELECT * FROM celIFWLatest i
JOIN celStateLatest s ON 
s.level1 =i.level1 AND
s.level2 = i.level2 AND
s.level3 = i.level3 AND
s.level4 = i.level4 
