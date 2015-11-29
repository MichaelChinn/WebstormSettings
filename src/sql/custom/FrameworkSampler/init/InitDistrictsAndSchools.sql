
--have to truncate table first
TRUNCATE TABLE dbo.SEDistrictSchool


-- stuff only the districts into the seDistrictSchool table

insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT districtCode
, ''
, RTRIM(districtSchoolName), 0
from StateEval_Proto.dbo.CDS_Latest WHERE schoolType = 'd'  
ORDER BY districtSchoolName

SELECT * FROM stateeval_proto.dbo.cds_latest WHERE districtSchoolName NOT LIKE '%sd' AND schooltype = 'd'
SELECT * FROM stateeval_proto.dbo.cds_latest WHERE districtSchoolName LIKE 'renton%'

UPDATE dbo.SEDistrictSchool SET districtSchoolName  = 'North Thurston SD' WHERE districtcode = '34003' AND isSchool = 0
UPDATE dbo.SEDistrictSchool SET districtSchoolName  = 'Seattle SD' WHERE districtcode = '17001' AND isSchool = 0

--create five schools for each district
CREATE TABLE #ss (ssname VARCHAR (20))
INSERT #SS (SSNAME) VALUES ('School 1')
INSERT #SS (SSNAME) VALUES ('School 2')
INSERT #SS (SSNAME) VALUES ('School 3')
INSERT #SS (SSNAME) VALUES ('School 4')
INSERT #SS (SSNAME) VALUES ('School 5')

CREATE TABLE #full (ssname varchar (200), districtCode VARCHAR (5), schoolCOde int)
INSERT #full (ssname, districtcode, schoolCode)
SELECT RTRIM(districtSchoolName) + ' ' + ssname, ds.districtcode,
ROW_NUMBER() OVER (ORDER BY ssname)
FROM  dbo.seDistrictSchool ds
JOIN #ss s ON 1=1



insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)

SELECT DistrictCode
, RIGHT(REPLICATE('0', 4)+ CAST(schoolCode AS VARCHAR(4)), 4) PaddedCode
, ssname, 1
FROM #full
ORDER BY ssname 
