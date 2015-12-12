IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
BEGIN
DROP TABLE dbo.ProtoFrameworksToLoad
END
GO

CREATE TABLE dbo.ProtoFrameworksToLoad (dest VARCHAR(7), src VARCHAR(7), placeName VARCHAR(50)
, schoolYear INT, Leader VARCHAR (10))

go
  



insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL101', 'BCEL', 'ESD101 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL105', 'BCEL', 'ESD105 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL112', 'BCEL', 'ESD112 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL113', 'BCEL', 'ESD113 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL114', 'BCEL', 'ESD114 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL121', 'BCEL', 'ESD121 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL123', 'BCEL', 'ESD123 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL171', 'BCEL', 'ESD171 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CL189', 'BCEL', 'ESD189 CEL SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CLWEA', 'BCEL',  'WEA CEL SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CLOSP', 'BCEL', 'OSPI CEL SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('CLAWS', 'BCEL', 'AWSP CEL SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA101', 'BMAR', 'ESD101 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA105', 'BMAR', 'ESD105 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA112', 'BMAR', 'ESD112 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA113', 'BMAR', 'ESD113 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA114', 'BMAR', 'ESD114 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA121', 'BMAR', 'ESD121 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA123', 'BMAR', 'ESD123 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA171', 'BMAR', 'ESD171 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MA189', 'BMAR', 'ESD189 MAR SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MAWEA', 'BMAR',  'WEA MAR SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MAOSP', 'BMAR', 'OSPI MAR SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('MAAWS', 'BMAR', 'AWSP MAR SD'  , 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA101', 'BDAN', 'ESD101 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA105', 'BDAN', 'ESD105 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA112', 'BDAN', 'ESD112 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA113', 'BDAN', 'ESD113 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA114', 'BDAN', 'ESD114 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA121', 'BDAN', 'ESD121 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA123', 'BDAN', 'ESD123 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA171', 'BDAN', 'ESD171 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DA189', 'BDAN', 'ESD189 DAN SD', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DAWEA', 'BDAN',  'WEA DAN SD  ', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DAOSP', 'BDAN', 'OSPI DAN SD  ', 2013, 'BPRIN')
insert dbo.ProtoFrameworksToLoad (dest, src, placename, schoolYear, leader) values ('DAAWS', 'BDAN', 'AWSP DAN SD  ', 2013, 'BPRIN')