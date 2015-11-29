--consortium teacher self state view

DECLARE @stateFramework  bigint, @fnDestBase bigint, @sourceFramework bigint
select @sourceFramework = 21
select @fnDestBase = MAX(frameworkNodeID) from SEFrameworkNode

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) 
VALUES('Con State TSelf', 'Consortium state view, Teacher Self', '', 2012, 5
			, 1, null, 0, 1, 1)
SELECT @stateFramework = SCOPE_IDENTITY()

insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C1','C1','Centering instruction on high expectations for student achievement',1,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C2','C2','Demonstrating effective teaching practices',2,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C3','C3','Recognizing individual student learning needs and developing strategies to address those needs',3,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C4','C4','Providing clear and intentional focus on subject matter content and curriculum',4,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C5','C5','Fostering and managing a safe, positive leaning environment',5,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C6','C6','Using multiple student data elements to modify instruction and improve student learning',6,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C7','C7','Communicating with parents and school community',7,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C8','C8','Exhibiting collaborative and collegial practices focus on improving instructional practice and student learning',8,1)


insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (531,	@fnDestBase + 1, 10 ) --1c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (536,	@fnDestBase + 1, 20 ) --2b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (540,	@fnDestBase + 1, 30 ) --3a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (541,	@fnDestBase + 1, 40 ) --3b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (543,	@fnDestBase + 1, 50 ) --3d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (544,	@fnDestBase + 1, 60 ) --3e
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (547,	@fnDestBase + 1, 70 ) --4c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (533,	@fnDestBase + 2, 80 ) --1e
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (540,	@fnDestBase + 2, 90 ) --3a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (541,	@fnDestBase + 2, 100) --3b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (542,	@fnDestBase + 2, 110) --3c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (543,	@fnDestBase + 2, 120) --3d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (530,	@fnDestBase + 3, 130) --1b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (531,	@fnDestBase + 3, 140) --1c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (534,	@fnDestBase + 3, 150) --1f
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (540,	@fnDestBase + 3, 160) --3a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (541,	@fnDestBase + 3, 170) --3b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (542,	@fnDestBase + 3, 180) --3c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (543,	@fnDestBase + 3, 190) --3d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (544,	@fnDestBase + 3, 200) --3e
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (529,	@fnDestBase + 4, 210) --1a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (531,	@fnDestBase + 4, 220) --1c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (540,	@fnDestBase + 4, 230) --3a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (542,	@fnDestBase + 4, 240) --3c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (543,	@fnDestBase + 4, 250) --3d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (535,	@fnDestBase + 5, 260) --2a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (536,	@fnDestBase + 5, 270) --2b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (537,	@fnDestBase + 5, 280) --2c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (538,	@fnDestBase + 5, 290) --2d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (539,	@fnDestBase + 5, 300) --2e
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (530,	@fnDestBase + 6, 310) --1b
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (534,	@fnDestBase + 6, 320) --1f
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (543,	@fnDestBase + 6, 330) --3d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (545,	@fnDestBase + 6, 340) --4a
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (547,	@fnDestBase + 7, 350) --4c
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (548,	@fnDestBase + 8, 360) --4d
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (549,	@fnDestBase + 8, 370) --4e
insert seRubricRowFrameworkNode(rubricRowID, frameworkNodeID, sequence) values (550,	@fnDestBase + 8, 380) --4f