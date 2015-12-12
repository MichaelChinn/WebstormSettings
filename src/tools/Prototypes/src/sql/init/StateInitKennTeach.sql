--kennewick Teacher state view
DECLARE @stateFramework  bigint, @fnDestBase bigint, @sourceFramework bigint
select @stateFramework = 18, @sourceFramework = 6
select @fnDestBase = MAX(frameworkNodeID) from SEFrameworkNode

insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C1','C1','Centering instruction on high expectations for student achievement',1,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C2','C2','Demonstrating effective teaching practices',2,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C3','C3','Recognizing individual student learning needs and developing strategies to address those needs',3,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C4','C4','Providing clear and intentional focus on subject matter content and curriculum',4,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C5','C5','Fostering and managing a safe, positive leaning environment',5,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C6','C6','Using multiple student data elements to modify instruction and improve student learning',6,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C7','C7','Communicating with parents and school community',7,1)
insert seframeworknode (frameworkId, parentNodeID, title, shortname, description, sequence, isLeafnode)values (@stateFramework, null, 'C8','C8','Exhibiting collaborative and collegial practices focus on improving instructional practice and student learning',8,1)


insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 1, 147, 10 ) --Creates a Culture of Learning and Achievement
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 1, 148, 20 ) --Promotes Higher Level Thinking Rigorous Content (ambiguous, complex, provocative, emotionally/personally challenging)
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 2, 140, 30 ) --Plans Activities, Assignments, and Materials
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 2, 141, 40 ) --Knows Subject Matter
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 3, 144, 50 ) --Engages Through Lesson Structure/Delivery, Student Groupings and Pacing
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 3, 145, 60 ) --Responds to Student Learning Needs
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 3, 146, 70 ) --Uses Differentiated Practices &amp; Strategies
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 4, 142, 80 ) --Communicates and Applies Purpose of the Lesson
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 4, 143, 90 ) --Aligns Purpose with Adopted Curriculum and State Standards
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 5, 151, 100) --Manages Routines and Procedures
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 5, 152, 110) --Organizes Physical Space
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 5, 153, 120) --Manages Student Behavior
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 5, 154, 130) --Fosters an Environment of Respect and Rapport
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 6, 149, 140) --Provides Multiple Assessment Opportunities
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 6, 150, 150) --Adjusts Instruction for Students Based on Analysis of Multiple Data Elements
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 7, 158, 160) --Communicates in a Professional Manner
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 7, 159, 170) --Maintains Accurate Record Keeping
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 8, 155, 180) --Collaborates with Staff Members
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 8, 156, 190) --Demonstrates Collegial Practices
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowID, sequence) values (@fnDestBase + 8, 157, 200) --Participates in Professional Growth Opportunities
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
