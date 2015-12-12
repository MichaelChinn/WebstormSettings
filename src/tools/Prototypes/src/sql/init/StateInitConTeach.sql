--consortium teacher state view
DECLARE @stateFramework  bigint, @fnDestBase bigint, @sourceFramework bigint
select @stateFramework = 17, @sourceFramework = 4
select @fnDestBase = MAX(frameworkNodeID) from SEFrameworkNode

declare @1b bigint select @1b = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1b%'
declare @1c bigint select @1c = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1c%'
declare @1f bigint select @1f = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '1f%'
declare @2a bigint select @2a = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2a%'
declare @2b bigint select @2b = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2b%'
declare @2c bigint select @2c = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '2c%'
declare @3b bigint select @3b = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3b%'
declare @3c bigint select @3c = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3c%'
declare @3d bigint select @3d = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '3d%'
declare @4a bigint select @4a = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4a%'
declare @4c bigint select @4c = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4c%'
declare @4d bigint select @4d = rubricRowID from vRowsInFramework where frameworkID = @sourceFramework and title like '4d%'
  
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C1','C1','Centering instruction on high expectations for student achievement',1,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C2','C2','Demonstrating effective teaching practices',2,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C3','C3','Recognizing individual student learning needs and developing strategies to address those needs',3,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C4','C4','Providing clear and intentional focus on subject matter content and curriculum',4,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C5','C5','Fostering and managing a safe, positive leaning environment',5,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C6','C6','Using multiple student data elements to modify instruction and improve student learning',6,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C7','C7','Communicating with parents and school community',7,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C8','C8','Exhibiting collaborative and collegial practices focus on improving instructional practice and student learning',8,1)


insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1c	,@fnDestBase+1	,10 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@2b	,@fnDestBase+1	,20 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3b	,@fnDestBase+1	,30 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3d	,@fnDestBase+1	,40 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@4c	,@fnDestBase+1	,50 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3b	,@fnDestBase+2	,60 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3c	,@fnDestBase+2	,70 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3d	,@fnDestBase+2	,80 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1b	,@fnDestBase+3	,90 )
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1c	,@fnDestBase+3	,100)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1f	,@fnDestBase+3	,110)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3b	,@fnDestBase+3	,120)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3c	,@fnDestBase+3	,130)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3d	,@fnDestBase+3	,140)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1c	,@fnDestBase+4	,150)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3c	,@fnDestBase+4	,160)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3d	,@fnDestBase+4	,170)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@2a	,@fnDestBase+5	,180)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@2b	,@fnDestBase+5	,190)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@2c	,@fnDestBase+5	,200)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1b	,@fnDestBase+6	,220)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@1f	,@fnDestBase+6	,230)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@3d	,@fnDestBase+6	,240)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@4a	,@fnDestBase+6	,250)
insert seRubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence) values(@4c	,@fnDestBase+7	,260)
