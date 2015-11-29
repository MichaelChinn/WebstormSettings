
--esd 'districts' and 'schools'
                                                                                                                                      
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '', 'CEL School District', 0)   
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '', 'DAN School District', 0)   
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '', 'MAR School District', 0)   
                                                                                                                                      
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '101C', 'ESD 101 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '105C', 'ESD 105 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '112C', 'ESD 112 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '113C', 'ESD 113 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '114C', 'ESD 114 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '121C', 'ESD 121 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '123C', 'ESD 123 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '171C', 'ESD 171 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('CELDS', '189C', 'ESD 189 CEL School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '101D', 'ESD 101 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '105D', 'ESD 105 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '112D', 'ESD 112 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '113D', 'ESD 113 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '114D', 'ESD 114 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '121D', 'ESD 121 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '123D', 'ESD 123 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '171D', 'ESD 171 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('DANDS', '189D', 'ESD 189 DAN School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '101M', 'ESD 101 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '105M', 'ESD 105 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '112M', 'ESD 112 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '113M', 'ESD 113 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '114M', 'ESD 114 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '121M', 'ESD 121 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '123M', 'ESD 123 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '171M', 'ESD 171 MAR School', 1)
insert dbo.seDistrictSchool (districtCode, schoolCode, districtSchoolName, IsSchool) values ('MARDS', '189M', 'ESD 189 MAR School', 1)


update dbo.SEDistrictSchool set IsSecondary=0
