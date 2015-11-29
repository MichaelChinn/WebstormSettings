--have to truncate table first

delete dbo.SEDistrictSchool

insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001', '', 'Seattle SD', 0)

insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA1', 'Seattle SD Dan School 1', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA2', 'Seattle SD Dan School 2', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA3', 'Seattle SD Dan School 3', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA4', 'Seattle SD Dan School 4', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA5', 'Seattle SD Dan School 5', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('17001','SDA6', 'Seattle SD Dan School 6', 1)
