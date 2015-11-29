	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.ProtoFrameworksToLoad (dest VARCHAR(7), src VARCHAR(7), placeName VARCHAR(50), schoolYear INT)
END
	go

	insert dbo.ProtoFrameworksToLoad (dest, src, placeName, SchoolYear) values ('CELDS','BCEL','UW CEL District',2013)
	insert dbo.ProtoFrameworksToLoad (dest, src, placeName, SchoolYear) values ('DANDS','BDAN','Danielson District',2013)
	insert dbo.ProtoFrameworksToLoad (dest, src, placeName, SchoolYear) values ('MARDS','BMAR','Marzanno District',2013)
	
	