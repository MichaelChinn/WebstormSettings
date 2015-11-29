--have to truncate table first
TRUNCATE TABLE dbo.SEDistrictSchool

--insert othello and north thurston school districts first
insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT districtCode, schoolCode, ExtendedDistrictSchoolName, 0
from StateEval_Proto.dbo.CDS_Latest
WHERE districtcode IN ('01147', '34003', '29317', '21302') AND schoolcode=''


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT TOP 2 cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode <> '' AND districtCode = '34003' AND schoolcode <> '0001'


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT  cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode <> '' AND districtCode = '01147' AND schoolcode <> '0001'


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT  cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode <> '' AND districtCode = '29317' AND schoolcode <> '0001'


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT  cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode <> '' AND districtCode = '21302' AND schoolcode <> '0001'




