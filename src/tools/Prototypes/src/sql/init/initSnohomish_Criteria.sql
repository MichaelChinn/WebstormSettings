select * from seFramework
select * from SERubricRow
order by RubricRowID desc -- *31201*

select * from SEFramework


delete SERubricRowFrameworkNode where RubricRowID in 
(select RubricRowID from SERubricRow where BelongsToDistrict = '31201')
delete SERubricRow where BelongsToDistrict = '31201'
delete SEFrameworkNode where FrameworkID in (12, 13)

--12 - principal
--13 - teacher state
--23 - teacher ifw


INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IFWTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved) 
VALUES('SnoTeacherIFW', 'Snohomish, teacher IFW', '31201', 2012, 2, 1
			, 1, '', 0, 1)
			
			
		

Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 1: Centering instruction on high expectations for student achievement'
,'The certificated classroom teacher demonstrates the foundational expectation that all students can and will attain a high level of personal and academic achievement.'
, 'C1', 1, 1)

Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 2: Demonstrating effective teaching practices'
,'The certificated classroom teacher''s instruction demonstrates the ability to create and implement focused (research based) lessons that measurably improved student learning, maximize efficiency and foster a high level of student engagement.'
, 'C2', 2, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 3: Recognizing individual student learning needs and developing strategies to address those needs'
,'The certificated classroom teacher promotes the learning needs, interests, questions and concerns of students and utilizes these interests in planning learning activities. The certificated classroom teacher designs classroom activities which further the success of each student.'
, 'C3', 3, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 4: Providing clear and intentional focus on subject matter content and curriculum'
,'The certificated classroom teacher demonstrates fluency with standards and content in developing and communicating clear learning targets.'
, 'C4', 4, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 5: Fostering and managing a safe, positive learning environment'
,'The certificated classroom teacher fosters and manages relationships that support respect and rapport in the classroom.'
, 'C5', 5, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 6: Using multiple student data elements to modify instruction and improve student learning'
,'The certificated classroom teacher analyzes the results of multiple data elements (i.e. formative, summative and other measures) to inform instruction and determine which strategies, materials and resources will improve student achievement.'
, 'C6', 6, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 7: Communicating and collaborating with parents and school community'
,'The certificated classroom teacher proactively communicates to all educational stakeholders in an ethical and professional (timely, supportive, systematic, meaningful, respectful) manner.'
, 'C7', 7, 1)
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode) values (13, 'Criterion 8: Exhibiting collaborative and collegial practices focusing on improving instructional practice and student learning'
,'The certificated classroom teacher values and participates regularly in a wide range of collaborative and collegial work for the benefit of improving instructional practice and student learning.'
, 'C8', 8, 1)


insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 1, 1, 'C1','Criterion 1: Creating a Culture','Influence, establish and sustain a school culture conducive to continuous improvement for students and staff.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 2, 1, 'C2','Criterion 2: Ensuring School Safety','Lead the development and annual update of a comprehensive safe schools plan that includes prevention, intervention, crisis response and recovery.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 3, 1, 'C3','Criterion 3: Planning with Data','Lead the development, implementation and evaluation of the data-driven plan for improvement of student achievement.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 4, 1, 'C4','Criterion 4: Aligning Curriculum','Assist instructional staff in aligning curriculum, instruction and assessment with state and local learning goals.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 5, 1, 'C5','Criterion 5: Improving Instruction','Monitor, assist and evaluate staff implementation of the school improvement plan, effective instruction and assessment practices.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 6, 1, 'C6','Criterion 6: Managing Resources','Manage human and fiscal resources to accomplish student achievement goals.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 7, 1, 'C7','Criterion 7: Engaging Communities','Communicate and partner with school community members to promote student learning.')
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (12, 8, 1, 'C8','Criterion 8: Closing the Gap','Demonstrate a commitment to closing the achievement gap.')


insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (23, 1, 1, 'D1','Planning and Preparation'     ,'Planning and Preparation'     )                                     
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (23, 2, 1, 'D2','The Classroom Environment'    ,'The Classroom Environment'    )
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (23, 3, 1, 'D3','Instruction'                  ,'Instruction'                  )                      
insert seFrameworkNode(FrameworkId, Sequence, IsLeafNode, Shortname, Title, Description) values (23, 4, 1, 'D4','Professional Responsibilities','Professional Responsibilities')




insert SERubricRow (Title, Description,  PL1Descriptor, PL2Descriptor,PL3Descriptor
, PL4Descriptor, BelongsToDistrict)
select t,'', p1, p2, p3, p4, '31201' from stateEval_prePro.dbo.snoTeachState_rr
insert SERubricRow (Title,Description, PL1Descriptor, PL2Descriptor,PL3Descriptor
, PL4Descriptor, BelongsToDistrict)
select t,'', p1, p2, p3, p4, '31201' from stateEval_prePro.dbo.snoPrinState_rr

select * from SEFramework
select * from vRowsInFramework where frameworkID =13

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, sequence)
select fn.FrameworkNodeID, RubricRowID,rubricRowId-697 from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = rtrim(fn.shortname)
where fn.FrameworkID = 13 and RubricRowID between 698 and 737

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, sequence)
select fn.FrameworkNodeID, RubricRowID,rubricRowId-737 from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = fn.shortname
where fn.FrameworkID = 12 and RubricRowID > 737

select '['+ shortname +']' from SEFrameworkNode where FrameworkID = 12
select SUBSTRING(title, 1, 2) from seRubricrow where belongstodistrict='31201'
select * from SEFramework
select * from SEFrameworkNode where FrameworkID in (12, 13, 33)
select * from SERubricRow where BelongsToDistrict = '31201'
select * from vRowsInFramework where FrameworkID = 32
select * from SEFrameworkNode where FrameworkID = 32
select * from SERubricRow where BelongsToDistrict = '31201'
select * from SEFramework where Name like 'sno%'
select * from SERubricRow where Title like 'c%'





create table #t(d varchar(10), rr varchar (256))
insert #t(d, rr) values ('d2', 'c1--1.1 Commits to High Learning Expectations ' )
insert #t(d, rr) values ('d2', 'c1--1.2 Promotes Pride & Effort '               )
insert #t(d, rr) values ('d2', 'c1--1.3 Fosters Original & Creative Thinking '  )
insert #t(d, rr) values ('d3', 'c1--1.4 Student Engagement '                    )
insert #t(d, rr) values ('d1', 'c2--2.1 Daily & Unit Lesson Planning '          )
insert #t(d, rr) values ('d1', 'c2--2.2 Lesson Structure '                      )
insert #t(d, rr) values ('d1', 'c2--2.3 Instructional Grouping '                )
insert #t(d, rr) values ('d3', 'c2--2.4 Directions & Procedures '               )
insert #t(d, rr) values ('d3', 'c2--2.5 Transitions '                           )
insert #t(d, rr) values ('d3', 'c2--2.6 Learning Conversations '                )
insert #t(d, rr) values ('d4', 'c2--2.7 Lesson Improvement'                     )
insert #t(d, rr) values ('d1', 'c2--3.1 Student Prior Knowledge '               )
insert #t(d, rr) values ('d1', 'c2--3.2 Students? Special Needs '               )
insert #t(d, rr) values ('d1', 'c2--3.3 Instructional Strategies '              )
insert #t(d, rr) values ('d1', 'c2--3.4 Response to Student Interest '          )
insert #t(d, rr) values ('d3', 'c2--3.1 Student Prior Knowledge      '          )
insert #t(d, rr) values ('d3', 'c2--3.2 Students? Special Needs      '          )
insert #t(d, rr) values ('d3', 'c2--3.3 Instructional Strategies     '          )
insert #t(d, rr) values ('d3', 'c2--3.4 Response to Student Interest '          )        
insert #t(d, rr) values ('d1', 'c4--4.1 District & State Standards '                   )
insert #t(d, rr) values ('d1', 'c4--4.2 Content Knowledge '                            )
insert #t(d, rr) values ('d1', 'c4--4.3 Content-Related Pedagogy '                     )
insert #t(d, rr) values ('d1', 'c4--4.4 Interdisciplinary Integration '                )
insert #t(d, rr) values ('d3', 'c4--4.5 Presentation of Subject Matter Content '       )
insert #t(d, rr) values ('d2', 'c5--5.1 Teacher Interactions with Students '           )
insert #t(d, rr) values ('d2', 'c5--5.2 Student Interactions with Students '           )
insert #t(d, rr) values ('d2', 'c5--5.3 Monitoring of Student Behavior '               )
insert #t(d, rr) values ('d2', 'c5--5.4 Response to Student Misbehavior '              )
insert #t(d, rr) values ('d2', 'c5--5.5 Accessing Support Services '                   )
insert #t(d, rr) values ('d2', 'c5--5.6 Physical Environment '                         )
insert #t(d, rr) values ('d2', 'c5--5.7 Equipment '                                    )
insert #t(d, rr) values ('d1', 'c6--6.1 Assessment Tools '                             )
insert #t(d, rr) values ('d1', 'c6--6.2 Data-Driven Instructional Planning '           )
insert #t(d, rr) values ('d2', 'c6--6.3 Student Use of Data '                          )
insert #t(d, rr) values ('d3', 'c6--6.4 Assessment Criteria '                          )
insert #t(d, rr) values ('d3', 'c6--6.5 Assessment Feedback '                          )
insert #t(d, rr) values ('d4', 'c6--6.6 Data Analysis '                                )
insert #t(d, rr) values ('d4', 'c7--7.1 Communicating Program Information '            )
insert #t(d, rr) values ('d4', 'c7--7.2 Communicating Student Progress '               )
insert #t(d, rr) values ('d4', 'c7--7.3 Maintaining Accurate Records '                 )
insert #t(d, rr) values ('d4', 'c8--8.1 Performance Feedback '                         )
insert #t(d, rr) values ('d4', 'c8--8.2 Collaboration '                                )
insert #t(d, rr) values ('d4', 'c8--8.3 Professional Responsibilities '                )
insert #t(d, rr) values ('d4', 'c8--8.4 Substitute Lesson Planning '                   )


insert SERubricRowFrameworkNode  (RubricRowID, FrameworkNodeID, Sequence)
select RubricRowID, fn.FrameworkNodeID, rubricRowID-1331
from SEFrameworkNode fn
join #t  t on t.d = fn.ShortName
join SERubricRow rr on rr.Title = t.rr
where fn.FrameworkID = 23 and rr.BelongsToDistrict = '31201'
order by FrameworkNodeID, rubricRowID

-- the input was wrong; had c3 rubrics linked to c2
declare @c3ID bigint
select @c3ID=FrameworkNodeID from SEFrameworkNode
where FrameworkID = 13 and ShortName = 'c3'

update SERubricRowFrameworkNode
set FrameworkNodeID = @c3ID

from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
where fn.ShortName = 'c2' and rr.Title like '3.%'



update SERubricRow set Title = SUBSTRING(title, 5, 200) where BelongsToDistrict='31201'
update SEFrameworkNode set Title = SUBSTRING (title, len('Criterion 1:XX'),300)  where frameworkID in (13, 23)

select * from seFrameworkPerformanceLevel fpl
join SEFramework f on f.FrameworkID = fpl.frameworkID
 order by name, f.FrameworkID, performanceLevelID

select * from SEFrameworkPerformanceLevel where FrameworkID in (12, 13,23)


update seFrameworkPerformanceLevel set description = 'The leadership practice, improvement planning, school culture and professional demeanor of the exemplary'
+' administrator will look very much like the proficient, but is further characterized by: a commitment to service that is also'
+' evident throughout the staff and student body; student and staff ownership of the school culture; student needs being'
+' placed at the highest priority; actively engages staff in seeking out ways to personalize instruction; models positive risktaking'
+' and exploration; enhancing the professional skills of staff through individualized professional growth planning; the'
+' cultivation of relationships at the building and district level that enhance the systems governing the public school setting.'
 from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (3, 4, 7, 8) /*(principal)*/ and fpl.PerformanceLEvelID = 4


update seFrameworkPerformanceLevel set description = 'The leadership practice, improvement planning, school culture and professional demeanor of the proficient certificated'
+' administrator is characterized by: consistency; high expectations; clarity in goals and communication; purposeful'
+' planning; respectful interactions in all areas; a variety of leadership strategies that engage stakeholders in the school'
+' community; planning that purposefully centers on student progress and achievement; planning that purposefully centers'
+' upon staff professional growth; staff evaluations that comprehensively assess employees’ professional accomplishments;'
+' consideration of diverse student needs in school improvement planning; understands and contributes to the systems'
+' that govern the public school setting.'
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (3, 4, 7, 8) /*(principal)*/ and fpl.PerformanceLEvelID = 3


update seFrameworkPerformanceLevel set description = 'The leadership practice, improvement planning, school culture and professional demeanor of the emerging certificated'
+' administrator is characterized by: expectations for the school community that are applied and modeled unevenly; goals'
+' that are sometimes unclear; learning to communicate in a timely, relevant manner and with clarity; appropriate'
+' interactions in most areas; leadership strategies that are limited or may not actively engage stakeholders; planning that'
+' is not purposefully centered on student progress and achievement; planning that does not purposefully take the'
+' professional growth of staff into account; staff evaluations that are cursory or haphazardly completed; a basic or'
+' developing knowledge of the systems that govern the public school setting.'
+' The administrator whose skills are categorized as emerging is learning the profession or a new position or is attempting'
+' to adapt to changes in professional expectations.'
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (3, 4, 7, 8) /*(principal)*/ and fpl.PerformanceLEvelID = 2


update seFrameworkPerformanceLevel set description = 'The leadership practice, improvement planning, school culture and professional demeanor of the unsatisfactory'
+' certificated administrator is characterized by: low expectations for learning and behavior in the school community; does'
+' not communicate in a timely, relevant manner or with clarity; interactions are often not appropriate; does not facilitate'
+' planning centered on student growth ; does not facilitate planning that takes the professional growth of staff into'
+' account; leadership strategies are not evident and/or do not engage stakeholders; staff evaluations that are incomplete'
+' or not completed in a timely manner; does not demonstrate an understanding of or interest in contributing to the'
+' systems that govern the public school setting.'
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (3, 4, 7, 8) /*(principal)*/ and fpl.PerformanceLEvelID = 1


update seFrameworkPerformanceLevel set description ='The instructional practice, planning and classroom environment and professional demeanor of the exemplary certificated '
+ 'classroom teacher will look very much like the proficient, but is further characterized by: positive teacher behaviors '
+ 'modeled and evident in student behaviors; student responsibility; anticipation of student and parent needs; '
+ 'personalization of instruction; positive risk-taking and exploration. '
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (1, 2, 5, 6) /*(teacher)*/ and fpl.PerformanceLEvelID = 4

update seFrameworkPerformanceLevel set description ='The instructional practice, planning and classroom environment and professional demeanor of the proficient certificated '
+ 'classroom teacher is characterized by: consistency; high expectations; clarity in goals and communication; relevant and '
+ 'appropriate plans; respectful interactions in all areas; a variety of instructional strategies that accommodate student '
+ 'needs and interests; emphasis upon student progress and achievement; student learning information is considered in '
+ 'decision making. '
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (1, 2, 5, 6) /*(teacher)*/ and fpl.PerformanceLEvelID = 3
 
 
 update seFrameworkPerformanceLevel set description ='The instructional practice, planning and classroom environment and professional demeanor of the emerging certificated '
+ 'classroom teacher is characterized by: not yet proficient; expectations are applied unevenly or not yet consistently; '
+ 'learning expectations are not communicated or not high; working to set goals; learning to communicate in a timely, '
+ 'relevant manner and with clarity; interactions are generally appropriate in most areas; minimal alignment with standards '
+ 'and curricula; a limited repertoire of instructional skills or strategies that generally accommodate only the whole class or '
+ 'large groups; rudimentary use of instructional information or resources to encourage learning. '
+ 'The teacher whose skills are categorized as emerging is learning the profession or a new position or is attempting to '
+ 'adapt to changes in professional expectations. '
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (1, 2, 5, 6) /*(teacher)*/ and fpl.PerformanceLEvelID = 2



update seFrameworkPerformanceLevel set description ='The instructional practice, planning and classroom environment and professional demeanor of the unsatisfactory '
+ 'certificated classroom teacher is characterized by: low expectations for learning and behavior; does not encourage effort '
+ 'or learning and may discourage it; instructional strategies are employed with little or no regard to student needs or '
+ 'interests; lessons and goals are generally not aligned, focused or appropriate to students; students are dependent on '
+ 'teacher control or don’t respond to teacher direction; student learning information is rarely or never used to inform or '
+ 'shape instruction; little or no effort is made to participate in collegial or collaborative work; little or no evidence of '
+ 'professional growth to improve student learning.'
from seFrameworkPerformanceLevel fpl
 join SEFramework f on f.FrameworkID =fpl.frameworkID
 where DistrictCode = '31201'  and f.FrameworkTypeID in (1, 2, 5, 6) /*(teacher)*/ and fpl.PerformanceLEvelID = 1
      
      
      
      
      
      
      
       select * from SEDistrictConfiguration where DistrictCode = '31201'

select * from SEFramework

select * from SEFramework where Name like 'sno%'

select * from seframeworkPerformancelevel where FrameworkID in (13, 14, 15)

select * from SERubricRow where BelongsToDistrict='31201'



select * from vRowsInFramework where frameworkID=32 and Title like '5%'


select * from seframework





