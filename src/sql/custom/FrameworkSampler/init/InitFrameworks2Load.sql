IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
BEGIN
DROP TABLE dbo.ProtoFrameworksToLoad
END
GO

CREATE TABLE dbo.ProtoFrameworksToLoad (dest VARCHAR(7), src VARCHAR(7), placeName VARCHAR(50)
, schoolYear INT, Leader VARCHAR (10))

go


insert dbo.ProtoFrameworksToLoad(schoolYear, leader, src, dest, placename) values (2013, 'bprin','bCEL', '11051', 'North Franklin School District')
insert dbo.ProtoFrameworksToLoad(schoolYear, leader, src, dest, placename) values (2013, 'bprin','bMAR', '18400', 'North Kitsap School District')
insert dbo.ProtoFrameworksToLoad(schoolYear, leader, src, dest, placename) values (2013, 'bMARPR','bDAN', '23403', 'North Mason School District')
insert dbo.ProtoFrameworksToLoad(schoolYear, leader, src, dest, placename) values (2013, 'bprin','bMAR', '01109', 'Washtucna School District')
insert dbo.ProtoFrameworksToLoad(schoolYear, leader, src, dest, placename) values (2013, 'prWEN','bMAR', '04246', 'Wenatchee School District')