if EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') 
AND type in (N'U'))

BEGIN
	/*
select * from stateeval_proto.dbo.seframeworkcontext

FrameworkContextID	Name	SchoolYear	EvaluationTypeID	StateFrameworkID	InstructionalFrameworkID
1	Danielson Teacher Framework	2015	2	54	55
2	Danielson Teacher Framework	2016	2	64	65
3	CEL Teacher Framework	2015	2	56	57
4	CEL Teacher Framework	2016	2	66	67
5	Marzano Teacher Framework	2015	2	58	61
6	Marzano Teacher Framework	2016	2	68	71
7	Marzano Principal Framework	2015	1	62	63
8	Marzano Principal Framework	2016	1	72	73
9	Leadership Principal Framework	2015	1	59	NULL
10	Leadership Principal Framework	2016	1	69	NULL
11	Test Librarian Framework	2016	3	74	75
*/


	-- Librarian Frameworks
	-- 2016
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(11, '34003', 'North Thurston Public Schools', 4)
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(11, '29317', 'Conway School District', 4)
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(11, '21302', 'Chehalis School District', 4)
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(11, '01147', 'Othello School District', 4)

	-- Teacher Frameworks

	-- 2015
    insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(1, '01147', 'Othello School District', 4)
	-- Danielson
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(1, '34003', 'North Thurston Public Schools', 4)
	-- Marzano
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(5, '29317', 'Conway School District', 4)
	-- CEL
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(3, '21302', 'Chehalis School District', 4)

	-- 2016
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(2, '01147', 'Othello School District', 4)
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(2, '34003', 'North Thurston Public Schools', 4)

	-- Principal Frameworks

	-- 2015
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(9, '01147', 'Othello School District', 4)
	-- Danielson
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(9, '34003', 'North Thurston Public Schools', 4)
	-- Marzano
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(7, '29317', 'Conway School District', 4)

	--Leadership framework
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(9, '21302', 'Chehalis School District', 4)

	-- 2016
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(10, '01147', 'Othello School District', 4)
	insert ProtoFrameworkContextsToLoad(FrameworkContextID, DistrictCode, PlaceName, nTeachers) values(10, '34003', 'North Thurston Public Schools', 4)
	
END
