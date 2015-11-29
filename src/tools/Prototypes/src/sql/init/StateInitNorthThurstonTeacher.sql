--North Thurston Teacher State View

DECLARE @stateFramework  bigint, @fnDestBase bigint, @sourceFramework bigint
select @stateFramework = 16, @sourceFramework = 7
select @fnDestBase = MAX(frameworkNodeID) from SEFrameworkNode


declare @1c bigint select @1c=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1c%'
declare @2b bigint select @2b=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2b%'
declare @2c bigint select @2c=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2c%'
declare @2d bigint select @2d=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2d%'
declare @3a bigint select @3a=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3a%'
declare @3b bigint select @3b=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3b%'
declare @3d bigint select @3d=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3d%'
declare @3e bigint select @3e=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3e%'
declare @4c bigint select @4c=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4c%'
declare @1e bigint select @1e=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1e%'
declare @3c bigint select @3c=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3c%'
declare @1b bigint select @1b=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1b%'
declare @1f bigint select @1f=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1f%'
declare @1a bigint select @1a=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1a%'
declare @2a bigint select @2a=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2a%'
declare @2e bigint select @2e=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2e%'
declare @4a bigint select @4a=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4a%'
declare @4d bigint select @4d=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4d%'
declare @4e bigint select @4e=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4e%'
declare @4f bigint select @4f=rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4f%'


insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C1','C1','Centering instruction on high expectations for student achievement',1,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C2','C2','Demonstrating effective teaching practices',2,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C3','C3','Recognizing individual student learning needs and developing strategies to address those needs',3,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C4','C4','Providing clear and intentional focus on subject matter content and curriculum',4,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C5','C5','Fostering and managing a safe, positive leaning environment',5,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C6','C6','Using multiple student data elements to modify instruction and improve student learning',6,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C7','C7','Communicating with parents and school community',7,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C8','C8','Exhibiting collaborative and collegial practices focus on improving instructional practice and student learning',8,1)

insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1c, @fnDestBase+1, 10 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2b, @fnDestBase+1, 20 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3a, @fnDestBase+1, 30 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3b, @fnDestBase+1, 40 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3d, @fnDestBase+1, 50 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3e, @fnDestBase+1, 60 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4c, @fnDestBase+1, 70 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1e, @fnDestBase+2, 80 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3a, @fnDestBase+2, 90 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3b, @fnDestBase+2, 100)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3c, @fnDestBase+2, 110)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3d, @fnDestBase+2, 120)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1b, @fnDestBase+3, 130)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1c, @fnDestBase+3, 140)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1f, @fnDestBase+3, 150)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3a, @fnDestBase+3, 160)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3b, @fnDestBase+3, 170)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3c, @fnDestBase+3, 180)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3d, @fnDestBase+3, 190)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3e, @fnDestBase+3, 200)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1a, @fnDestBase+4, 210)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1c, @fnDestBase+4, 220)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3a, @fnDestBase+4, 230)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3c, @fnDestBase+4, 240)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3d, @fnDestBase+4, 250)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2a, @fnDestBase+5, 260)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2b, @fnDestBase+5, 264)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2c, @fnDestBase+5, 268)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2d, @fnDestBase+5, 272)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@2e, @fnDestBase+5, 275)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1b, @fnDestBase+6, 280)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@1f, @fnDestBase+6, 290)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@3d, @fnDestBase+6, 300)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4a, @fnDestBase+6, 310)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4c, @fnDestBase+7, 320)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4d, @fnDestBase+8, 330)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4e, @fnDestBase+8, 340)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values (@4f, @fnDestBase+8, 350)
                

