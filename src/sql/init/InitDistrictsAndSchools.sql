insert dbo.SEDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool)
SELECT districtCode, schoolCode, ExtendedDistrictSchoolName
	,CASE when SchoolType = 'd' or SchoolType = 'e' then 0 else 1 end
from StateEval_Proto.dbo.CDS_Latest


update dbo.SEDistrictSchool set IsSecondary=0
