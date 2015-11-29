if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN
	-- the effect of the conditional above should be never to do this on prod..
	insert dbo.ProtoFrameworksToLoad (dest, src, nTeachers, placeName, SchoolYear) values ('29103','29103',4,'Anacortes School District',2012)
	insert dbo.ProtoFrameworksToLoad (dest, src, nTeachers, placeName, SchoolYear) values ('01147','01147',4,'Othello School District',2012)
	insert dbo.ProtoFrameworksToLoad (dest, src, nTeachers, placeName, SchoolYear) values ('34003','34003',4,'North Thurston Public Schools',2012)
	insert dbo.ProtoFrameworksToLoad (dest, src, nTeachers, placeName, SchoolYear) values ('38267','00000',4,'Pullman School District',2012)
	insert dbo.ProtoFrameworksToLoad (dest, src, nTeachers, placeName, SchoolYear) values ('23403','bmarPr',4,'NorthMason School District',2013)


END