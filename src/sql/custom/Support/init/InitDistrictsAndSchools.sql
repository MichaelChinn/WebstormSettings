
--insert othello and north thurston school districts first
insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT districtCode, schoolCode, ExtendedDistrictSchoolName, 0
from StateEval_Proto.dbo.CDS_Latest
WHERE districtcode IN ('01147', '34003') AND schoolcode=''


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT TOP 2 cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode <> '' AND districtCode = '34003'


insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT  cds.districtCode, cds.schoolCode, ExtendedDistrictSchoolName, 1
from StateEval_Proto.dbo.CDS_Latest cds
WHERE schoolCode IN ('3015', '3730')



