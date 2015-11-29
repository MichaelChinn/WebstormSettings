



delete SERubricRowFrameworkNode where RubricRowID in 
(
select rubricRowID from seRubricRow where BelongsToDistrict = '03017'
)
delete SERubricRow where BelongsToDistrict='03017'
delete SEFrameworkNode where FrameworkID in (5, 6, 18, 19)


insert SERubricRow (Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor
,PL4Descriptor, ev1, ev2, ev3, ev4, BelongsToDistrict)
select title,'', isNull(pl1, ''), isNull(pl2, ''), isNull(pl3,''), isNull(pl4, '')
, e1, e2, e3, e4, '03017' from stateeval_prePro.dbo.kenPrinIFW_rr

insert SERubricRow (Title, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor
,PL4Descriptor, ev1, ev2, ev3, ev4, BelongsToDistrict)
select title,'', isNull(pl1, ''), isNull(pl2, ''), isNull(pl3,''), isNull(pl4, '')
, e1, e2, e3, e4, '03017' from stateeval_prePro.dbo.kenTeacherIFW_rr



declare @iP bigint, @iT bigint, @sP bigint, @sT bigint
select @iP = 5, @iT=6, @sT=18, @sP=19
select * from SEFramework

insert seframeworknode (FrameworkID, parentNodeID, title, shortname, description, sequence, isLeafnode)
select @sP, parentNodeID, title, shortname, description, sequence, isLeafNode 
from SEFrameworkNode where FrameworkID = 8


insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C1', 1, 1,'Centering instruction on high expectations for student achievement', 'PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C2', 2, 1,'Demonstrating effective teaching practices', 'INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C3', 3, 1,'Recognizing individual student learning needs and developing strategies to address those needs', 'REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C4', 4, 1,'Providing clear and intentional focus on subject matter content and curriculum', 'CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C5', 5, 1,'Fostering and managing a safe, positive leaning environment', 'CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C6', 6, 1,'Using multiple student data elements to modify instruction and improve student learning', 'ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C7', 7, 1,'Communicating with parents and school community', 'PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description)values (@sT, null, 'C8', 8, 1,'Exhibiting collaborative and collegial practices focus on improving instructional practice and student learning', 'PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.')
                                                                                           
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K1', 1, 1, 'Creating a Culture: Improvement','Creating a School Culture that Promotes the Ongoing Improvement of Learning and Teaching for Students and Staff - Improvement of Learning and Teaching for Students and Staff'	)		
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K2', 2, 1, 'Creating a Culture: Safety','Creating a School Culture that Promotes the Ongoing Improvement of Learning and Teaching for Students and Staff - Ensuring School Safety: Providing for School Safety')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K3', 3, 1, 'Creating a Culture: Improvement','Creating a School Culture that Promotes the Ongoing Improvement of Learning and Teaching for Students and Staff - Improving Instruction: Monitoring, Assisting and Evaluating Effective Instruction and Assessment Practices')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K4', 4, 1, 'Creating a Culture: Alignment','Creating a School Culture that Promotes the Ongoing Improvement of Learning and Teaching for Students and Staff - Aligning Curriculum: Assisting Instructional Staff with Alignment of Curriculum, Instruction and Assessment with State and Local District Learning Goals')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K5', 5, 1, 'Managing Resources',' Managing Both Staff and Fiscal Resources to Support Student Achievement and Legal Responsibilities')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K6', 6, 1, 'Planning with Data','Leads Development, Implementation and Evaluation of a Data-Driven Plan for Increasing Student Achievement, Including the Use of Multiple Student Data Elements')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K7', 7, 1, 'Engaging Communities','Partnering with the School Community to promote Student Learning')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iP, null,'K8', 8, 1, 'Closing the Gap','Commitment to Closing the Achievement Gap')
                                                                                           
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K1', 1, 1, 'Instructional Skill - Planning and Preparation', 'Instructional Skill - Planning and Preparation:  Demonstrating Effective Teaching Practices')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K2', 2, 1, 'Instructional Skill - Purpose','  Provides Clear and Intentional Focus on Subject Matter Content and Curriculum')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K3', 3, 1, 'Instructional Skill - Engagement','  Recognizing Individual Student Learning Needs and Developing Strategies to Address Those Needs')
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K4', 4, 1, 'Instructional Skill - Rigor','  Centering Instruction on High Expectations for Student Achievement')	
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K5', 5, 1, 'Instructional Skill - Results',' Using Multiple Student Data Elements to Modify Instruction and Improve Student Learning')		
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K6', 6, 1, 'Classroom Management',' Fostering and Managing a Safe, Positive Learning Environment')		
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K7', 7, 1, 'Collaborative and Collegial Practaces','Exhibiting Collaborative and Collegial Practices Focus on Improving Instructional Practice and Student Learning')	
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@iT, null,'K8', 8, 1, 'Communication','Communicating with Parents and School Community')


--select * from SEFrameworkNode where FrameworkID in (5, 6, 18, 19)


insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, sequence)
select fn.FrameworkNodeID, rr.RubricRowID , rr.RubricRowID AS Sequence
from stateeval_Prepro.dbo.KenTeacherIFW_RR p
join SERubricRow rr on p.title = rr.Title
join SEFrameworkNode fn on fn.ShortName=p.nodeName
where rr.BelongsToDistrict='03017' and fn.FrameworkID= @it

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, sequence)
select fn.FrameworkNodeID, rr.RubricRowID , rr.RubricRowID AS Sequence
from stateeval_PrePro.dbo.KenPrinIFW_RR p
join SERubricRow rr on p.title = rr.Title
join SEFrameworkNode fn on fn.ShortName=p.nodeName
where rr.BelongsToDistrict='03017' and fn.FrameworkID= @ip


declare         
 @pC1 bigint   ,@tC1 bigint       ,@pC2 bigint   ,@tC2 bigint       ,@pC3 bigint   ,@tC3 bigint       ,@pC4 bigint   ,@tC4 bigint       
,@pC5 bigint   ,@tC5 bigint       ,@pC6 bigint   ,@tC6 bigint       ,@pC7 bigint   ,@tC7 bigint       ,@pC8 bigint   ,@tC8 bigint      

select @pC1= FrameworkNodeID from SEFrameworkNode where shortname = 'C1' and frameworkID = @sP       
select @pC2= FrameworkNodeID from SEFrameworkNode where shortname = 'C2' and frameworkID = @sP
select @pC3= FrameworkNodeID from SEFrameworkNode where shortname = 'C3' and frameworkID = @sP
select @pC4= FrameworkNodeID from SEFrameworkNode where shortname = 'C4' and frameworkID = @sP
select @pC5= FrameworkNodeID from SEFrameworkNode where shortname = 'C5' and frameworkID = @sP
select @pC6= FrameworkNodeID from SEFrameworkNode where shortname = 'C6' and frameworkID = @sP
select @pC7= FrameworkNodeID from SEFrameworkNode where shortname = 'C7' and frameworkID = @sP
select @pC8= FrameworkNodeID from SEFrameworkNode where shortname = 'C8' and frameworkID = @sP
select @tC1= FrameworkNodeID from SEFrameworkNode where shortname = 'C1' and frameworkID = @sT
select @tC2= FrameworkNodeID from SEFrameworkNode where shortname = 'C2' and frameworkID = @sT
select @tC3= FrameworkNodeID from SEFrameworkNode where shortname = 'C3' and frameworkID = @sT
select @tC4= FrameworkNodeID from SEFrameworkNode where shortname = 'C4' and frameworkID = @sT
select @tC5= FrameworkNodeID from SEFrameworkNode where shortname = 'C5' and frameworkID = @sT
select @tC6= FrameworkNodeID from SEFrameworkNode where shortname = 'C6' and frameworkID = @sT
select @tC7= FrameworkNodeID from SEFrameworkNode where shortname = 'C7' and frameworkID = @sT
select @tC8= FrameworkNodeID from SEFrameworkNode where shortname = 'C8' and frameworkID = @sT


insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC2, /*1*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k1'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC4, /*2*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k2'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC3, /*3*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k3'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC1, /*4*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k4'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC6, /*5*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k5'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC5, /*6*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k6'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC8, /*7*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k7'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @pC7, /*8*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iP and fn.ShortName='k8'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC2, /*1*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k1'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC4, /*2*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k2'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC3, /*3*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k3'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC1, /*4*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k4'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC6, /*5*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k5'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC5, /*6*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k6'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC8, /*7*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k7'
insert seRubricRowFrameworkNode (frameworkNodeId, rubricRowId, sequence) select @tC7, /*8*/rubricRowID, rubricRowID AS Sequence from SERubricRowFrameworkNode rrfn join SEFrameworkNode fn on fn.FrameworkNodeID=rrfn.FrameworkNodeID where fn.FrameworkID = @iT and fn.ShortName='k8'



create table #x(shortname varchar (10), title varchar (256), belongsToDistrict varchar (20))                                                                                 
insert #x (shortname, title, belongsToDistrict)
select shortName, title, belongsToDistrict from vRowsInFramework rif
join SEFramework f on f.frameworkID = rif.frameworkID
where frameworkTypeID =3 and ShortName in ('k2', 'k3', 'k5') and BelongsToDistrict = '03017'
order by ShortName, Title

select shortname, belongsToDistrict, title from #x

update seRubricRowFrameworkNode set sequence= 10where frameworkNodeID =267 and rubricRowID =655		--K2: Reviews,   Analyzes and Implements a School Safety Plan       
update seRubricRowFrameworkNode set sequence= 20where frameworkNodeID =267 and rubricRowID =656		--K2: Reviews   Analyzes and Implements a School Discipline Plan    
update seRubricRowFrameworkNode set sequence= 30where frameworkNodeID =267 and rubricRowID =659		--K2: Supervises Teacher Classroom Management and Discipline 
update seRubricRowFrameworkNode set sequence= 40where frameworkNodeID =267 and rubricRowID =652		--K2: Ensures that proper prevention and training  (from Wenatchee)
update seRubricRowFrameworkNode set sequence= 50where frameworkNodeID =267 and rubricRowID =653		--K2: Ensures maintenance of physical plant (Wenatchee)
update seRubricRowFrameworkNode set sequence= 10where frameworkNodeID =268 and rubricRowID =660		--K3: Monitors, Assists and Evaluates Effective Instructional Practices      
update seRubricRowFrameworkNode set sequence= 20where frameworkNodeID =268 and rubricRowID =654		--K3: Monitors, Assists and Evaluates Effective Assessment Practices   
update seRubricRowFrameworkNode set sequence= 30where frameworkNodeID =268 and rubricRowID =657		--K3: Observes Instruction and Provides Feedback        **Uses a variety of measures and methods for observations** (from Wenatchee)   Uses a variety of data to monitor and improve instructional practices (from Wenatchee)   
update seRubricRowFrameworkNode set sequence= 10where frameworkNodeID =270 and rubricRowID =667		--K5: Manages Human Resources To Support Student Achievement      
update seRubricRowFrameworkNode set sequence= 20where frameworkNodeID =270 and rubricRowID =658		--K5: Plans Staff Development To Support Student Achievement   
update seRubricRowFrameworkNode set sequence= 30where frameworkNodeID =270 and rubricRowID =668		--K5: Manages Financial Resources To Support Student Achievement and Legal Responsibilities   
update seRubricRowFrameworkNode set sequence= 40where frameworkNodeID =270 and rubricRowID =669		--K5: Allocates Staffing Resources to Support Student Achievement   
update seRubricRowFrameworkNode set sequence= 50where frameworkNodeID =270 and rubricRowID =670		--K5: Managing Hiring Practices to Support Student Achievement and Legal Responsibilities   




/*this is the part where we get rid of the real state frameworks, and transform the k ifw to a state one... */


delete SERubricRowFrameworkNode where frameworkNodeid in 
(select frameworkNodeID from SEFrameworkNode where frameworkId in 
(select FrameworkID from SEFramework where DistrictCode = '03017' and FrameworkTypeID in (1, 3)))
delete SEFrameworkNode where FrameworkID in 
(select FrameworkID from SEFramework where DistrictCode = '03017' and FrameworkTypeID in (1, 3))
delete SEFramework where FrameworkID in 
(select FrameworkID from SEFramework where DistrictCode = '03017' and FrameworkTypeID in (1, 3))

update SEFramework set Name = 'kennTeachState', FrameworkTypeID=FrameworkTypeID-1 where FrameworkID in 
(select FrameworkID from SEFramework where DistrictCode = '03017' and FrameworkTypeID =2)
update SEFramework set Name = 'kennPrinState', FrameworkTypeID=FrameworkTypeID-1 where FrameworkID in 
(select FrameworkID from SEFramework where DistrictCode = '03017' and FrameworkTypeID =4)

                                                       
update seFrameworkNode set title = 'Creating a Culture: Improvement - Creating a school culture that promotes the ongoing improvement of learning and teaching for students and staff.'                                                  from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K1' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Creating a Culture: Safety - Providing for school safety.'                                                                                                                                           from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K2' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Creating a Culture: Improvement - Leads development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements.'   from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K3' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Creating a Culture: Alignment - Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district learning goals.'                                from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K4' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Managing Resources - Monitoring, assisting and evaluating effective instruction and assessment practices.'                                                                                           from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K5' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Planning with Data - Manage human and fiscal resources to accomplish student achievement goals.'                                                                                                     from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K6' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Engaging Communities - Partnering with the school community to promote student learning.'                                                                                                            from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K7' and f.name = 'kennPrinState' 
update seFrameworkNode set title = 'Closing the Gap - Demonstrate commitment to closing achievement gaps.'                                                                                                                               from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K8' and f.name = 'kennPrinState' 
                                                                                                                                                                                                                                                                                                                                                           

update seFrameworkNode set title =rtrim('Instructional Skill - Planning and Preparation - Demonstrating effective teaching practices                                                                                                       ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K1' and f.name = 'kennTeachState'            
update seFrameworkNode set title =rtrim('Instructional Skill - Purpose - Providing clear and intentional focus on subject matter content and curriculum                                                                                    ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K2' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Instructional Skill - Engagement - Recognizing individual student learning needs and developing strategies to address those needs                                                                 ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K3' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Instructional Skill - Rigor - Centering instruction on high expectations for student achievement                                                                                                  ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K4' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Instructional Skill - Results - Using multiple student data elements to modify instruction and improve student learning                                                                           ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K5' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Classroom Management - Fostering and managing a safe, positive learning environment                                                                                                               ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K6' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Collaborative and Collegial Practaces - Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning                                         ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K7' and f.name = 'kennTeachState' 
update seFrameworkNode set title =rtrim('Communication - Communicating and collaborating with parents and school community                                                                                                                 ')from seFrameworkNode fn join seFramework f on f.frameworkID = fn.frameworkId where shortname='K8' and f.name = 'kennTeachState' 




                                           
