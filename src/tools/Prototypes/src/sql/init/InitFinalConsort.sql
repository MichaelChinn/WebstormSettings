

delete SERubricRowFrameworkNode where RubricRowID in 
(
	select rubricRowID from seRubricRow where BelongsToDistrict = 'CONS'
)
delete SERubricRow where BelongsToDistrict='CONS'
delete SEFrameworkNode where FrameworkID in (4, 17, 21)
delete SEFramework where FrameworkID in (4, 17, 21)

DECLARE @ConTeachIFW bigint,@ConTeachState bigint,@ConTeachSelfIFW bigint,@ConTeachSelfState bigint,@ConPrinIFW bigint,@ConPrinState bigint

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('ConPrinState', 'state criteria reordered to danielson', '00000', 2012, 3, 1, null, 0, 1, 1)  SELECT @ConPrinState = SCOPE_IDENTITY()
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('ConTeachIFW', '', '00000', 2012, 2, 1, null, 0, 1, 1)  SELECT @ConTeachIFW = SCOPE_IDENTITY()
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('ConTeachSelfIFW', '', '00000', 2012, 6, 1, null, 0, 1, 1)  SELECT @ConTeachSelfIFW = SCOPE_IDENTITY()
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('ConTeachState', '', '00000', 2012, 1, 1, null, 0, 1, 1)  SELECT @ConTeachState = SCOPE_IDENTITY()
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('ConTeachSelfState', '', '00000', 2012, 5, 1, null, 0, 1, 1)  SELECT @ConTeachSelfState = SCOPE_IDENTITY()

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) select Title,'', p1, p2, p3, p4, 'CONTI' from stateEval_PrePro.dbo.ConTeacherIFW_RR
insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) select Title,'', p1, p2, p3, p4, 'CONTSI' from stateEval_PrePro.dbo.ConTeacherSelfIFW_RR
insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) select Title,'', p1, p2, p3, p4, 'CONPR' from stateEval_PrePro.dbo.ConPrinIFW_RR

insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D1a', 10,1, 'Domain 1: Leadership in Creating a Shared Vision - School Culture',                'Creating a school culture that promotes the ongoing improvement of learning and teaching for students and staff:  Influence, establish, and sustain a school culture conducive to continuous improvement for students and staff.')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D1b', 20,1, 'Domain 1: Leadership in Creating a Shared Vision - Planning with Data',            'Leads development, implementation and evaluation of a data-driven school improvement plan in order to increase student achievement. ')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D1c', 30,1, 'Domain 1: Leadership in Creating a Shared Vision - Partnering with the Community', 'Partnering with the school community to promote student learning.   Principal builds collegial and collaborative relationships with and among school staff members in order to establish and maintain a common focus, coordinate effort, and minimize and resolve conflicts.    ')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D2a', 40,1, 'Domain 2: Instructional Leadership - Closing the Achievement Gap',   'Demonstrating commitment to closing the achievement gap.  Principal understands (and effectively communicates) factors contributing to the need to address diverse learners.   Principal creates systems that ensure that the academic needs of all students are being met.  ')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D2b', 50,1, 'Domain 2: Instructional Leadership - Aligning Curriculum',           'Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district    learning goals.')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D2c', 60,1, 'Domain 2: Instructional Leadership - Improving Instruction',         'The principal is fundamental to the monitoring, assisting and evaluating effective instruction and assessment practices.')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D3a', 70,1, 'Domain 3: Managing the School Environment',                          'Providing for School Safety. The principal leads the development and annual update of a comprehensive safe schools plan that includes prevention, intervention, crisis response and recovery.')
insert seFrameworkNode (frameworkID, parentNodeID, shortname, sequence, isLeafNode, title, description) values (@ConPrinState, null, 'D4a', 80,1, 'Damain 4: Managing and Human and Fiscal Rsources',                   'Managing both staff and fiscal resources to support student achievement and legal responsibilities.')

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachIFW, null,'D1', 1, 1, rtrim('Planning and Preparation     '), rtrim('Planning and Preparation     '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachIFW, null,'D2', 2, 1, rtrim('The Classroom Environment    '), rtrim('The Classroom Environment    '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachIFW, null,'D3', 3, 1, rtrim('Instruction                  '), rtrim('Instruction                  '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachIFW, null,'D4', 4, 1, rtrim('Professional Responsibilities'), rtrim('Professional Responsibilities'))


insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfIFW, null,'D1', 1, 1, rtrim('Planning and Preparation     '), rtrim('Planning and Preparation     '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfIFW, null,'D2', 2, 1, rtrim('The Classroom Environment    '), rtrim('The Classroom Environment    '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfIFW, null,'D3', 3, 1, rtrim('Instruction                  '), rtrim('Instruction                  '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfIFW, null,'D4', 4, 1, rtrim('Professional Responsibilities'), rtrim('Professional Responsibilities'))


insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C1', 1, 1, rtrim('Centering instruction on high expectations for student achievement                                               '), rtrim('PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.'))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C2', 2, 1, rtrim('Demonstrating effective teaching practices                                                                       '), rtrim('INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.                                                   '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C3', 3, 1, rtrim('Recognizing individual student learning needs and developing strategies to address those needs                   '), rtrim('REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.                                                                                      '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C4', 4, 1, rtrim('Providing clear and intentional focus on subject matter content and curriculum                                   '), rtrim('CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.                                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C5', 1, 1, rtrim('Fostering and managing a safe, positive learning environment                                                     '), rtrim('CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being                                                                        '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C6', 2, 1, rtrim('Using multiple student data elements to modify instruction and improve student learning                          '), rtrim('ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.                                                                                                            '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C7', 3, 1, rtrim('Communicating and collaborating with parents and school community                                                '), rtrim('PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachSelfState, null,'C8', 4, 1, rtrim('Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning'), rtrim('PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.                                          '))

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C1', 1, 1, rtrim('Centering instruction on high expectations for student achievement                                               '), rtrim('PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.'))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C2', 2, 1, rtrim('Demonstrating effective teaching practices                                                                       '), rtrim('INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.                                                   '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C3', 3, 1, rtrim('Recognizing individual student learning needs and developing strategies to address those needs                   '), rtrim('REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.                                                                                      '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C4', 4, 1, rtrim('Providing clear and intentional focus on subject matter content and curriculum                                   '), rtrim('CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.                                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C5', 1, 1, rtrim('Fostering and managing a safe, positive learning environment                                                     '), rtrim('CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being                                                                        '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C6', 2, 1, rtrim('Using multiple student data elements to modify instruction and improve student learning                          '), rtrim('ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.                                                                                                            '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C7', 3, 1, rtrim('Communicating and collaborating with parents and school community                                                '), rtrim('PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@ConTeachState, null,'C8', 4, 1, rtrim('Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning'), rtrim('PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.                                          '))

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, rr.rubricRowID
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = substring(fn.shortname, 2, 2)
where rr.BelongsToDistrict = 'conpr' and fn.FrameworkID = @conPrinState

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, rr.rubricRowID
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 1) = substring(fn.shortname, 2, 1)
where rr.BelongsToDistrict = 'conti' and fn.FrameworkID = @conTeachIFW

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, rr.rubricRowID
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 1) = substring(fn.shortname, 2, 1)
where rr.BelongsToDistrict = 'contsi' and fn.FrameworkID = @ConTeachSelfIFW


insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID, rr.rubricRowID, row_number()  over (order by fn.shortname, rr.title) as foo
from SEFrameworkNode fn
join stateeval_prePro.dbo.DanielsonToState ds on ds.criteria = CONVERT(int, SUBSTRING(fn.shortname,2,1))
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = ds.component
where rr.BelongsToDistrict = 'conti' and fn.FrameworkID = @ConTeachState
order by foo

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID, rr.rubricRowID, row_number()  over (order by fn.shortname, rr.title) as foo
from SEFrameworkNode fn
join stateeval_prePro.dbo.DanielsonToState ds on ds.criteria = CONVERT(int, SUBSTRING(fn.shortname,2,1))
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = ds.component
where rr.BelongsToDistrict = 'contsi' and fn.FrameworkID = @ConTeachSelfState
order by foo

update SERubricRow set BelongsToDistrict = '00000' where BelongsToDistrict = 'conti'
update SERubricRow set BelongsToDistrict = '00000' where BelongsToDistrict = 'contsi'
update SERubricRow set BelongsToDistrict = '00000' where BelongsToDistrict = 'contpr'



insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conPrinState,1, 'UNS', 'Unsatisfactory', 'Professional practice at the unsatisfactory level shows evidence of not understanding the concepts underlying individual components of the framework. This level of practice is ineffective and inefficient and may represent practice that is harmful to overall student learning progress, the school’s learning environment or leadership practices. This level requires immediate intervention.')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conPrinState,2, 'BAS', 'Basic', 'Professional practice at the basic level shows evidence of knowledge and skills required to practice, but performance is inconsistent over a period of time due to lack of experience, expertise and/or commitment. This level may be considered minimally competent for principals early in their careers but insufficient for more experienced principals. This level requires specific support.')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conPrinState,3, 'PRO', 'Proficient', 'Professional practice at the proficient level shows evidence of thorough knowledge of all aspects of the profession. This is successful, accomplished, professional and effective practice. Principals at this level thoroughly know the staff and student body and utilize this understanding to drive a focus on improved student learning. Principals at this level utilize a broad array of strategies and activities to promote student learning throughout the school. At this level, leadership is strengthened and expanded through purposeful sharing and learning with colleagues and staff members and ongoing self-reflection and professional improvement.')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conPrinState,4, 'DIS', 'Distinguished', 'Professional practice at the distinguished level is that of master professional whose practices operate at a qualitatively different level from those of other professional peers. Practice at this level is defined by ongoing self-reflection and the highest level of expertise and commitment to all students’ learning, professional challenging growth, and strong leadership.')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachIFW,1, 'UNS', 'Unsatisfactory',  'Unsatisfactory')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachIFW,2, 'BAS', 'Basic',           'Basic'         )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachIFW,3, 'PRO', 'Proficient',      'Proficient'   )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachIFW,4, 'DIS', 'Distinguished',   'Distinguished' )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfIFW,1, 'UNS', 'Unsatisfactory',  'Unsatisfactory')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfIFW,2, 'BAS', 'Basic',           'Basic'         )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfIFW,3, 'PRO', 'Proficient',      'Proficient'    )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfIFW,4, 'DIS', 'Distinguished',   'Distinguished' )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conTeachState,1, 'UNS', 'Unsatisfactory',  'Unsatisfactory')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conTeachState,2, 'BAS', 'Basic',           'Basic'        )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conTeachState,3, 'PRO', 'Proficient',      'Proficient'    )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@conTeachState,4, 'DIS', 'Distinguished',   'Distinguished' )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfState, 1,'UNS', 'Unsatisfactory',  'Unsatisfactory')
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfState, 2,'BAS', 'Basic',           'Basic'         )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfState, 3,'PRO', 'Proficient',      'Proficient'    )
insert seFrameworkPerformanceLevel (frameworkID, performanceLevelID, shortname, fullName, Description) values (@ConTeachSelfState, 4,'DIS', 'Distinguished',   'Distinguished' )


update SERubricRow set Title = SUBSTRING(Title, 4, 500), BelongsToDistrict = '00000' where BelongsToDistrict = 'CONPR'
update SERubricRow set IsStateAligned=0 where BelongsToDistrict = '00000'
update SERubricRow set IsStateAligned=1 where RubricRowID in
(select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
join SEFramework f on f.FrameworkID = fn.FrameworkID
where FrameworkTypeID in (1,3,5,7)
) and BelongsToDistrict = '00000'






