if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN
	-- this version goes in test
	insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('01147','01147',4,'Othello School District',2012)
	insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('34003','34003',4,'North Thurston Public Schools', 2012)
	insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('01147','01147',4,'Othello School District',2013)
	insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('34003','BDAN',4,'North Thurston Public Schools', 2013)
	insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('34003','BPRIN',4,'North Thurston Public Schools', 2013)
	
	--insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('29103','BCEL',4,'Anacortes School district', 2013)
	--insert ProtoFrameworksToLoad (dest, src, nTeachers, placeName, schoolYear) values ('01158','31201',4,'Lind School District', 2012)
END
