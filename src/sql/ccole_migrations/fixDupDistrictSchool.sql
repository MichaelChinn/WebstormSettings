/*

SELECT schoolcode, COUNT(*) FROM dbo.cds_1216
GROUP BY schoolcode
ORDER BY COUNT(*) ASC

SELECT schoolcode, COUNT(*) FROM dbo.SEDistrictSchool
GROUP BY schoolcode
ORDER BY COUNT(*) ASC

SELECT * FROM sedistrictschool WHERE schoolcode IN ('1952', '1955', '1782', '4068') order by schoolCode
SELECT * FROM sedistrictschool WHERE schoolcode IN ('0029', '0033', '0037', '0041') order by schoolCode

select * from sedistrictschool where districtcode='00025'
*/

-- These ones have different districts same schoolCode
DELETE sedistrictschool WHERE districtCode='17401' AND schoolcode IN ('1952', '1955', '1782', '4068')

-- These ones are complete dups, same district/schoolcodes
DELETE sedistrictschool WHERE districtCode='00025' AND schoolcode IN ('', '0029', '0033', '0037', '0041')

INSERT SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
VALUES('00025', '', 'North Adams Community Schools', 0, 0)

INSERT SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
VALUES('00025', '0029', 'Belmont High School', 1, 1)

INSERT SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
VALUES('00025', '0033', 'Belmont Middle School', 1, 0)

INSERT SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
VALUES('00025', '0037', 'Northwest Elementary', 1, 0)

INSERT SEDistrictSchool(districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)
VALUES('00025', '0041', 'Southeast Elementary', 1, 0)



