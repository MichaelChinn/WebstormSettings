/*
--this set works with dbcreate @ 765

Here is what happened...  we started doing the dbcreate/patchdbcreate thing.

To dbCreate.754, we added north mason, which was the original version of this
patch file (patchDbCreate.757).

Then we noticed some problems, and at around dbCreate[759, 760] there was discovered
a problem with the north mason insert.  So, we reverted to patchDbCreate.757, and
it's associated dbCreate(754).

That became patchDbCreate(762).  But there was a problem there as well, because the load
combined the principal and teacher frameworks!!!, and so we went back to 754 again,
which resulted in 763.

For some reason, something destroyed the north mason ifw framework; this is the problem 
with (764).

So,
... I'm reverting back to patch(757), with the right dbcreate(754). 
... I'm combining all the patchDbCreates from 754-764.


In addition to this, instead of wiping out the patch file
each time, we're just going to append to the silly thing.  To do this,
right after gendbcreate is run the final time to create dbcreate before checkin,
all the patches in this file must be commented out.  Kind of cumbersome, but this
way we can keep track of everything that went into any given dbCreate, and we don't
have to check out a bunch of previous versions. 
    

In addition, this adds bug 2370

*/

/*
--begin 765 patches ****************************************************************



--select * from SEFramework where Name like '%mas%'
--select * from seFrameworkNode where FrameworkID = 7
--get rid of north mason rr, and fn

--drop table #rr
create table #rr (rubricRowID bigint)
insert #rr
select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID = 9

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID = 9)
delete SERubricRow where RubricRowID in 
(
	select RubricRowID from #rr 
)
delete SEFrameworkNode where FrameworkID in (9)


update SERubricRow set BelongsToDistrict = 'NMasPrRR'
where BelongsToDistrict = '23403'


--fwid 9 is TeacherState

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C1', 1, 1, rtrim('Centering instruction on high expectations for student achievement                                               '), rtrim('PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.'))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C2', 2, 1, rtrim('Demonstrating effective teaching practices                                                                       '), rtrim('INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.                                                   '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C3', 3, 1, rtrim('Recognizing individual student learning needs and developing strategies to address those needs                   '), rtrim('REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.                                                                                      '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C4', 4, 1, rtrim('Providing clear and intentional focus on subject matter content and curriculum                                   '), rtrim('CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.                                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C5', 5, 1, rtrim('Fostering and managing a safe, positive learning environment                                                     '), rtrim('CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being                                                                        '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C6', 6, 1, rtrim('Using multiple student data elements to modify instruction and improve student learning                          '), rtrim('ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.                                                                                                            '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C7', 7, 1, rtrim('Communicating and collaborating with parents and school community                                                '), rtrim('PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (9, null,'C8', 8, 1, rtrim('Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning'), rtrim('PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.                                          '))

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) 
select t,'', p1, p2, p3, p4, '23403' from stateEval_PrePro.dbo.nMasonTeachIFW_rr

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID , rr.rubricRowID,  ROW_NUMBER() over (order by shortname, rr.title) as RN
from SEFrameworkNode fn
join stateeval_prepro.dbo.DanielsonToState dts
	on dts.criteria = CONVERT(int, (substring (shortname, 2, 1)))
join SERubricRow rr on SUBSTRING (rr.Title, 1, 2) = dts.component
where BelongsToDistrict = '23403' and FrameworkID = 9
order by ShortName, rr.title



declare @nmti bigint
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype
, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) 
VALUES('NorthMasonTeachIFW', '', '23403', 2012, 2, 1, null, 0, 1, 1)  SELECT @nmti = SCOPE_IDENTITY()


insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@nmTi, null,'D1', 1, 1, rtrim('Planning and Preparation     '), rtrim('Planning and Preparation     '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@nmTi, null,'D2', 2, 1, rtrim('The Classroom Environment    '), rtrim('The Classroom Environment    '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@nmTi, null,'D3', 3, 1, rtrim('Instruction                  '), rtrim('Instruction                  '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (@nmTi, null,'D4', 4, 1, rtrim('Professional Responsibilities'), rtrim('Professional Responsibilities'))


insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, ROW_NUMBER() over (order by rr.title) 
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 1) = substring(fn.shortname, 2, 1)
where rr.BelongsToDistrict = '23403' and fn.FrameworkID = @nmti


insert SEFrameworkPerformanceLevel(FrameworkID, PerformanceLevelID, Shortname, FullName, Description)
select @nmti, PerformanceLevelID, Shortname, FullName, Description from SEFrameworkPerformanceLevel
where FrameworkID = 9


--2372
insert seRubricRow (title, PL1Descriptor, PL2Descriptor, PL3Descriptor,PL4Descriptor, BelongsToDistrict, Description)
values (
'4f - Showing Professionalism'	
,'The teacher has little sense of ethics and professionalism and contributes to practices that are self-serving or harmful to students. The teacher fails to comply with school and district regulations and time lines.'
,'The teacher is honest and well intentioned in serving students and contributing to decisions in the school, but the teacher’s attempts to serve students are limited. The teacher complies minimally with school and district regulations, doing just enough to get by.'
,'The teacher displays a high level of ethics and professionalism in dealings with both students and colleagues and complies fully and voluntarily with school and district regulations.'
,'The teacher is proactive and assumes a leadership role in making sure that school practices and procedures ensure that all students, particularly those traditionally underserved, are honored in the school. The teacher displays the highest standards of ethical conduct and takes a leadership role in seeing that colleagues comply with school and district regulations.'
, '23403', ''
)


insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values (341, 862, 39)
insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence) values (345, 862, 22)

--2371
update SERubricRow set IsStateAligned = 0 where BelongsToDistrict = '23403'
update seRubricRow set isStateAligned = 1
where rubricrowID in 
(select rubricRowID from vRowsInFramework where FrameworkID = 9)

update SERubricRow set BelongsToDistrict = '23403'
where BelongsToDistrict = 'NMasPrRR'

--*******************************************************************************

--Insert North Thurston
--select * from SEFramework where Name like '%thur%'

truncate table #rr
select * from #rr
insert #rr
select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID in (7, 16)

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID in (7,16))
delete SERubricRow where RubricRowID in 
(
	select RubricRowID from #rr 
)
delete SEFrameworkNode where FrameworkID in (7, 16)
delete SEFrameworkPerformanceLevel where FrameworkID in (7, 16)

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(7, 1, 'UNS', rtrim ('Unsatisfactory'), 'Consistently does not meet expected levels of performance'       )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(7, 2, 'BAS', rtrim ('Basic         '), 'Occasionally meets expected  levels of performance'              )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(7, 3, 'PRO', rtrim ('Proficient    '), 'Proficient/Meets Expectations'                                   )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(7, 4, 'DIS', rtrim ('Distinguished '), 'Clearly and consistently exceeds expected levels of performance' )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(16, 1, 'UNS', rtrim ('Unsatisfactory'), 'Consistently does not meet expected levels of performance'       )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(16, 2, 'BAS', rtrim ('Basic         '), 'Occasionally meets expected  levels of performance'              )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(16, 3, 'PRO', rtrim ('Proficient    '), 'Proficient/Meets Expectations'                                   )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(16, 4, 'DIS', rtrim ('Distinguished '), 'Clearly and consistently exceeds expected levels of performance' )
--fwid 16 is TeacherState for north thurston

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C1', 1, 1, rtrim('Centering instruction on high expectations for student achievement                                               '), rtrim('PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.'))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C2', 2, 1, rtrim('Demonstrating effective teaching practices                                                                       '), rtrim('INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.                                                   '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C3', 3, 1, rtrim('Recognizing individual student learning needs and developing strategies to address those needs                   '), rtrim('REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.                                                                                      '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C4', 4, 1, rtrim('Providing clear and intentional focus on subject matter content and curriculum                                   '), rtrim('CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.                                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C5', 5, 1, rtrim('Fostering and managing a safe, positive learning environment                                                     '), rtrim('CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being                                                                        '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C6', 6, 1, rtrim('Using multiple student data elements to modify instruction and improve student learning                          '), rtrim('ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.                                                                                                            '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C7', 7, 1, rtrim('Communicating and collaborating with parents and school community                                                '), rtrim('PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.                                                                           '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (16, null,'C8', 8, 1, rtrim('Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning'), rtrim('PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.                                          '))

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) 
select t,'', p1, p2, p3, p4, '34003' from stateEval_PrePro.dbo.nThurstonTeachIFW_rr

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID , rr.rubricRowID,  ROW_NUMBER() over (order by shortname, rr.title) as RN
from SEFrameworkNode fn
join stateeval_prepro.dbo.DanielsonToState dts
	on dts.criteria = CONVERT(int, (substring (shortname, 2, 1)))
join SERubricRow rr on SUBSTRING (rr.Title, 1, 2) = dts.component
where BelongsToDistrict = '34003' and FrameworkID = 16
order by ShortName, rr.title


insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (7, null,'D1', 1, 1, rtrim('Planning and Preparation     '), rtrim('Planning and Preparation     '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (7, null,'D2', 2, 1, rtrim('The Classroom Environment    '), rtrim('The Classroom Environment    '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (7, null,'D3', 3, 1, rtrim('Instruction                  '), rtrim('Instruction                  '))
insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) values (7, null,'D4', 4, 1, rtrim('Professional Responsibilities'), rtrim('Professional Responsibilities'))


insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, ROW_NUMBER() over (order by rr.title) 
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 1) = substring(fn.shortname, 2, 1)
where rr.BelongsToDistrict = '34003' and fn.FrameworkID = 7


insert SEFrameworkPerformanceLevel(FrameworkID, PerformanceLevelID, Shortname, FullName, Description)
select 7, PerformanceLevelID, Shortname, FullName, Description from SEFrameworkPerformanceLevel
where FrameworkID = 9

update SERubricRow set IsStateAligned = 0 where BelongsToDistrict = '23403'
update seRubricRow set isStateAligned = 1
where rubricrowID in 
(select rubricRowID from vRowsInFramework where FrameworkID = 9)

--2370
update seFrameworkNode
set title = 'Domain 4: Managing Human and Fiscal Rsources' 
where FrameworkNodeID = 139

--end 765 patches ****************************************************************
*/
/*
--begin 766 patches ****************************************************************

--2373
insert seRubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence) values(298, 710, 190)
--2376
update SERubricRow set Description = '' where RubricRowID=601
--2375
update SERubricRow set title = 'Planning reflects discipline habits and thinking' where Title = 'Planning reflects disciplie habits and thinking'

--end 766 patches ****************************************************************


*/
--begin 767 patches ****************************************************************
/*
--2378
update SEFramework set FrameworkTypeID=4, Name = 'ConPrinIFW',
	Description = 'Danielson compressed to a single level' where FrameworkID = 24

insert SEFramework (Name, Description, DistrictCode, SchoolYear
, FrameworkTypeID, IFWTypeID, IsPrototype,HasBeenModified, HasBeenApproved) values
('ConPrinState', 'The state view of consortium danielson', '00000', 2012
,3, 1, 1, 0, 1)

insert SEFrameworkNode (FrameworkID, Title, ShortName, Description, Sequence, IsLeafNode)
select 30, title, shortname, description, sequence, 1
from SEFrameworkNode where FrameworkID = 2 order by sequence

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select rrfn.FrameworkNodeID, rrfn.RubricRowID, rrfn.Sequence* -1 from SERubricRow rr
join SERubricRowFrameworkNode rrfn on rr.RubricRowID = rrfn.RubricRowID
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where FrameworkID = 24


update seRubricRowFrameworkNode set FrameworkNodeId = 358 /* c1 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D1a'
update seRubricRowFrameworkNode set FrameworkNodeId = 360 /* c3 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D1b'
update seRubricRowFrameworkNode set FrameworkNodeId = 364 /* c7 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D1c'
update seRubricRowFrameworkNode set FrameworkNodeId = 359 /* c2 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D2a'
update seRubricRowFrameworkNode set FrameworkNodeId = 361 /* c4 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D2b'
update seRubricRowFrameworkNode set FrameworkNodeId = 362 /* c5 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D2c'  
update seRubricRowFrameworkNode set FrameworkNodeId = 365 /* c8 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D3a'
update seRubricRowFrameworkNode set FrameworkNodeId = 363 /* c6 */ from seRubricRowFrameworkNode rrfn join seFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID where rrfn.sequence <0 and shortname ='D4a'

update SERubricRowFrameworkNode set Sequence = Sequence * -1 where Sequence < 0

insert SEFrameworkPerformanceLevel (FrameworkID, PerformanceLevelID, Shortname, FullName, Description)
select 30, PerformanceLevelID, Shortname, FullName, Description from SEFrameworkPerformanceLevel where FrameworkID = 24

--2377
declare @s1 varchar (8000), @s2 varchar (8000), @s3 varchar(8000), @s4 varchar(8000)

select @s1 = 'Professional practice at the unsatisfactory level shows evidence of not understanding the concepts underlying individual components of the framework.  This level of practice is ineffective and inefficient and may represent practice that is harmful to student learning progress, professional learning environment or individual teaching practice.  This level requires immediate intervention.'
select @s2 = 'Professional practice at the basic level shows evidence of knowledge and skills of the framework required to practice, but performance is inconsistent over a period of time due to lack of experience, expertise, and/or commitment.  This level may be considered minimally competent for teachers early in their careers but insufficient for more experienced teachers.  This level requires specific support at both the non-tenured and tenured level of teaching.'
select @s3 = 'Professional practice at the proficient level shows evidence of thorough knowledge of all aspects of the profession.  This is successful, accomplished, professional and effective practice.  Teachers at this level thoroughly know academic content and curriculum design/development, their students, and have a wide range of professional resources.  Teaching at this level utilizes a broad repertoire of strategies and activities to support student learning.  At this level, teaching is strengthened and expanded through purposeful, collaborative sharing and learning with colleagues and ongoing self-reflection and professional improvement.'
select @s4 = 'Professional practice at the distinguished level is that of a master professional whose practices operate at a qualitatively different level from those of other professional peers.  Teaching practice at this level shows evidence of learning that is student directed, where students assume responsibility for their learning by making substantial contributions throughout the instructional process.  Ongoing, reflective teaching is demonstrated through the highest level of expertise and commitment to all students’ learning, professional challenging growth, and collaborative leadership.'

update seFrameworkPerformanceLevel set description = @s1 where performanceLevelID = 1 and frameworkID in (25, 26, 27, 28)
update seFrameworkPerformanceLevel set description = @s2 where performanceLevelID = 2 and frameworkID in (25, 26, 27, 28)
update seFrameworkPerformanceLevel set description = @s3 where performanceLevelID = 3 and frameworkID in (25, 26, 27, 28)
update seFrameworkPerformanceLevel set description = @s4 where performanceLevelID = 4 and frameworkID in (25, 26, 27, 28)

--2379 anacortes final change

update SERubricRow set PL3Descriptor = 'Teacher response to misbehavior follows classroom/building discipline procedures and is appropriate. Student misbehavior is rare.'
where RubricRowID = 634 and PL3Descriptor = 
'Teacher response to misbehavior follows classroom/building discipline procedures and is appropriate. Student behavior is rare.'
*/

--end 767 patches ****************************************************************
--begin 773 patches ******************************************************************
/*
update SERubricRow set Description = dbo.udf_StripHTML(description) from SERubricRow
where Description like '%<br />%'
update SERubricRow set Description = REPLACE (description, '&amp;', '&') where Description like '%&amp;%'
update SERubricRow set Description = REPLACE (description, '&ldquo;', '"') where Description like '%&ldquo;%'
update SERubricRow set Description = REPLACE (description, '&rdquo;', '"') where Description like '%&rdquo;%'
*/
--end 773 patches ********************************************************************
--begin 794 patches ********************************************************************
-- at dbcreate-817, reverted to dbcreate-794, and use the below to generate whatever is after 817
-- at dbcreate-818, reverted to dbcreate-794, and use the below to generate whaterev is after 818

--bugzilla 2394
/*
DECLARE @TeachState bigint, @TeachSelfState bigint, @TeachIFW bigint, @TeachSelfIFW bigint
select @teachState = frameworkID from seFramework where name = 'Consortia TS'
select @teachSelfState = frameworkID from seFramework where name = 'ConTeachSelfState'
select @teachIFW = frameworkID from seFramework where name like 'Consortium%TI'
select @teachSelfIFW = frameworkID from seFramework where name = 'Consortium TI Self'

--mark the rows you want so you can get back to them easily
update SERubricRow 
SET BelongsToDistrict='CONTIFW'
WHERE RubricRowID in (
	select rubricRowID from vRowsInFramework
	where frameworkNodeID in 
	(
		--nodes associated with SELF
		select frameworkNodeID from SEFrameworkNode fn
		where FrameworkID in (@TeachSelfState, @TeachSelfIFW)
	)
)

--this is the table of rrs to get rid of
create table #rr2394 (rubricRowID bigint)
insert #rr2394 (rubricRowID)
select rubricRowID from vRowsInFramework
where frameworkNodeID in 
(
	--nodes associated with NOT-self
	select frameworkNodeID from SEFrameworkNode fn
	where FrameworkID in (@TeachState, @TeachIFW)
)

--get rid of links associated with not-self
delete SERubricRowFrameworkNode where frameworkNodeID in 
(
	select frameworkNodeID from SEFrameworkNode fn
	where FrameworkID in (@TeachState, @TeachIFW)
)

--get rid of rrs associated with not-self
delete SERubricRow where RubricRowID in
(select RubricRowID from #rr2394)

--update rr titles so join comes out right
update SERubricRow set Title = '1b - Demonstrating Knowledge of Students' where RubricRowID = 791
update SERubricRow set Title = '2a - Creating an Environment of Respect and Rapport' where RubricRowID = 796
update SERubricRow set Title = '3b - Using Questioning and Discussion Techniques' where RubricRowID = 802

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.rubricRowID, rr.rubricRowID
from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1, 1) = substring(fn.shortname, 2, 1)
where rr.BelongsToDistrict = 'contifw' and fn.FrameworkID = @TeachIFW
and ltrim(rtrim(rr.Title)) in
	(select ltrim(rtrim(title)) from StateEval_PrePro.dbo.ConTeacherIFW_RR)
order by rr.rubricRowID


insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID, rr.rubricRowID, row_number()  over (order by fn.shortname, rr.title) as foo
from SEFrameworkNode fn
join stateeval_prePro.dbo.DanielsonToState ds on ds.criteria = CONVERT(int, SUBSTRING(fn.shortname,2,1))
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = ds.component
where rr.BelongsToDistrict = 'contifw' and fn.FrameworkID = @TeachState
and rr.Title in
	(select title from StateEval_PrePro.dbo.ConTeacherIFW_RR)
order by foo

update SERubricRow set BelongsToDistrict = '00000' where BelongsToDistrict = 'contifw'
*/
--end 794 patches ********************************************************************
--begin 825 patches ******************************************************************
-- CV Teacher Rubric edit fields to include '__N__'
-- increase title column size to 500 in seRubricRow
-- a couple of typos
-- CV Principal rubrics
-- Othello rubric for principal and teacher

/*
--bugzilla 2392
update seRubricRow set pl1Descriptor = '__1__ Not applicable. <b>  or </b>__2__  Minimum requirement not met.  <i> (Comment required) </i>'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where pl1Descriptor = 'Not applicable. <b>  or </b>  Minimum requirement not met.  <i> (Comment required) </i>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
update seRubricRow set pl2Descriptor = '__1__Assesses the resource needs of teachers and staff.__2__Understands the importance of clear expectations, structures, and procedures for managing fiscal resources.__3__Understands the school funding, budget development, and budget management processes.__4__Understands the importance of non-fiscal resources (e.g., personnel, time, materials, etc.) in the effectiveness of a school.'                                                                                                                                                                                                                                     where pl2Descriptor = '<ul><li>Assesses the resource needs of teachers and staff.</li><li>Understands the importance of clear expectations, structures, and procedures for managing fiscal resources.</li><li>Understands the school funding, budget development, and budget management processes.</li><li>Understands the importance of non-fiscal resources (e.g., personnel, time, materials, etc.) in the effectiveness of a school.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                             
update seRubricRow set pl2Descriptor = '__1__Understands the importance of open, effective communication between and within school and district administration__2__Responds to parents, teachers, and patrons in a timely manner.__3__Communicates with stakeholder groups about school initiatives and activities.'                                                                                                                                                                                                                                                                                                                                                            where pl2Descriptor = '<ul><li>Understands the importance of open, effective communication between and within school and district administration</li><li>Responds to parents, teachers, and patrons in a timely manner.</li><li>Communicates with stakeholder groups about school initiatives and activities.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                        
update seRubricRow set pl2Descriptor = '__1__Knows the district-adopted SIP format and procedures.__2__Communicates to the entire school community the importance of developing a data-driven plan.__3__Leads and guides the development of a data drivenplan using'                                                                                                                                                                                                                                                                                                                                                                                                            where pl2Descriptor = '<ul><li>Knows the district-adopted SIP format and procedures.</li><li>Communicates to the entire school community the importance of developing a data-driven plan.</li><li>Leads and guides the development of a data drivenplan using' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                        
update seRubricRow set pl2Descriptor = '__1__Understands the importance of effectively recruiting, hiring, and mentoring new staff members.__2__Adheres to district policy for teacher and staff evaluation.__3__Understands the importance of clear expectations, structures, and procedures for managing human resources.'                                                                                                                                                                                                                                                                                                                                                    where pl2Descriptor = '<ul><li>Understands the importance of effectively recruiting, hiring, and mentoring new staff members.</li><li>Adheres to district policy for teacher and staff evaluation.</li><li>Understands the importance of clear expectations, structures, and procedures for managing human resources.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                
update seRubricRow set pl2Descriptor = '__1__Articulates knowledge of curriculum, instruction, and assessments needed to initiate the implementation of the datadriven SIP.__2__Conveys a positive attitude about the staff&rsquo;s ability to implement the plan with fidelity.__3__Communicates with staff regarding the appropriate use of collaboration time.'                                                                                                                                                                                                                                                                                                              where pl2Descriptor = '<ul><li>Articulates knowledge of curriculum, instruction, and assessments needed to initiate the implementation of the datadriven SIP.</li><li>Conveys a positive attitude about the staff&rsquo;s ability to implement the plan with fidelity.</li><li>Communicates with staff regarding the appropriate use of collaboration time.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                          
update seRubricRow set pl2Descriptor = '__1__Acknowledges the importance of engaging stakeholder groups in meaningful ways.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    where pl2Descriptor = '<ul><li>Acknowledges the importance of engaging stakeholder groups in meaningful ways.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
update seRubricRow set pl2Descriptor = '__1__Identifies benchmark data points to be used in evaluating the effectiveness of the SIP.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           where pl2Descriptor = '<ul><li>Identifies benchmark data points to be used in evaluating the effectiveness of the SIP.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
update seRubricRow set pl2Descriptor = '__1__Possesses knowledge of state learning goals.__2__Initiates formal and informal discussions that address curriculum, instruction, and assessment issues.__3__Possesses knowledge of best practice of instruction and assessment.__4__Encourages and supports meaningful professional learning opportunities.__5__Recognizes a variety of formative and summative assessments for the diagnosis of learner needs.'                                                                                                                                                                                                                   where pl2Descriptor = '<ul><li>Possesses knowledge of state learning goals.</li><li>Initiates formal and informal discussions that address curriculum, instruction, and assessment issues.</li><li>Possesses knowledge of best practice of instruction and assessment.</li><li>Encourages and supports meaningful professional learning opportunities.</li><li>Recognizes a variety of formative and summative assessments for the diagnosis of learner needs.' and BelongsToDistrict = '32356'                                                                                                                                                                                                       
update seRubricRow set pl2Descriptor = '__1__Understands the importance for a school to have a shared mission, vision, beliefs, and goals.__2__Possesses well-defined ideals and beliefs about schools and schooling that align with the District Strategic Plan.__3__Understands the characteristics of a collaborative work environment.'                                                                                                                                                                                                                                                                                                                                     where pl2Descriptor = '<ul><li>Understands the importance for a school to have a shared mission, vision, beliefs, and goals.</li><li>Possesses well-defined ideals and beliefs about schools and schooling that align with the District Strategic Plan.</li><li>Understands the characteristics of a collaborative work environment.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                 
update seRubricRow set pl2Descriptor = '__1__Understands relevant research on the achievement gap.__2__Communicates and models the ideals and beliefs that teachers and staff can impact student learning and achievement for all students.__3__Engages in frequent quality interactions with underperforming students.__4__Understands how to use data to identify achievement gaps.'                                                                                                                                                                                                                                                                                          where pl2Descriptor = '<ul><li>Understands relevant research on the achievement gap.</li><li>Communicates and models the ideals and beliefs that teachers and staff can impact student learning and achievement for all students.</li><li>Engages in frequent quality interactions with underperforming students.</li><li>Understands how to use data to identify achievement gaps.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                  
update seRubricRow set pl2Descriptor = '__1__Understands the importance of both formal and informal monitoring practices.__2__Communicates knowledge of instruction, assessment and evaluation.__3__Recognizes the components of a quality lesson.'                                                                                                                                                                                                                                                                                                                                                                                                                             where pl2Descriptor = '<ul><li>Understands the importance of both formal and informal monitoring practices.</li><li>Communicates knowledge of instruction, assessment and evaluation.</li><li>Recognizes the components of a quality lesson.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                         
update seRubricRow set pl2Descriptor = '__1__Understands district policies and procedures regarding school safety.__2__Implements district policies and procedures regarding school safety.__3__Understands district policies and procedures regarding student discipline.__4__Implements district policies and procedures regarding student discipline.'                                                                                                                                                                                                                                                                                                                       where pl2Descriptor = '<ul><li>Understands district policies and procedures regarding school safety.</li><li>Implements district policies and procedures regarding school safety.</li><li>Understands district policies and procedures regarding student discipline.</li><li>Implements district policies and procedures regarding student discipline.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                               
update seRubricRow set pl2Descriptor = '__1__Demonstrates how daily lessons are consistently aligned to the state&rsquo;s standards.__2__Standards are presented to students.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where pl2Descriptor = '<ul><li>Demonstrates how daily lessons are consistently aligned to the state&rsquo;s standards.</li><li>Standards are presented to students.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
update seRubricRow set pl2Descriptor = '__1__Professionally collaborates with colleagues.__2__Frequently communicates with colleagues regarding student performance.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           where pl2Descriptor = '<ul><li>Professionally collaborates with colleagues.</li><li>Frequently communicates with colleagues regarding student performance.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl2Descriptor = '__1__Demonstrates knowledge of a core set of research-based instructional strategies.__2__Identifies instructional strategies that promote problem solving and critical thinking.__3__Understands the importance of using available technology.'                                                                                                                                                                                                                                                                                                                                                                                        where pl2Descriptor = '<ul><li>Demonstrates knowledge of a core set of research-based instructional strategies.</li><li>Identifies instructional strategies that promote problem solving and critical thinking.</li><li>Understands the importance of using available technology.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                    
update seRubricRow set pl2Descriptor = '__1__Sets professional goals directly related to professional growth.__2__Attends professional learning activities that are related directly to professional growth.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                   where pl2Descriptor = '<ul><li>Sets professional goals directly related to professional growth.</li><li>Attends professional learning activities that are related directly to professional growth.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl2Descriptor = '__1__Demonstrates an awareness of the value of feedback as a learning strategy.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        where pl2Descriptor = '<ul><li>Demonstrates an awareness of the value of feedback as a learning strategy.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
update seRubricRow set pl2Descriptor = '__1__Demonstrates knowledge of state standards.__2__Demonstrates a basic understanding of the district&rsquo;s approved curriculum.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    where pl2Descriptor = '<ul><li>Demonstrates knowledge of state standards.</li><li>Demonstrates a basic understanding of the district&rsquo;s approved curriculum.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
update seRubricRow set pl2Descriptor = '__1__Demonstrates an awareness of the needs of the intended audience.__2__Develops a plan for communicating with families regarding student performance.__3__Reads district/school-wide communications.__4__Adheres to confidentiality policies.'                                                                                                                                                                                                                                                                                                                                                                                       where pl2Descriptor = '<ul><li>Demonstrates an awareness of the needs of the intended audience.</li><li>Develops a plan for communicating with families regarding student performance.</li><li>Reads district/school-wide communications.</li><li>Adheres to confidentiality policies.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                               
update seRubricRow set pl2Descriptor = '__1__Interacts with professionalism and positive intent with students.__2__Demonstrates sensitivity to the diversity of students in the classroom.__3__Develops routines and procedures that provide a safe and orderly classroom.'                                                                                                                                                                                                                                                                                                                                                                                                     where pl2Descriptor = '<ul><li>Interacts with professionalism and positive intent with students.</li><li>Demonstrates sensitivity to the diversity of students in the classroom.</li><li>Develops routines and procedures that provide a safe and orderly classroom.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                 
update seRubricRow set pl2Descriptor = '__1__Understands the need for high expectations for all students.__2__Establishes instructional goals based on mandated assessments.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   where pl2Descriptor = '<ul><li>Understands the need for high expectations for all students.</li><li>Establishes instructional goals based on mandated assessments.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl2Descriptor = '__1__Understands the varying developmental needs of students.__2__Identifies resources to address individual student needs.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            where pl2Descriptor = '<ul><li>Understands the varying developmental needs of students.</li><li>Identifies resources to address individual student needs.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
update seRubricRow set pl2Descriptor = '__1__Demonstrates an awareness of a variety of assessment methods.__2__Communicates specified criteria to students.__3__Understands the importance of improved teaching practice and student learning based on assessment results.'                                                                                                                                                                                                                                                                                                                                                                                                     where pl2Descriptor = '<ul><li>Demonstrates an awareness of a variety of assessment methods.</li><li>Communicates specified criteria to students.</li><li>Understands the importance of improved teaching practice and student learning based on assessment results.' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                 
update seRubricRow set pl3Descriptor = '. . . and __1__ Allocates material resources in ways which support student achievement. __2__ Allocates professional learning resources in ways which support student achievement. __3__ Allocates and protects time resources in ways which support student achievement. __4__ Uses data to create, manage, and evaluate budget procedures. __5__ Communicates the structure and rationale for decisions about resource allocation.'                                                                                                                                                                                                   where pl3Descriptor = '. . . and <ul><li> Allocates material resources in ways which support student achievement. </li><li> Allocates professional learning resources in ways which support student achievement. </li><li> Allocates and protects time resources in ways which support student achievement. </li><li> Uses data to create, manage, and evaluate budget procedures. </li><li> Communicates the structure and rationale for decisions about resource allocation.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                             
update seRubricRow set pl3Descriptor = '. . . and __1__ Uses a variety of formats to communicate about student learning with stakeholders within and outside the school. __2__ Uses effective communication skills and strategies to: __3__ Enlist community support. __4__ Resolve conflicts among individuals and groups. __5__ Build common focus and collaboration to enhance student learning.'                                                                                                                                                                                                                                                                            where pl3Descriptor = '. . . and <ul><li> Uses a variety of formats to communicate about student learning with stakeholders within and outside the school. </li><li> Uses effective communication skills and strategies to: </li><li> Enlist community support. </li><li> Resolve conflicts among individuals and groups. </li><li> Build common focus and collaboration to enhance student learning.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                      
update seRubricRow set pl3Descriptor = '. . . and __1__ Leads the implementation of a data- driven plan. __2__ Continues to monitor and adjust the plan using current data from multiple sources. __3__ Provides support to teachers to implement the data-driven plan at the classroom and school level. __4__ Prioritizes the appropriate use of resources to'                                                                                                                                                                                                                                                                                                                where pl3Descriptor = '. . . and <ul><li> Leads the implementation of a data- driven plan. </li><li> Continues to monitor and adjust the plan using current data from multiple sources. </li><li> Provides support to teachers to implement the data-driven plan at the classroom and school level. </li><li> Prioritizes the appropriate use of resources to</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                              
update seRubricRow set pl3Descriptor = '. . . and __1__ Uses hiring protocols that reflect student achievement goals. __2__ Implements district personnel evaluation policies in a fair and equitable manner. __3__ Implements and enforces policies and procedures. __4__ Uses the recruitment and hiring processes strategically to further the school&rsquo;s vision and mission.'                                                                                                                                                                                                                                                                                           where pl3Descriptor = '. . . and <ul><li> Uses hiring protocols that reflect student achievement goals. </li><li> Implements district personnel evaluation policies in a fair and equitable manner. </li><li> Implements and enforces policies and procedures. </li><li> Uses the recruitment and hiring processes strategically to further the school&rsquo;s vision and mission.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                         
update seRubricRow set pl3Descriptor = '. . . and __1__ Provides support to teachers to develop and examine formative and summative data. __2__ Provides professional development around how to use data and how to analyze student work. __3__ Prioritizes the appropriate use of resources to support the goals of the School Improvement Plan. __4__ Facilitates the successful execution of the School Improvement Plan.'                                                                                                                                                                                                                                                   where pl3Descriptor = '. . . and <ul><li> Provides support to teachers to develop and examine formative and summative data. </li><li> Provides professional development around how to use data and how to analyze student work. </li><li> Prioritizes the appropriate use of resources to support the goals of the School Improvement Plan. </li><li> Facilitates the successful execution of the School Improvement Plan.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                 
update seRubricRow set pl3Descriptor = '. . . and __1__ Provides opportunities for stakeholder groups to become involved in the school. __2__ Collaborates with administrative colleagues.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where pl3Descriptor = '. . . and <ul><li> Provides opportunities for stakeholder groups to become involved in the school. </li><li> Collaborates with administrative colleagues.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl3Descriptor = '. . . and __1__ Uses multiple forms of relevant data to evaluate the effectiveness of the plan to improve student learning. __2__ Uses available data to adapt and revise the SIP as needed.'                                                                                                                                                                                                                                                                                                                                                                                                                                           where pl3Descriptor = '. . . and <ul><li> Uses multiple forms of relevant data to evaluate the effectiveness of the plan to improve student learning. </li><li> Uses available data to adapt and revise the SIP as needed.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                 
update seRubricRow set pl3Descriptor = '. . . and __1__ Guides and/or instructs professional learning activities to address curriculum, instruction, and assessment issues that build on teachers&rsquo; strengths in reaching all students. __2__ Initiates and leads discussions regarding quality of student work within and across teams. __3__ Engages with staff in meaningful professional learning. __4__ Sets expectations that teachers implement appropriate learning interventions to improve student learning. __5__ Monitors teachers&rsquo; implementation of learning interventions and provides corrective support when necessary.'                            where pl3Descriptor = '. . . and <ul><li> Guides and/or instructs professional learning activities to address curriculum, instruction, and assessment issues that build on teachers&rsquo; strengths in reaching all students. </li><li> Initiates and leads discussions regarding quality of student work within and across teams. </li><li> Engages with staff in meaningful professional learning. </li><li> Sets expectations that teachers implement appropriate learning interventions to improve student learning. </li><li> Monitors teachers&rsquo; implementation of learning interventions and provides corrective support when necessary.</li></ul>' and BelongsToDistrict = '32356'      
update seRubricRow set pl3Descriptor = '. . . and __1__ Leads the development of a shared mission, vision, beliefs, and goals for the school aligned with the School Improvement Plan (SIP) and the District Strategic Plan. __2__ Communicates shared mission, vision, beliefs, and goals to the district and community stakeholders. __3__ Creates an environment of collaboration and trust throughout the school.'                                                                                                                                                                                                                                                          where pl3Descriptor = '. . . and <ul><li> Leads the development of a shared mission, vision, beliefs, and goals for the school aligned with the School Improvement Plan (SIP) and the District Strategic Plan. </li><li> Communicates shared mission, vision, beliefs, and goals to the district and community stakeholders. </li><li> Creates an environment of collaboration and trust throughout the school.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                            
update seRubricRow set pl3Descriptor = '. . . and __1__ Implements school-wide practices that foster understanding and respect for cultural diversity, celebrates the contributions of diverse groups, and addresses closing the achievement gap. __2__ Analyzes multiple data sources of sub-population groups of students to set targeted SIP goals and apply intervention programs to close achievement gaps. (Including effects of poverty, trauma, homelessness, etc.) __3__ Actively participates in the development of district goals, strategic planning, and initiatives designed to improve student achievement and address achievement gaps.'                        where pl3Descriptor = '. . . and <ul><li> Implements school-wide practices that foster understanding and respect for cultural diversity, celebrates the contributions of diverse groups, and addresses closing the achievement gap. </li><li> Analyzes multiple data sources of sub-population groups of students to set targeted SIP goals and apply intervention programs to close achievement gaps. (Including effects of poverty, trauma, homelessness, etc.) </li><li> Actively participates in the development of district goals, strategic planning, and initiatives designed to improve student achievement and address achievement gaps.</li></ul>' and BelongsToDistrict = '32356'          
update seRubricRow set pl3Descriptor = '. . . and __1__ Uses a variety of formal and informal monitoring practices. __2__ Implements the personnel evaluation system with fidelity and consistency. __3__ Initiates opportunities for teachers to engage in professional dialog and activities to support instruction and assessment practices. __4__ Provides opportunities for targeted professional learning as appropriate.'                                                                                                                                                                                                                                                where pl3Descriptor = '. . . and <ul><li> Uses a variety of formal and informal monitoring practices. </li><li> Implements the personnel evaluation system with fidelity and consistency. </li><li> Initiates opportunities for teachers to engage in professional dialog and activities to support instruction and assessment practices. </li><li> Provides opportunities for targeted professional learning as appropriate.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                              
update seRubricRow set pl3Descriptor = '. . . and __1__ Reviews, analyzes, and implements school safety and discipline plans based on school data. __2__ Establishes and enforces policies and routines that maximize opportunities for all students to learn.'                                                                                                                                                                                                                                                                                                                                                                                                                 where pl3Descriptor = '. . . and <ul><li> Reviews, analyzes, and implements school safety and discipline plans based on school data. </li><li> Establishes and enforces policies and routines that maximize opportunities for all students to learn.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                       
update seRubricRow set pl3Descriptor = '. . . and __1__ Assists students in understanding the relevance of the standards. __2__ Provides students with an appropriately challenging and rigorous curriculum. __3__ Communicates standards in learner friendly language.'                                                                                                                                                                                                                                                                                                                                                                                                        where pl3Descriptor = '. . . and <ul><li> Assists students in understanding the relevance of the standards. </li><li> Provides students with an appropriately challenging and rigorous curriculum. </li><li> Communicates standards in learner friendly language.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                          
update seRubricRow set pl3Descriptor = '. . . and __1__ Collaborates with colleagues about best practices for improved student learning. __2__ Professionally and confidentially shares with appropriate colleague&rsquo;s information that explains or helps inform about students&rsquo; academic performance.'                                                                                                                                                                                                                                                                                                                                                               where pl3Descriptor = '. . . and <ul><li> Collaborates with colleagues about best practices for improved student learning. </li><li> Professionally and confidentially shares with appropriate colleague&rsquo;s information that explains or helps inform about students&rsquo; academic performance.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                     
update seRubricRow set pl3Descriptor = '. . . and __1__ Appropriately uses researchbased instructional strategies and resources necessary to meet the needs of all students. __2__ Monitors and adjusts instructional strategies within lessons based on anecdotal evidence. __3__ Provides opportunities for students to extend and refine knowledge. __4__ Provides opportunities for students to use knowledge meaningfully through a variety of strategies. __5__ Utilizes available instructional technology.'                                                                                                                                                             where pl3Descriptor = '. . . and <ul><li> Appropriately uses researchbased instructional strategies and resources necessary to meet the needs of all students. </li><li> Monitors and adjusts instructional strategies within lessons based on anecdotal evidence. </li><li> Provides opportunities for students to extend and refine knowledge. </li><li> Provides opportunities for students to use knowledge meaningfully through a variety of strategies. </li><li> Utilizes available instructional technology.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                       
update seRubricRow set pl3Descriptor = '. . . and __1__ Contributes to the establishment of professional working relationships. __2__ Proactively seeks resources and professional development opportunities to improve professional practice.'                                                                                                                                                                                                                                                                                                                                                                                                                                 where pl3Descriptor = '. . . and <ul><li> Contributes to the establishment of professional working relationships. </li><li> Proactively seeks resources and professional development opportunities to improve professional practice.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                       
update seRubricRow set pl3Descriptor = '. . . and __1__ Provides learners with timely and consistent feedback based on on-going formative assessments.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where pl3Descriptor = '. . . and <ul><li> Provides learners with timely and consistent feedback based on on-going formative assessments.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl3Descriptor = '__1__Utilizes district approved curriculum and state standards in both short term and long term lesson development. __2__ Utilizes instructional time to promote understanding of content.'                                                                                                                                                                                                                                                                                                                                                                                                                                             where pl3Descriptor = '<ul><li>Utilizes district approved curriculum and state standards in both short term and long term lesson development. </li><li> Utilizes instructional time to promote understanding of content.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl3Descriptor = '. . . and __1__ Communicates in a timely and consistent manner with students, parents, guardians for the benefit of students. __2__ Supports district/school mission and goals.'                                                                                                                                                                                                                                                                                                                                                                                                                                                        where pl3Descriptor = '. . . and <ul><li> Communicates in a timely and consistent manner with students, parents, guardians for the benefit of students. </li><li> Supports district/school mission and goals.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                              
update seRubricRow set pl3Descriptor = '. . . and __1__ Assures routines and procedures are in place that help students assume responsibility for themselves. __2__ Routinely encourages contributions of all students. __3__ Supports students of various backgrounds and abilities.'                                                                                                                                                                                                                                                                                                                                                                                          where pl3Descriptor = '. . . and <ul><li> Assures routines and procedures are in place that help students assume responsibility for themselves. </li><li> Routinely encourages contributions of all students. </li><li> Supports students of various backgrounds and abilities.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                            
update seRubricRow set pl3Descriptor = '. . . and __1__ Communicates high expectations for all students. __2__ Establishes instructional goals based on multiple measures of student achievement data. __3__ Promotes student involvement in the goal-setting process.'                                                                                                                                                                                                                                                                                                                                                                                                         where pl3Descriptor = '. . . and <ul><li> Communicates high expectations for all students. </li><li> Establishes instructional goals based on multiple measures of student achievement data. </li><li> Promotes student involvement in the goal-setting process.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl3Descriptor = '. . . and __1__ Utilizes available resources needed to address individual student needs. __2__ Differentiates instruction based on regular review of individual student work.'                                                                                                                                                                                                                                                                                                                                                                                                                                                          where pl3Descriptor = '. . . and <ul><li> Utilizes available resources needed to address individual student needs. </li><li> Differentiates instruction based on regular review of individual student work.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                
update seRubricRow set pl3Descriptor = '. . . and __1__ Utilizes a variety of assessments that are aligned with learning targets and state standards. __2__ Uses formal and informal assessment data to inform lesson planning and instructional decisions.'                                                                                                                                                                                                                                                                                                                                                                                                                    where pl3Descriptor = '. . . and <ul><li> Utilizes a variety of assessments that are aligned with learning targets and state standards. </li><li> Uses formal and informal assessment data to inform lesson planning and instructional decisions.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                          
update seRubricRow set pl4Descriptor = '. . . and __1__ Implements procedures that ensure the long-term viability of effective programs and practices. __2__ Implements process for input on resource allocation and budgetary decisions. '                                                                                                                                                                                                                                                                                                                                                                                                                                     where pl4Descriptor = '. . . and <ul><li> Implements procedures that ensure the long-term viability of effective programs and practices. </li><li> Implements process for input on resource allocation and budgetary decisions. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl4Descriptor = '. . . and __1__ Systematically monitors and takes steps to ensure improved communication with the school community at large. __2__ Models effective communication and expects staff to also communicate on a regular basis.  '                                                                                                                                                                                                                                                                                                                                                                                                          where pl4Descriptor = '. . . and <ul><li> Systematically monitors and takes steps to ensure improved communication with the school community at large. </li><li> Models effective communication and expects staff to also communicate on a regular basis.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                
update seRubricRow set pl4Descriptor = '. . . and __1__ Leads the analysis of the evaluation of the data-driven plan at the classroom and school level. __2__ Empowers staff to participate in the development and implementation of the SIP. __3__ Ensures that the goals of the SIP are implemented with fidelity and monitored frequently.  '                                                                                                                                                                                                                                                                                                                                where pl4Descriptor = '. . . and <ul><li> Leads the analysis of the evaluation of the data-driven plan at the classroom and school level. </li><li> Empowers staff to participate in the development and implementation of the SIP. </li><li> Ensures that the goals of the SIP are implemented with fidelity and monitored frequently.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                  
update seRubricRow set pl4Descriptor = '. . . and __1__ Facilitates ongoing support for new staff members and those who are taking on new or additional responsibilities and leadership roles. __2__ Optimizes the school&rsquo;s human capital and the intangible assets of staff members to maximize opportunities for student achievement. __3__ Systematically reviews and adjusts expectations and procedures on an ongoing basis.  '                                                                                                                                                                                                                                      where pl4Descriptor = '. . . and <ul><li> Facilitates ongoing support for new staff members and those who are taking on new or additional responsibilities and leadership roles. </li><li> Optimizes the school&rsquo;s human capital and the intangible assets of staff members to maximize opportunities for student achievement. </li><li> Systematically reviews and adjusts expectations and procedures on an ongoing basis.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                        
update seRubricRow set pl4Descriptor = '. . . and __1__ Advocates for sustainable and continuous school improvement. __2__ Fosters school and community commitment to the principles of sustainability and continuous improvement.'                                                                                                                                                                                                                                                                                                                                                                                                                                             where pl4Descriptor = '. . . and <ul><li> Advocates for sustainable and continuous school improvement. </li><li> Fosters school and community commitment to the principles of sustainability and continuous improvement.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl4Descriptor = '. . . and __1__ Optimizes stakeholder involvement to provide learning opportunities for staff and students. __2__ Engages the school community in the implementation of district strategic plan.  '                                                                                                                                                                                                                                                                                                                                                                                                                                     where pl4Descriptor = '. . . and <ul><li> Optimizes stakeholder involvement to provide learning opportunities for staff and students. </li><li> Engages the school community in the implementation of district strategic plan.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl4Descriptor = '. . . and __1__ Models a commitment to continuous improvement through a systematic analysis of data. __2__ Builds a school community where stakeholders are encouraged to understand and have a voice in the development and assessment of the SIP. '                                                                                                                                                                                                                                                                                                                                                                                   where pl4Descriptor = '. . . and <ul><li> Models a commitment to continuous improvement through a systematic analysis of data. </li><li> Builds a school community where stakeholders are encouraged to understand and have a voice in the development and assessment of the SIP. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                         
update seRubricRow set pl4Descriptor = '. . . and __1__ Models knowledge of researchbased best practice and expects staff to have an understanding of curriculum alignment processes within and across curriculum areas and grade levels. __2__ Ensures that staff have multiple and various learning experiences to promote best practice.  '                                                                                                                                                                                                                                                                                                                                  where pl4Descriptor = '. . . and <ul><li> Models knowledge of researchbased best practice and expects staff to have an understanding of curriculum alignment processes within and across curriculum areas and grade levels. </li><li> Ensures that staff have multiple and various learning experiences to promote best practice.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                        
update seRubricRow set pl4Descriptor = '. . . and __1__ Continually evaluates the shared mission, vision, beliefs, and goals for the school that are aligned with the SIP and the District Strategic Plan and makes adaptations as appropriate. __2__ Ensures that mission, vision, and goals drive decisionmaking and school culture. __3__ Facilitates and sustains an environment of collaboration and trust to positively impact student achievement.  '                                                                                                                                                                                                                    where pl4Descriptor = '. . . and <ul><li> Continually evaluates the shared mission, vision, beliefs, and goals for the school that are aligned with the SIP and the District Strategic Plan and makes adaptations as appropriate. </li><li> Ensures that mission, vision, and goals drive decisionmaking and school culture. </li><li> Facilitates and sustains an environment of collaboration and trust to positively impact student achievement.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                      
update seRubricRow set pl4Descriptor = '. . . and __1__ Continuously works with staff to increase staff understanding of how to close the achievement gap. __2__ Works to build the collective efficacy of staff through shared understandings about students. __3__ Systematically monitors student achievement of underperforming populations of students. __4__ Optimizes school programs and community resources to integrate community, family language, and culture into the school to support the students'' academic progress.  '                                                                                                                                       where pl4Descriptor = '. . . and <ul><li> Continuously works with staff to increase staff understanding of how to close the achievement gap. </li><li> Works to build the collective efficacy of staff through shared understandings about students. </li><li> Systematically monitors student achievement of underperforming populations of students. </li><li> Optimizes school programs and community resources to integrate community, family language, and culture into the school to support the students'' academic progress.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                     
update seRubricRow set pl4Descriptor = '. . . and __1__ Monitors the fidelity and consistency of the implementation of researchbased practice. __2__ Assists staff in monitoring and analyzing their own practice. __3__ Empowers staff to reflect on the instructional skills and knowledge needed to positively impact student achievement.  '                                                                                                                                                                                                                                                                                                                                where pl4Descriptor = '. . . and <ul><li> Monitors the fidelity and consistency of the implementation of researchbased practice. </li><li> Assists staff in monitoring and analyzing their own practice. </li><li> Empowers staff to reflect on the instructional skills and knowledge needed to positively impact student achievement.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                  
update seRubricRow set pl4Descriptor = '. . . and __1__ Ensures an orderly environment to maximize student learning.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           where pl4Descriptor = '. . . and <ul><li> Ensures an orderly environment to maximize student learning.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
update seRubricRow set pl4Descriptor = '. . . and __1__ Consistently provides opportunities for students to communicate their understanding of the standards.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where pl4Descriptor = '. . . and <ul><li> Consistently provides opportunities for students to communicate their understanding of the standards.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
update seRubricRow set pl4Descriptor = '. . . and __1__ Promotes the success of all students through a focus on teamwork, trust, and collective efficacy. __2__ Provides leadership in facilitating collaborative and collegial processes.'                                                                                                                                                                                                                                                                                                                                                                                                                                     where pl4Descriptor = '. . . and <ul><li> Promotes the success of all students through a focus on teamwork, trust, and collective efficacy. </li><li> Provides leadership in facilitating collaborative and collegial processes.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl4Descriptor = '. . . and __1__ Intentionally selects and implements instructional strategy for the cognitive requirements of the learning objective or lesson. __2__ Provides students with multiple exposures to tasks that build skills and knowledge. __3__ Purposefully assists students to incorporate the knowledge and skill from other academic disciplines. __4__ Ensures that students can articulate procedures and strategies for becoming life-long problem solvers and critical thinkers. __5__ Consistently utilizes emerging research and new and innovative instructional materials and available technologies.'                      where pl4Descriptor = '. . . and <ul><li> Intentionally selects and implements instructional strategy for the cognitive requirements of the learning objective or lesson. </li><li> Provides students with multiple exposures to tasks that build skills and knowledge. </li><li> Purposefully assists students to incorporate the knowledge and skill from other academic disciplines. </li><li> Ensures that students can articulate procedures and strategies for becoming life-long problem solvers and critical thinkers. </li><li> Consistently utilizes emerging research and new and innovative instructional materials and available technologies.</li></ul>' and BelongsToDistrict = '32356'
update seRubricRow set pl4Descriptor = '. . . and __1__ Provides leadership for the professional learning of colleagues in the use of researchbased instructional strategies. '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 where pl4Descriptor = '. . . and <ul><li> Provides leadership for the professional learning of colleagues in the use of researchbased instructional strategies. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl4Descriptor = '. . . and __1__ Creates opportunities for learners to monitor and analyze their own progress. '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where pl4Descriptor = '. . . and <ul><li> Creates opportunities for learners to monitor and analyze their own progress. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
update seRubricRow set pl4Descriptor = '__1__Continually provides leadership in the development and/or implementation of district curriculum. '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 where pl4Descriptor = '<ul><li>Continually provides leadership in the development and/or implementation of district curriculum. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
update seRubricRow set pl4Descriptor = '. . . and __1__ Builds relationships with parents and community by providing opportunities for twoway communication. __2__ Communicates with the other professional educators within the school to promote improving individual student performance.'                                                                                                                                                                                                                                                                                                                                                                                   where pl4Descriptor = '. . . and <ul><li> Builds relationships with parents and community by providing opportunities for twoway communication. </li><li> Communicates with the other professional educators within the school to promote improving individual student performance.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                         
update seRubricRow set pl4Descriptor = '. . . and __1__ Monitors and adjusts routines and procedures based on classroom dynamics. __2__ Establishes a classroom community that empowers students to collaborate and maintain a safe and supportive environment.'                                                                                                                                                                                                                                                                                                                                                                                                                where pl4Descriptor = '. . . and <ul><li> Monitors and adjusts routines and procedures based on classroom dynamics. </li><li> Establishes a classroom community that empowers students to collaborate and maintain a safe and supportive environment.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                      
update seRubricRow set pl4Descriptor = '. . . and __1__ Ensures that students can communicate expectations for learning. __2__ Consistently monitors student growth. __3__ Consistently adjusts student goals based on ongoing use of achievement data. '                                                                                                                                                                                                                                                                                                                                                                                                                       where pl4Descriptor = '. . . and <ul><li> Ensures that students can communicate expectations for learning. </li><li> Consistently monitors student growth. </li><li> Consistently adjusts student goals based on ongoing use of achievement data. </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                         
update seRubricRow set pl4Descriptor = '. . . and __1__ Consistently demonstrates an understanding of students&rsquo; unique learning abilities and appropriately addresses needs for optimal student learning. __2__ Explicitly demonstrates how new learning builds on the prior learning of individual students.'                                                                                                                                                                                                                                                                                                                                                            where pl4Descriptor = '. . . and <ul><li> Consistently demonstrates an understanding of students&rsquo; unique learning abilities and appropriately addresses needs for optimal student learning. </li><li> Explicitly demonstrates how new learning builds on the prior learning of individual students.</li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                  
update seRubricRow set pl4Descriptor = '. . . and __1__ Models the use of assessment information to adjust instructional practice for others. __2__ Empowers students to engage in self-assessment.  '                                                                                                                                                                                                                                                                                                                                                                                                                                                                          where pl4Descriptor = '. . . and <ul><li> Models the use of assessment information to adjust instructional practice for others. </li><li> Empowers students to engage in self-assessment.  </li></ul>' and BelongsToDistrict = '32356'                                                                                                                                                                                                                                                                                                                                                                                                                                                                


--******************************************************************
-- bugzilla 2291
update SERubricRow set Title = REPLACE(title, '<br />', '') where BelongsToDistrict = 32356
--******************************************************************
-- bugzilla 2388
ALTER Table SERubricRow Alter Column title  varchar (500)
UPDATE seRubricRow set title=
'b. Teachers strive to improve professional practice. Teachers participate in professional learning that meets the needs of students and their own <br />  professional growth. Teachers actively investigate and consider new ideas that improve teaching and learning'
where BelongsToDistrict = '32356' and title like '%le' 

--***************************************
--bugzilla 2396 - cv principal rubric

create table #t (keyx varchar (20), tx varchar(500), ex varchar(max), l1 varchar(max), l2 varchar(max), l3 varchar(max), l4 varchar(max))

--this loads a lot of extra records, but was easy to edit...

insert #t(keyx) values ('1-1') update #t set tx='c1|Principals articulate and model a shared mission, vision, beliefs, and goals throughout the entire school community.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx = '1-1'
insert #t(keyx) values ('1-1') update #t set l1='c1|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '1-1'
insert #t(keyx) values ('1-1') update #t set l2='c1|__1__ Understands the importance for a school to have a shared mission, vision, beliefs, and goals. __2__ Possesses well-defined ideals and beliefs about schools and schooling that align with the District Strategic Plan.                                                                      __3__ Understands the characteristics of a collaborative work environment.'                                                                                                                                                                                                                                                          where keyx = '1-1'
insert #t(keyx) values ('1-1') update #t set l3='c1|<b>...and</b> __1__ Leads the development of a shared mission, vision, beliefs, and goals for the school aligned with the School Improvement Plan (SIP) and the District Strategic Plan. __2__ Communicates shared mission, vision, beliefs, and goals to the district and community stakeholders.                                                                                     __3__ Creates an environment of collaboration and trust throughout the school.'                                                                                                                                                                 where keyx = '1-1'
insert #t(keyx) values ('1-1') update #t set l4='c1|<b>...and</b> __1__ Continually evaluates the shared mission, vision, beliefs, and goals for the school that are aligned with the SIP and the District Strategic Plan and makes adaptations as appropriate. __2__ Ensures that mission, vision, and goals drive decision-making and school culture.                                                                                                       __3__ Facilitates and sustains an environment of collaboration and trust to positively impact student achievement.'                                                                                                          where keyx = '1-1'
insert #t(keyx) values ('1-1') update #t set ex='c1|Examples of Evidence: SIP, belief statements, Professional Learning Community (PLC) summary, collaboration minutes, newsletters, agendas, surveys, signs/posters of vision, mission'                                                                                                                                                                                                                                                                                                                                                                                                                                                   where keyx = '1-1'
insert #t(keyx) values ('2-1') update #t set tx='c2|Principals provide for a safe and orderly environment.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                where keyx = '2-1'
insert #t(keyx) values ('2-1') update #t set l1='c2|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '2-1'
insert #t(keyx) values ('2-1') update #t set l2='c2|__1__ Understands district policies and procedures regarding school safety. __2__ Implements district policies and procedures regarding school safety. __3__ Understands district policies and procedures regarding student discipline. __4__ Implements district policies and procedures regarding student discipline.'                                                                                                                                                                                                                                                                                                               where keyx = '2-1'
insert #t(keyx) values ('2-1') update #t set l3='c2|<b>...and</b> __1__ Reviews, analyzes, and implements school safety and discipline plans based on school data. __2__ Establishes and enforces policies and routines that maximize opportunities for all students to learn.'                                                                                                                                                                                                                                                                                                                                                                                                            where keyx = '2-1'
insert #t(keyx) values ('2-1') update #t set l4='c2|<b>...and</b> __1__ Ensures an orderly environment to maximize student learning.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      where keyx = '2-1'
insert #t(keyx) values ('2-1') update #t set ex='c2|Examples of Evidence: Discipline/incident data, safety meeting agendas/minutes, referral data, drill documentation, surveys of parents, parent communications, systems documents'                                                                                                                                                                                                                                                                                                                                                                                                                                                      where keyx = '2-1'
insert #t(keyx) values ('3-1') update #t set tx='c3|Principals lead the development, implementation and evaluation of a data driven plan. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                                                                                                                            where keyx = '3-1'
insert #t(keyx) values ('3-1') update #t set l1='c3|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '3-1'
insert #t(keyx) values ('3-1') update #t set l2='c3|__1__ Knows the district-adopted SIP format and procedures. __2__ Communicates to the entire school community the importance of developing a data-driven plan. __3__ Leads and guides the development of a data driven-plan using multiple sources of data. __4__ Identifies benchmark data points to be used in evaluating the effectiveness of the School Improvement Plan.'                                                                                                                                                                                                                                                         where keyx = '3-1'
insert #t(keyx) values ('3-1') update #t set l3='c3|. . . and __1__ Continues to monitor and adjust the effectiveness of the plan using current data from multiple sources. __2__ Provides support to teachers to implement the data-driven plan at the classroom and school level. __3__ Prioritizes the appropriate use of resources to support the data-driven plan. __4__ Facilitates the successful execution of the School Improvement Plan.'                                                                                                                                                                                                                                        where keyx = '3-1'
insert #t(keyx) values ('3-1') update #t set l4='c3|<b>...and</b> __1__ Ensures that the goals of the School Improvement Plan are implemented with fidelity and monitored frequently. __2__ Builds a school community where stakeholders are encouraged to understand and have a voice in evaluating the effectiveness of the School Improvement Plan. __3__ Models a commitment to continuous improvement through analysis of data.'                                                                                                                                                                                                                                                      where keyx = '3-1'
insert #t(keyx) values ('3-1') update #t set ex='c3|Examples of Evidence: SIP, leadership team notes, newsletters, data, school websites, assessment walls, agendas, leadership minutes'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   where keyx = '3-1'
insert #t(keyx) values ('4-1') update #t set tx='c4|Principals are able to communicate research-based best practices for curriculum, instruction and assessment to staff in order to improve student learning. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                                                       where keyx = '4-1'
insert #t(keyx) values ('4-1') update #t set l1='c4|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '4-1'
insert #t(keyx) values ('4-1') update #t set l2='c4|__1__ Possesses knowledge of state learning goals. __2__ Initiates formal and informal discussions that address curriculum, instruction, and assessment issues. __3__ Possesses knowledge of best practice of instruction and assessment. __4__ Encourages and supports meaningful professional learning opportunities. __5__ Recognizes a variety of formative and summative assessments for the diagnosis of learner needs. __6__ Sets expectations that teachers implement appropriate learning interventions to improve student learning.'                                                                                         where keyx = '4-1'
insert #t(keyx) values ('4-1') update #t set l3='c4|<b>...and</b>  __1__ Guides and/or instructs professional learning activities to address curriculum, instruction, and assessment issues that build on teachers’ strengths in reaching all students. __2__ Ensures discussions occur regarding student work within and across teams. __3__ Engages with staff in meaningful professional learning. __4__ Monitors teachers’ implementation of learning interventions and provides support when necessary.'                                                                                                                                                                              where keyx = '4-1'
insert #t(keyx) values ('4-1') update #t set l4='c4|<b>...and</b>  __1__ Models knowledge of research-based best practice and expects staff to have an understanding of curriculum alignment processes within and across curriculum areas and grade levels. __2__ Ensures that staff have multiple and various learning experiences to promote best practice.'                                                                                                                                                                                                                                                                                                                             where keyx = '4-1'
insert #t(keyx) values ('4-1') update #t set ex='c4|Examples of evidence: Collaboration documentation, leadership team or staff meeting agendas/minutes, staff handbook, rubrics, best practice initiatives, walk through data, book studies'                                                                                                                                                                                                                                                                                                                                                                                                                                              where keyx = '4-1'
insert #t(keyx) values ('5-1') update #t set tx='c5|Principals monitor, assist, and evaluate the implementation of effective instruction and assessment practices and the impact on student learning. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                                                                where keyx = '5-1'
insert #t(keyx) values ('5-1') update #t set l1='c5|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '5-1'
insert #t(keyx) values ('5-1') update #t set l2='c5|__1__ Understands the importance of both formal and informal monitoring practices. __2__ Communicates knowledge of instruction, assessment and evaluation. __3__ Recognizes the components of a quality lesson.'                                                                                                                                                                                                                                                                                                                                                                                                                       where keyx = '5-1'
insert #t(keyx) values ('5-1') update #t set l3='c5|<b>...and</b> __1__ Uses a variety of formal and informal monitoring practices. __2__ Initiates opportunities for teachers to engage in professional dialog and activities to support instruction and assessment practices. __3__ Provides opportunities for targeted professional learning as appropriate.'                                                                                                                                                                                                                                                                                                                           where keyx = '5-1'
insert #t(keyx) values ('5-1') update #t set l4='c5|<b>...and</b> __1__ Monitors the fidelity and consistency of the implementation of research-based practice. __2__ Empowers staff to reflect on the instructional skills and knowledge needed to positively impact student achievement.'                                                                                                                                                                                                                                                                                                                                                                                                where keyx = '5-1'
insert #t(keyx) values ('5-1') update #t set ex='c5|Examples of evidence: SIP, assessment analysis, lesson plan analysis, informal observations, formal observations, documented conversations'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            where keyx = '5-1'
insert #t(keyx) values ('6-1') update #t set tx='c6|a. Principals establish processes for making sound budget decisions. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               where keyx = '6-1'
insert #t(keyx) values ('6-1') update #t set l1='c6|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '6-1'
insert #t(keyx) values ('6-1') update #t set l2='c6|__1__ Assesses the resource needs of teachers and staff. __2__ Understands the importance of clear expectations, structures, and procedures for managing fiscal resources. __3__ Understands the school funding, budget development, and budget management processes. __4__ Understands the importance of non-fiscal resources (e.g., personnel, time, materials, etc.) in the effectiveness of a school.'                                                                                                                                                                                                                             where keyx = '6-1'
insert #t(keyx) values ('6-1') update #t set l3='c6|<b>...and</b> __1__ Allocates material resources in ways which support student achievement. __2__ Allocates professional learning resources in ways which support student achievement. __3__ Allocates and protects time resources in ways which support student achievement.'                                                                                                                                                                                                                                                                                                                                                         where keyx = '6-1'
insert #t(keyx) values ('6-1') update #t set l4='c6|<b>...and</b> __1__ Implements procedures that ensure the long-term viability of effective programs and practices. __2__ Implements process for input on resource allocation and budgetary decisions. __3__ Communicates the structure and rationale for decisions about resource allocation.'                                                                                                                                                                                                                                                                                                                                         where keyx = '6-1'
insert #t(keyx) values ('6-1') update #t set ex='c6|Examples of evidence: SIP, budget plan, leadership team agendas/minutes, surveys, examples of protocol, Associated Student Body (ASB) protocols'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       where keyx = '6-1'
insert #t(keyx) values ('6-2') update #t set tx='c6|b. Principals establish and follow standard operating principles and routines for recruitment, hiring, and supporting staff, and for implementing the district’s personnel evaluation system. Unsatisfactory (Comment required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                    where keyx = '6-2'
insert #t(keyx) values ('6-2') update #t set l1='c6|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '6-2'
insert #t(keyx) values ('6-2') update #t set l2='c6|__1__ Understands the importance of effectively recruiting, hiring, and mentoring new staff members. __2__ Adheres to district policy for teacher and staff evaluation. __3__ Understands the importance of clear expectations, structures, and procedures for managing human resources.'                                                                                                                                                                                                                                                                                                                                              where keyx = '6-2'
insert #t(keyx) values ('6-2') update #t set l3='c6|<b>...and</b> __1__ Uses hiring protocols that reflect student achievement goals. __2__ Implements district personnel evaluation policies in a fair and equitable manner. __3__ Implements and enforces policies and procedures. __4__ Uses the hiring processes strategically to further the school’s vision and mission.'                                                                                                                                                                                                                                                                                                            where keyx = '6-2'
insert #t(keyx) values ('6-2') update #t set l4='c6|<b>...and</b> __1__ Facilitates ongoing support for new staff members and those who are taking on new or additional responsibilities and leadership roles. __2__ Optimizes the school’s human capital and the intangible assets of staff members to maximize opportunities for student achievement. __3__ Systematically reviews and adjusts expectations and procedures on an ongoing basis.'                                                                                                                                                                                                                                         where keyx = '6-2'
insert #t(keyx) values ('6-2') update #t set ex='c6|Examples of evidence: Knowledge of teacher contract, interview question bank, evidence of available trainings, evidence of systems in place, meeting notes of conversations'                                                                                                                                                                                                                                                                                                                                                                                                                                                           where keyx = '6-2'
insert #t(keyx) values ('7-1') update #t set tx='c7|a. Principals establish strong lines of communication with parents, stakeholders, teachers, staff, and students. Principals keep lines of communication open and serve as an advocate and spokesperson for the school to all stakeholders. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                       where keyx = '7-1'
insert #t(keyx) values ('7-1') update #t set l1='c7|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '7-1'
insert #t(keyx) values ('7-1') update #t set l2='c7|__1__ Understands the importance of open, effective communication between and within school and district administration __2__ Responds to parents, teachers, and patrons in a timely manner. __3__ Communicates with stakeholder groups about school initiatives and activities.'                                                                                                                                                                                                                                                                                                                                                      where keyx = '7-1'
insert #t(keyx) values ('7-1') update #t set l3='c7|<b>...and</b> __1__ Uses a variety of formats to communicate about student learning with stakeholders within and outside the school. __2__ Uses effective communication skills and strategies to: __3__ Enlist community support. __4__ Resolve conflicts among individuals and groups. __5__ Build common focus and collaboration to enhance student learning.'                                                                                                                                                                                                                                                                       where keyx = '7-1'
insert #t(keyx) values ('7-1') update #t set l4='c7|<b>...and</b> __1__ Systematically monitors and takes steps to ensure improved communication with the school community at large. __2__ Models effective communication and expects staff to also communicate on a regular basis.'                                                                                                                                                                                                                                                                                                                                                                                                       where keyx = '7-1'
insert #t(keyx) values ('7-1') update #t set ex='c7|Examples of evidence: Surveys, newsletters, logs, evidence of procedures in place, information dissemination processes, evidence of clear expectations for staff'                                                                                                                                                                                                                                                                                                                                                                                                                                                                      where keyx = '7-1'
insert #t(keyx) values ('7-2') update #t set tx='c7|b. Principals partner with the school community to promote student learning. Principals implement structures and processes which result in parent and community engagement and support. Unsatisfactory (Comment Required) Developing Proficient Accomplished'                                                                                                                                                                                                                                                                                                                                                                          where keyx = '7-2'
insert #t(keyx) values ('7-2') update #t set l1='c7|__1__ Not demonstrated at this time. or __2__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx = '7-2'
insert #t(keyx) values ('7-2') update #t set l2='c7|__1__ Acknowledges the importance of engaging stakeholder groups in meaningful ways.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx = '7-2'
insert #t(keyx) values ('7-2') update #t set l3='c7|<b>...and</b> __1__ Provides opportunities for stakeholder groups to become involved in the school. __2__ Collaborates with administrative colleagues.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                where keyx = '7-2'
insert #t(keyx) values ('7-2') update #t set l4='c7|<b>...and</b> __1__ Optimizes stakeholder involvement to provide learning opportunities for staff and students. __2__ Engages the school community in the implementation of district strategic plan.'                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx = '7-2'
insert #t(keyx) values ('7-2') update #t set ex='c7|Examples of evidence: Logs of community presence at school activities, meeting sign-in sheets, e-mail/correspondence, newsletters, meeting minutes, agendas, outreach activities, personal logs of communication, school calendars'                                                                                                                                                                                                                                                                                                                                                                                                    where keyx = '7-2'
insert #t(keyx) values ('8-1') update #t set tx='c8|Principals demonstrate a commitment to closing achievement gaps.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      where keyx = '8-1'
insert #t(keyx) values ('8-1') update #t set l1='c8|Not demonstrated at this time. or __1__ Unsatisfactory.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               where keyx = '8-1'
insert #t(keyx) values ('8-1') update #t set l2='c8|__1__ Understands relevant research on the achievement gap. __2__ Communicates and models the ideals and beliefs that teachers and staff can impact student learning and achievement for all students. __3__ Engages in frequent quality interactions with underperforming students. __4__ Understands how to use data to identify achievement gaps.'                                                                                                                                                                                                                                                                                  where keyx = '8-1'
insert #t(keyx) values ('8-1') update #t set l3='c8|<b>...and</b> __1__ Implements school-wide practices that foster understanding and respect for cultural diversity, celebrates the contributions of diverse groups, and addresses closing the achievement gap. __2__ Analyzes multiple data sources of sub-population groups of students to set targeted SIP goals and apply intervention programs to close achievement gaps. (Including effects of poverty, trauma, homelessness, etc.) __3__ Actively participates in the development of district goals, strategic planning, and initiatives designed to improve student achievement and address achievement gaps.'                   where keyx = '8-1'
insert #t(keyx) values ('8-1') update #t set l4='c8|<b>...and</b> __1__ Continuously works with staff to increase staff understanding of how to close the achievement gap. __2__ Works to build the collective efficacy of staff through shared understandings about students. __3__ Systematically monitors student achievement of underperforming populations of students. __4__ Optimizes school programs and community resources to integrate community, family language, and culture into the school to support the students'' academic progress.'                                                                                                                                     where keyx = '8-1'
insert #t(keyx) values ('8-1') update #t set ex='c8|Examples of Evidence: SIP, Title I compacts, parent meetings, surveys, staff meeting minutes, professional development agendas, translated documents, phone logs, staff handbooks, Response to Intervention (RTI) models, Student Information System (SIS) data, Student Study Team (SST) minutes, multi-cultural activities or awareness'                                                                                                                                                                                                                                                                                             where keyx = '8-1'
                        
alter table seRubricRow alter column title varchar (500)
--in this database, cv Principal rubric has framework ID 2

create table #rr2396 (rubricRowID bigint)
--truncate table #rr2396
--select * from #rr2396
insert #rr2396 (rubricRowID)
select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID =2

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID =2)
delete SERubricRow where RubricRowID in 
(
	select RubricRowID from #rr2396 
)
-- leave the frameworkNodes, as they're the same, as well as the frameworPerformanceLevels
insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor, BelongsToDistrict)
select tx, Ex, l1, l2, l3, l4, 'CVPRIN' from #t where tx is not null

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeId , rr.RubricRowID, rr.RubricRowID
from SEFrameworkNode fn
join SERubricRow rr on fn.ShortName = substring(rr.Title, 1, 2)
where fn.FrameworkID = 2 and rr.BelongsToDistrict = 'CVPRIN'



update SERubricRow set title         = substring(title        , 4, 5000) where BelongsToDistrict='CVPRIN'
update SERubricRow set description   = substring(description  , 4, 5000) where BelongsToDistrict='CVPRIN'
update SERubricRow set PL1Descriptor = substring(PL1Descriptor, 4, 5000) where BelongsToDistrict='CVPRIN'
update SERubricRow set PL2Descriptor = substring(PL2Descriptor, 4, 5000) where BelongsToDistrict='CVPRIN'
update SERubricRow set PL3Descriptor = substring(PL3Descriptor, 4, 5000) where BelongsToDistrict='CVPRIN'
update SERubricRow set PL4Descriptor = substring(PL4Descriptor, 4, 5000) where BelongsToDistrict='CVPRIN'

update SERubricRow set BelongsToDistrict = '32356' where BelongsToDistrict='CVPRIN'


--******************************************************************
-- bugzilla 2393
--Othello Import/ teacher/principal... state
-- othello p = 10; othello t = 11
create table #rr (rubricRowID bigint)
--truncate table #rr
--select * from #rr
insert #rr
select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID in (10, 11)

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID in (10,11))
delete SERubricRow where RubricRowID in 
(
	select RubricRowID from #rr 
)
delete SEFrameworkNode where FrameworkID in (10,11)
delete SEFrameworkPerformanceLevel where FrameworkID in (10,11)

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(10, 1, 'UNS', rtrim ('Unsatisfactory'), 'Consistently does not meet expected levels of performance'       )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(10, 2, 'BAS', rtrim ('Basic         '), 'Occasionally meets expected  levels of performance'              )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(10, 3, 'PRO', rtrim ('Proficient    '), 'Proficient/Meets Expectations'                                   )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(10, 4, 'INN', rtrim ('Innovative ')   , 'Clearly and consistently exceeds expected levels of performance' )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(11, 1, 'UNS', rtrim ('Unsatisfactory'), 'Consistently does not meet expected levels of performance'       )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(11, 2, 'BAS', rtrim ('Basic         '), 'Occasionally meets expected  levels of performance'              )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(11, 3, 'PRO', rtrim ('Proficient    '), 'Proficient/Meets Expectations'                                   )
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, ShortName, FullName, Description) values(11, 4, 'INN', rtrim ('Innovative ')   , 'Clearly and consistently exceeds expected levels of performance' )

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) 
select 10, null, shortname, sequence, isLeafNode, title, description from SEFrameworkNode where FrameworkID = 2

insert seframeworknode (frameworkId, parentNodeID, shortname, sequence, isLeafnode, title, description) 
select 11, null, shortname, sequence, isLeafNode, title, description from SEFrameworkNode where FrameworkID = 3

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) 
select t,'', p1, p2, p3, p4, '01147_p' from stateEval_PrePro.dbo.OthelloPrincipalState_RR

insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor,BelongsToDistrict) 
select t,'', p1, p2, p3, p4, '01147_t' from stateEval_PrePro.dbo.OthelloTeacherState_RR

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID , rr.rubricRowID,  ops.rrSeq as RN
from SERubricRow rr
join StateEval_prePro.dbo.OthelloPrincipalState_RR ops on ops.t = rr.Title
join SEFrameworkNode fn on fn.ShortName = ops.criteria
where rr.BelongsToDistrict = '01147_p' and fn.FrameworkID = 10

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeID , rr.rubricRowID,  ots.rrSeq as RN
from SERubricRow rr
join StateEval_prePro.dbo.OthelloTeacherState_RR ots on ots.t = rr.Title
join SEFrameworkNode fn on fn.ShortName = ots.criteria
where rr.BelongsToDistrict = '01147_t' and fn.FrameworkID = 11

*/

--end 825 patches ********************************************************************

--begin 828 patches ********************************************************************

--bug 2405
/*
create table #t (keyx bigint, tx varchar(500), p1 varchar(max), p2 varchar(max), p3 varchar(max), p4 varchar(max), ex varchar(max))


 insert #t (keyx) values (11) update #t set tx ='11Teachers define high and appropriate goals for students. Teachers treat students as individuals. Teachers maintain high expectations for all students.'                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 11
 insert #t (keyx) values (11) update #t set p1 ='11__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 11
 insert #t (keyx) values (11) update #t set p2 ='11__1__ Understands the need for high expectations for all students. __2__ Establishes instructional goals based on mandated assessments.'                                                                                                                                                                                                                                                                                                                                                                                                                    where keyx= 11
 insert #t (keyx) values (11) update #t set p3 ='11<b>... and</b> __1__ Communicates high expectations for all students. __2__ Establishes instructional goals based on multiple measures of student achievement data. __3__ Involves students in setting learning goals.'                                                                                                                                                                                                                                                                                                                                     where keyx= 11
 insert #t (keyx) values (11) update #t set p4 ='11<b>... and</b> __1__ Ensures that students can communicate expectations for learning. __2__ Consistently monitors student growth. __3__ Involves students in monitoring and adjusting learning goals based on ongoing use of achievement data.'                                                                                                                                                                                                                                                                                                                      where keyx= 11
 insert #t (keyx) values (11) update #t set ex ='11Evidence: Scoring rubrics, syllabus, learning targets, goal setting, “I will” statements, written reflections at end of unit/assignments, learning logs, math anticipation guides, exit slips.'                                                                                                                                                                                                                                                                                                                                                             where keyx= 11
 insert #t (keyx) values (21) update #t set tx ='21a. Teachers utilize research-based instructional practices. Teachers select research-based strategies that are most effective in meeting the needs of their students. Teachers engage students in the learning process.'                                                                                                                                                                                                                                                                                                                                    where keyx= 21
 insert #t (keyx) values (21) update #t set p1 ='21__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 21
 insert #t (keyx) values (21) update #t set p2 ='21__1__ Demonstrates knowledge of a core set of research-based instructional strategies. __2__ Identifies instructional strategies that promote problem solving and critical thinking. __3__ Understands the importance of using available technology.'                                                                                                                                                                                                                                                                                                       where keyx= 21
 insert #t (keyx) values (21) update #t set p3 ='21<b>... and</b> __1__ Appropriately uses research-based instructional strategies and resources. __2__ Monitors and adjusts instructional strategies within lessons based on anecdotal evidence. __3__ Provides opportunities for students to extend and refine knowledge through a variety of strategies. __4__ Utilizes available instructional technology.'                                                                                                                                                                                                where keyx= 21
 insert #t (keyx) values (21) update #t set p4 ='21<b>... and</b> __1__ Intentionally selects and implements instructional strategy for the cognitive requirements of the learning objective or lesson. __2__ Provides students with multiple exposures to tasks that build skills and knowledge. __3__ Purposefully assists students to incorporate the knowledge and skill from other academic disciplines.'                                                                                                                                                                                                 where keyx= 21
 insert #t (keyx) values (21) update #t set ex ='21Evidence: Collaboration; common vocabulary; crossing curricular boundaries; lesson plans; hands-on presentation integers: counters; questioning strategies; CITW sentence starters; A-V math tool kits/notebooks; exit tasks; clicker quizzes; graphic organizers; online grades; self-reflection rubric; conference portfolios; posted objectives. Evidence of strategies for extending and refining knowledge: decision making, problem solving, invention, investigation, systems analysis, experimental inquiry (previously listed under Proficient).'  where keyx= 21
 insert #t (keyx) values (22) update #t set tx ='22b. Teachers use assessment to inform feedback. Teachers provide feedback that is corrective in nature, timely, and specific to a criterion. Teachers foster student ability to provide their own feedback.'                                                                                                                                                                                                                                                                                                                                                 where keyx= 22
 insert #t (keyx) values (22) update #t set p1 ='22__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 22
 insert #t (keyx) values (22) update #t set p2 ='22__1__ Demonstrates an awareness of the power of feedback as a learning strategy.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                           where keyx= 22
 insert #t (keyx) values (22) update #t set p3 ='22<b>... and</b> __1__ Provides learners with timely and consistent feedback based on on-going formative assessments.'                                                                                                                                                                                                                                                                                                                                                                                                                                        where keyx= 22
 insert #t (keyx) values (22) update #t set p4 ='22<b>... and</b> __1__ Creates opportunities for learners to monitor and analyze their own progress.'                                                                                                                                                                                                                                                                                                                                                                                                                                                         where keyx= 22
 insert #t (keyx) values (22) update #t set ex ='22Evidence: Students charting their own progress; student led conferences.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   where keyx= 22
 insert #t (keyx) values (31) update #t set tx ='31Teachers demonstrate an awareness of individual student needs and utilize instructional strategies to address those needs. Teachers vary instruction to meet student needs in order for students to achieve at their highest ability level.'                                                                                                                                                                                                                                                                                                                where keyx= 31
 insert #t (keyx) values (31) update #t set p1 ='31__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 31
 insert #t (keyx) values (31) update #t set p2 ='31__1__ Understands the varying developmental needs of students. __2__ Identifies resources to address individual student needs.'                                                                                                                                                                                                                                                                                                                                                                                                                             where keyx= 31
 insert #t (keyx) values (31) update #t set p3 ='31<b>... and</b> __1__ Utilizes available resources needed to address individual student needs. __2__ Differentiates instruction based on regular review of individual student work.'                                                                                                                                                                                                                                                                                                                                                                         where keyx= 31
 insert #t (keyx) values (31) update #t set p4 ='31<b>... and</b> __1__ Consistently addresses the unique learning needs of individual students. __2__ Explicitly demonstrates how new learning builds on the prior learning of individual students.'                                                                                                                                                                                                                                                                                                                                                          where keyx= 31
 insert #t (keyx) values (31) update #t set ex ='31Evidence: Peer tutoring; conferencing; examples; lesson presentations; use of technology; Socratic dialogues; manipulatives; varied leveled materials; room arrangement.'                                                                                                                                                                                                                                                                                                                                                                                   where keyx= 31
 insert #t (keyx) values (41) update #t set tx ='41a. Teachers align instruction to the required grade level/content standards. Teachers make the standards-based curriculum rigorous and relevant for all students.'                                                                                                                                                                                                                                                                                                                                                                                          where keyx= 41
 insert #t (keyx) values (41) update #t set p1 ='41__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 41
 insert #t (keyx) values (41) update #t set p2 ='41__1__ Demonstrates how daily lessons are consistently aligned to the established standards. __2__ Standards are presented to students.'                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 41
 insert #t (keyx) values (41) update #t set p3 ='41<b>... and</b> __1__ Assists students in understanding the relevance of the standards. __2__ Communicates standards in learner friendly language. __3__ Provides students with an appropriately challenging and rigorous curriculum.'                                                                                                                                                                                                                                                                                                                       where keyx= 41
 insert #t (keyx) values (41) update #t set p4 ='41<b>... and</b> __1__ Consistently provides opportunities for students to communicate their understanding of their learning.'                                                                                                                                                                                                                                                                                                                                                                                                                                where keyx= 41
 insert #t (keyx) values (41) update #t set ex ='41Evidence: Posting standards; posting objectives; lesson plans; student rubrics; student reflections.'                                                                                                                                                                                                                                                                                                                                                                                                                                                       where keyx= 41
 insert #t (keyx) values (42) update #t set tx ='42b. Teachers utilize district established approved curriculum: Teachers ensure all students have the opportunity to learn the essential content aligned to state standards.'                                                                                                                                                                                                                                                                                                                                                                                 where keyx= 42
 insert #t (keyx) values (42) update #t set p1 ='42__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 42
 insert #t (keyx) values (42) update #t set p2 ='42__1__ Demonstrates knowledge of established standards. __2__ Demonstrates a basic understanding of the district’s approved curriculum.'                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 42
 insert #t (keyx) values (42) update #t set p3 ='42__1__ Utilizes district approved curriculum and established standards in both short term and long term lesson development. __2__ Utilizes instructional time to promote understanding of content.'                                                                                                                                                                                                                                                                                                                                                          where keyx= 42
 insert #t (keyx) values (42) update #t set p4 ='42__1__ Consistently provides leadership in the development and/or implementation of approved curriculum.'                                                                                                                                                                                                                                                                                                                                                                                                                                                    where keyx= 42
 insert #t (keyx) values (42) update #t set ex ='42Evidence: Collaboration; standards-based assessments; lesson plans; committee membership.'                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx= 42
 insert #t (keyx) values (51) update #t set tx ='51Teachers create a welcoming environment where students feel safe, secure and respected. Teachers encourage an environment that is inviting, respectful and inclusive.'                                                                                                                                                                                                                                                                                                                                                                                      where keyx= 51
 insert #t (keyx) values (51) update #t set p1 ='51__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 51
 insert #t (keyx) values (51) update #t set p2 ='51__1__ Interactions with students are respectful and positive. __2__ Demonstrates sensitivity to the diversity of students in the classroom. __3__ Develops routines and procedures that provide a safe and orderly classroom.'                                                                                                                                                                                                                                                                                                                              where keyx= 51
 insert #t (keyx) values (51) update #t set p3 ='51<b>... and</b> __1__ Monitors and adjusts routines and procedures based on classroom dynamics. __2__ Routinely encourages contributions of all students. __3__ Supports students of various backgrounds and abilities.'                                                                                                                                                                                                                                                                                                                                     where keyx= 51
 insert #t (keyx) values (51) update #t set p4 ='51<b>... and</b> __1__ Assures routines and procedures are in place that help students assume responsibility for themselves. __2__ Establishes a classroom community that empowers students to collaborate and maintain a safe and supportive environment.'                                                                                                                                                                                                                                                                                                   where keyx= 51
 insert #t (keyx) values (51) update #t set ex ='51Evidence: Student collaboration; cooperative learning; lesson plans; syllabus; rules posted; student contract; room arrangements; visuals that support routines and procedures.'                                                                                                                                                                                                                                                                                                                                                                            where keyx= 51
 insert #t (keyx) values (61) update #t set tx ='61Teachers use on-going formative and summative assessments to inform and adjust classroom instruction. Teachers use multiple indicators to evaluate student progress and growth. Teachers provide opportunities and tools for students to assess themselves. Teachers modify instruction to ensure learning.'                                                                                                                                                                                                                                                where keyx= 61
 insert #t (keyx) values (61) update #t set p1 ='61__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 61
 insert #t (keyx) values (61) update #t set p2 ='61__1__ Demonstrates an awareness of a variety of assessment methods. __2__ Communicates specified criteria to students. __3__ Understands the importance of improved teaching practice and student learning based on assessment results.'                                                                                                                                                                                                                                                                                                                    where keyx= 61
 insert #t (keyx) values (61) update #t set p3 ='61<b>... and</b> __1__ Effectively utilizes a variety of formative and summative assessments aligned with learning targets and established standards. __2__ Uses formative and summative assessment data to inform lesson planning and instructional decisions.'                                                                                                                                                                                                                                                                                              where keyx= 61
 insert #t (keyx) values (61) update #t set p4 ='61<b>... and</b> __1__ Empowers students to engage in self-assessment. __2__ Utilizes student’s self-assessments to inform and modify instructional practices.'                                                                                                                                                                                                                                                                                                                                                                                               where keyx= 61
 insert #t (keyx) values (61) update #t set ex ='61Evidence: Grouping; re-teaching; re-assessing; self assessment rubrics; questioning strategies; lesson plans; study guides; formative and summative assessments; reflection journal.'                                                                                                                                                                                                                                                                                                                                                                       where keyx= 61
 insert #t (keyx) values (71) update #t set tx ='71Teachers communicate effectively and professionally. Teachers communicate in ways that are clearly understood by students, parents/guardians, and school community. Unsatisfactory 1 (Comment Required) Developing 2 Proficient 3 Accomplished 4'                                                                                                                                                                                                                                                                                                           where keyx= 71
 insert #t (keyx) values (71) update #t set p1 ='71__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 71
 insert #t (keyx) values (71) update #t set p2 ='71__1__ Demonstrates an awareness of the needs of the intended audience. __2__ Develops a plan for communicating with families regarding student performance. __3__ Reads district/school-wide communications. __4__ Adhere to confidentiality policies.'                                                                                                                                                                                                                                                                                                     where keyx= 71
 insert #t (keyx) values (71) update #t set p3 ='71<b>... and</b> __1__ Communicates in a timely and consistent manner with students, parents, guardians for the benefit of students. __2__ Supports district/school mission and goals.'                                                                                                                                                                                                                                                                                                                                                                       where keyx= 71
 insert #t (keyx) values (71) update #t set p4 ='71<b>... and</b> __1__ Builds relationships with parents and community by providing opportunities for two-way communication. __2__ Communicates with other professional educators within the school to promote improving individual student performance.'                                                                                                                                                                                                                                                                                                     where keyx= 71
 insert #t (keyx) values (71) update #t set ex ='71Evidence: Email; communication logs; weekly newsletters; progress reports; parent conferences; conference tools; website.'                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx= 71
 insert #t (keyx) values (81) update #t set tx ='81a. Teachers strive to improve student learning through collaborative and collegial practice. Teachers collaborate with their colleagues in the use of data, planning, and reflecting on practices that influence student learning.'                                                                                                                                                                                                                                                                                                                         where keyx= 81
 insert #t (keyx) values (81) update #t set p1 ='81__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 81
 insert #t (keyx) values (81) update #t set p2 ='81__1__ Professionally collaborates with colleagues. __2__ Effectively communicates with colleagues regarding student performance.'                                                                                                                                                                                                                                                                                                                                                                                                                           where keyx= 81
 insert #t (keyx) values (81) update #t set p3 ='81<b>... and</b> __1__ Collaborates with colleagues about best practices for improved student learning. __2__ Professionally and confidentially shares with appropriate colleague’s information that explains or helps inform about students’ academic performance.'                                                                                                                                                                                                                                                                                          where keyx= 81
 insert #t (keyx) values (81) update #t set p4 ='81<b>... and</b> __1__ Promotes the success of all students through a focus on teamwork, trust, and collective efficacy. __2__ Provides leadership in facilitating collaborative and collegial processes.'                                                                                                                                                                                                                                                                                                                                                    where keyx= 81
 insert #t (keyx) values (81) update #t set ex ='81Evidence: Collaboration notes; email; calendar; lesson plans; SST notes..'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  where keyx= 81
 insert #t (keyx) values (82) update #t set tx ='82b. Teachers strive to improve professional practice. Teachers participate in professional learning that meets the needs of students and their own professional growth. Teachers actively investigate and consider new ideas that improve teaching and learning.'                                                                                                                                                                                                                                                                                            where keyx= 82
 insert #t (keyx) values (82) update #t set p1 ='82__1__ Minimum requirement not met. (Comment required.)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     where keyx= 82
 insert #t (keyx) values (82) update #t set p2 ='82__1__ Sets professional goals directly related to professional growth. __2__ Attends professional learning activities that are related directly to professional growth.'                                                                                                                                                                                                                                                                                                                                                                                    where keyx= 82
 insert #t (keyx) values (82) update #t set p3 ='82<b>... and</b> __1__ Contributes to the establishment of professional working relationships. __2__ Seeks resources and professional development opportunities to improve professional practice.'                                                                                                                                                                                                                                                                                                                                                            where keyx= 82
 insert #t (keyx) values (82) update #t set p4 ='82<b>... and</b> __1__ Provides leadership for the professional learning of colleagues in the use of research-based instructional strategies. __2__ Models the use of assessment information to adjust instructional practice for others.'                                                                                                                                                                                                                                                                                                                    where keyx= 82
 insert #t (keyx) values (82) update #t set ex ='82Evidence: Lesson plans; calendar; SST notes; notes; email; clock hour classes; book studies, grants.'                                                                                                                                                                                                                                                                                                                                                                                                                                                       where keyx= 82                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

--in this database, cv teacher rubric has framework ID 3

create table #r2405 (rubricRowID bigint)

insert #r2405 (rubricRowID)
select RubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID =3

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID =3)
delete SERubricRow where RubricRowID in 
(
	select RubricRowID from #r2405 
)
-- leave the frameworkNodes, as they're the same, as well as the frameworPerformanceLevels
insert SERubricRow(Title, Description, PL1Descriptor, PL2Descriptor,PL3Descriptor,PL4Descriptor, BelongsToDistrict)
select tx, Ex, p1, p2, p3, p4, 'CVTeach' from #t where tx is not null

insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.frameworkNodeId , rr.RubricRowID, CONVERT(smallint, substring(rr.Title, 2, 1))
from SEFrameworkNode fn
join SERubricRow rr on substring(fn.ShortName, 2, 1) = substring(rr.Title, 1, 1)
where fn.FrameworkID = 3 and rr.BelongsToDistrict = 'CVTeach'

update SERubricRow set title         = substring(title        , 3, 5000) where BelongsToDistrict='CVTeach'
update SERubricRow set description   = substring(description  , 3, 5000) where BelongsToDistrict='CVTeach'
update SERubricRow set PL1Descriptor = substring(PL1Descriptor, 3, 5000) where BelongsToDistrict='CVTeach'
update SERubricRow set PL2Descriptor = substring(PL2Descriptor, 3, 5000) where BelongsToDistrict='CVTeach'
update SERubricRow set PL3Descriptor = substring(PL3Descriptor, 3, 5000) where BelongsToDistrict='CVTeach'
update SERubricRow set PL4Descriptor = substring(PL4Descriptor, 3, 5000) where BelongsToDistrict='CVTeach'

update SERubricRow set BelongsToDistrict = '32356' where BelongsToDistrict='CVTeach'

drop table #t
drop table #r2405


--***** bugzilla 2402
update SEFrameworkNode set Title = 'Domain 4: Managing Human and Fiscal Resources' where FrameworkNodeID = 309


--***** bugzilla 2401
update seRubricRow set title = 'Principals lead the development, implementation and evaluation of a data driven plan.'   where rubricRowid = 887
update seRubricRow set title = 'Principals are able to communicate research-based best practices for curriculum, instruction and assessment to staff in order to improve student learning.'           where rubricRowid = 888
update seRubricRow set title = 'Principals monitor, assist, and evaluate the implementation of effective instruction and assessment practices and the impact on student learning.'         where rubricRowid = 889
update seRubricRow set title = 'a. Principals establish processes for making sound budget decisions.'   where rubricRowid = 890
update seRubricRow set title = 'b. Principals establish and follow standard operating principles and routines for recruitment, hiring, and supporting staff, and for implementing the district’s personnel evaluation system.'    where rubricRowid = 891
update seRubricRow set title = 'a. Principals establish strong lines of communication with parents, stakeholders, teachers, staff, and students. Principals keep lines of communication open and serve as an advocate and spokesperson for the school to all stakeholders.' where rubricRowid = 892
update seRubricRow set title = 'b. Principals partner with the school community to promote student learning. Principals implement structures and processes which result in parent and community engagement and support.'      where rubricRowid = 893
update SERubricRow set Title = 'achers communicate effectively and professionally. Teachers communicate in ways that are clearly understood by students, parents/guardians, and school community.'    where RubricRowID = 952

update SERubricRow set PL3Descriptor = '<b>...and</b> __1__ Continues to monitor and adjust the effectiveness of the plan using current data from multiple sources. __2__ Provides support to teachers to implement the data-driven plan at the classroom and school level. __3__ Prioritizes the appropriate use of resources to support the data-driven plan. __4__ Facilitates the successful execution of the School Improvement Plan.' where rubricRowID = 887

--***** bugzilla 2399
update SERubricRow set PL1Descriptor = '__1__ Not demonstrated at this time <br><b>or</b><br> __2__ Unsatisfactory.'
where RubricRowID in (885,886,887,888,889,890,891,892,893)

--***** bugzilla 2387
update SERubricRow set Title = '4c - Communicating with Families' where RubricRowID = 808
*/
--end 828 patches ********************************************************************
--begin 833 patches ********************************************************************
/*
--***** bugzilla 2409
update seRubricRow set pl3Descriptor =
'<b>...and</b> __1__ Uses a variety of formats to communicate about student learning with stakeholders'
+ ' within and outside the school. __2__ Uses effective communication skills and strategies to:'
+ ' <ul><li> Enlist community support.</li><li>Resolve conflicts among individuals and groups.' 
+ ' </li><li> Build common focus and collaboration to enhance student learning.</li></ul>'
where rubricRowID = 892

--***** bugzilla 2408
update SERubricRow set PL1Descriptor = 
'__1__ Not demonstrated at this time <br><b>or</b><br> __2__ Unsatisfactory (comment required)'
where rubricRowID in (885,886,887,888,889,890,891,892,893,894)

--***** bugzilla 2407
update SERubricRow set title =
'Teachers communicate effectively and professionally. Teachers communicate in ways that are'
+ ' clearly understood by students, parents/guardians, and school community.'
where rubricRowID = 953

--***** bugzilla 2406
update SERubricRow set title =
'Teachers communicate effectively and professionally. Teachers communicate in ways that '
+ 'are clearly understood by students, parents/guardians, and school community.'
where rubricRowID = 952
*/
--end 833 patches ********************************************************************
--begin 835 patches ********************************************************************

/*
-- looks like a bad patch from last time
update SERubricRow set Title = 
'Teachers use on-going formative and summative assessments to inform and adjust '
+'classroom instruction. Teachers use multiple indicators to evaluate student progress '
+'and growth. Teachers provide opportunities and tools for students to assess themselves. '
+'Teachers modify instruction to ensure learning.'
where RubricRowID = 953

*/

--end 835 patches ********************************************************************

--begin 840 patches ********************************************************************


-- forgot to change '01147-p' and '01147-t' back to '01147'
/*
update SERubricRow set BelongsToDistrict ='01147' where BelongsToDistrict like '01147%'

--principal evidence, othello
update serubricrow set description = '<ul><li></li><li>Current School Improvement Plan</li><li>Student/Staff surveys, interviews, and focus groups</li><li>Meeting /LID Agenda/Minutes</li><li>Logs of classroom visits</li></ul'                                                                                                                                                                                                                                                                                           where rubricRowID = 895
update serubricrow set description = '<ul><li></li><li>Verbal or written recognition of student, staff or school</li></ul>'                                                                                                                                                                                                                                                                                                                                                                                                 where rubricRowID = 896
update serubricrow set description = '<ul><li></li><li>Staff surveys/Feedback</li><li>PLC Agenda and Minutes</li><li>Staff Turnover</li></ul>'                                                                                                                                                                                                                                                                                                                                                                              where rubricRowID = 897
update serubricrow set description = '<ul><li></li><li>School Safety Plan</li><li>Documentation of Drills</li><li>Healthy youth Survey</li><li>School Safety Reports</li><li>Accident Report Forms</li></ul>'                                                                                                                                                                                                                                                                                                               where rubricRowID = 898
update serubricrow set description = '<ul><li></li><li>School Discipline Plan</li><li>Analysis of Discipline Referral Records</li><li>Response to Discipline Referral Records</li><li>Reduction in bullying, fighting, and harassment incidents</li><li>Adheres to discipline matrix</li></ul>'                                                                                                                                                                                                                             where rubricRowID = 899
update serubricrow set description = '<ul><li></li><li>Knowledge of individual classroom management and discipline plans</li><li>Documentation of classroom management plans</li><li>Related Documents</li><li>Staff meeting agenda/minutes		</li></ul>'                                                                                                                                                                                                                                                                   where rubricRowID = 900
update serubricrow set description = '<ul><li></li><li>School Improvement Plan</li><li>Agenda and Minutes for School Improvement Teams</li><li>Data		</li></ul>'                                                                                                                                                                                                                                                                                                                                                           where rubricRowID = 901
update serubricrow set description = '<ul><li></li><li>School Improvement Plan</li><li>Agenda and Minutes for School Improvement Teams</li><li>School Improvement Plan Annual Review Meeting</li><li>Progress Reports</li><li>Team Reviews		</li></ul>'                                                                                                                                                                                                                                                                   where rubricRowID = 902
update serubricrow set description = '<ul><li></li><li>School Improvement Plan</li><li>Agenda and Minutes for School Improvement Teams</li><li>School Improvement Plan Annual Review Meeting</li><li>Progress Reports		</li></ul>'                                                                                                                                                                                                                                                                                         where rubricRowID = 903
update serubricrow set description = '<ul><li></li><li>PLC Minutes/Agenda</li><li>Staff Meeting Agenda and Minutes</li><li>LID Agendas/Minutes</li><li>Inservices</li><li>Curriculum Day Requests</li></ul>'                                                                                                                                                                                                                                                                                                                where rubricRowID = 904
update serubricrow set description = '<ul><li></li><li>PLC  Minutes/Agenda</li><li>Staff Meeting Agenda and Minutes</li><li>LID Agendas/Minutes</li><li>Inservices</li><li>Curriculum Day Requests</li><li>Teacher Evaluations</li></ul>'                                                                                                                                                                                                                                                                                   where rubricRowID = 905
update serubricrow set description = '<ul><li></li><li>PLC Minutes/Agenda</li><li>Staff Meeting Agenda and  Minutes</li><li>LID Agendas/Minutes</li><li>Inservices</li><li>Curriculum Day Requests	Comments:	</li></ul>'                                                                                                                                                                                                                                                                                                   where rubricRowID = 906
update serubricrow set description = '<ul><li></li><li>Plans of support & improvement</li><li>Documentation of coaching & support</li><li>Documentation of pre- and post observations</li><li>Teacher Evaluations</li><li>Planning and scheduling for new teacher mentoring and meetings; list of new teachers and assigned mentors</li><li>Evidence of agendas and staff/department/grade level meetings and staff development</li><li>Staff development activities that  address identified   needs	Comments:	</li></ul>' where rubricRowID = 907
update serubricrow set description = '<ul><li></li><li>Plans of support &improvement</li><li>Documentation of coaching & support</li><li>Documentation of pre- and post observations</li><li>Planning and scheduling for new teacher mentoring and meetings; list of new teachers and assigned mentors</li><li>Evidence of agendas and staff/department/grade level meetings and staff  development</li><li>Staff development activities that address identified needs	</li></ul>'                                         where rubricRowID = 908
update serubricrow set description = '<ul><li></li><li>Staff Handbook</li><li>Scheduling and Assignments</li><li>School Improvement Plan that reflects appropriate use of building resources-people and time</li><li>Communication with district officials</li></ul>'                                                                                                                                                                                                                                                       where rubricRowID = 909
update serubricrow set description = '<ul><li></li><li>Documentation of district protocol and procedures</li><li>Packets or protocols that reflect student achievement goals</li><li>Mentoring strategies</li></ul>'                                                                                                                                                                                                                                                                                                        where rubricRowID = 910
update serubricrow set description = '<ul><li></li><li>Staff Evaluations</li><li>Pre and Post Conference</li><li>Records of communication  </li><li>Adherence to  legal and contractual timelines</li></ul>'                                                                                                                                                                                                                                                                                                                where rubricRowID = 911
update serubricrow set description = '<ul><li></li><li>School Improvement Plan that reflects appropriate use of building resources-people, time, and money</li><li>Budget documents</li><li>Reviews budget with district personnel		</li></ul>'                                                                                                                                                                                                                                                                           where rubricRowID = 912
update serubricrow set description = '<ul><li></li><li>Staff communications; e-mail, agendas, minutes, calendars, staff and student handbook</li><li>Meetings: staff, grade/department chair, department/ grade level, PLC		</li></ul>'                                                                                                                                                                                                                                                                                   where rubricRowID = 913
update serubricrow set description = '<ul><li></li><li>Newsletters</li><li>Parent Handbook</li><li>Log of attendance at school activities outside school day</li><li>Media Samples</li></ul>'                                                                                                                                                                                                                                                                                                                               where rubricRowID = 914
update serubricrow set description = '<ul><li></li><li>Newsletters</li><li>Parent Handbook</li><li>Log of attendance at school activities outside school day</li><li>Log of Meetings: IEP, PTA/PTO, PAC</li><li>Civic Groups</li><li>Outside Agencies</li></ul>'                                                                                                                                                                                                                                                            where rubricRowID = 915
update serubricrow set description = '<ul><li></li><li>Administration Meetings</li><li>Documentation of vertical and horizontal collaboration</li><li>Phone Log</li><li>Conversations</li><li>Calendar</li></ul>'                                                                                                                                                                                                                                                                                                           where rubricRowID = 916
update serubricrow set description = '<ul><li></li><li>Knowledge of diversity issues</li><li>Translated Documents</li><li>Environment reflects the diversity of student body</li><li>PD plan and minutes</li></ul>'                                                                                                                                                                                                                                                                                                         where rubricRowID = 917
update serubricrow set description = '<ul><li></li><li>Knowledge of students performance issues</li><li>Accessibiliy, review, and distribution of student data</li><li>Analysis of student  data</li><li>RTI and IEP meeting attendance</li><li>Intervention plans;plan of action</li><li>Staff Communications; agendas and minutes</li></ul>'                                                                                                                                                                              where rubricRowID = 918
update serubricrow set description = '<ul><li></li><li>Knowledge of diversity issues</li><li>Translated Documents</li><li>Environment reflects the diversity of student body</li><li>PD plan and Minutes</li><li>Analysis of representation	</li></ul>	'                                                                                                                                                                                                                                                                   where rubricRowID = 919

--teache evidence, othello
update seRubricRow set description = 'All:<ul><li>Lesson Plans</li></ul>Innovative:<ul><li>Lesson</li><li>Unit Plans</li></ul>'                                                                                                                                         where rubricRowID = 920
update seRubricRow set description = 'All:<ul><li>Assessments</li><li>Lesson Plans</li></ul>'                                                                                                                                                                           where rubricRowID = 921
update seRubricRow set description = 'All:<ul><li>Observation</li></ul>'                                                                                                                                                                                                where rubricRowID = 922
update seRubricRow set description = 'All:<ul><li>Observation</li></ul>'                                                                                                                                                                                                where rubricRowID = 943
update seRubricRow set description = 'All:<ul><li>Observation</li></ul>'                                                                                                                                                                                                where rubricRowID = 942
update seRubricRow set description = 'All:<ul><li>Observation</li></ul>'                                                                                                                                                                                                where rubricRowID = 941
update seRubricRow set description = 'All:<ul><li>Pre-Observation Meeting</li></ul>Innovative:<ul><li>Pre-Observation Meeting</li><li>Documentation of Interventions and Observation Reports</li></ul>'                                                                 where rubricRowID = 940
update seRubricRow set description = 'All:<ul><li>Discussion</li></ul>Innovative:<ul><li>Discussion</li><li>Documentation</li></ul>'                                                                                                                                    where rubricRowID = 939
update seRubricRow set description = 'All:<ul><li>Observation</li></ul>Innovative:<ul><li>Observation</li><li>Documentation</li></ul>'                                                                                                                                  where rubricRowID = 938
update seRubricRow set description = 'All:<ul><li>Observations</li></ul>'                                                                                                                                                                                               where rubricRowID = 937
update seRubricRow set description = 'All:<ul><li>Observations</li></ul>'                                                                                                                                                                                               where rubricRowID = 936
update seRubricRow set description = 'All:<ul><li>Observations</li></ul>'                                                                                                                                                                                               where rubricRowID = 935
update seRubricRow set description = 'All:<ul><li>Observations</li></ul>'                                                                                                                                                                                               where rubricRowID = 934
update seRubricRow set description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>Proficient and Innovative:<ul><li>Observations</li><li>Classroom Management Plan</li><li>Discussions</li></ul>'                                                             where rubricRowID = 933
update seRubricRow set description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>'                                                                                                                                                                           where rubricRowID = 932
update seRubricRow set description = 'All:<ul><li>Observations</li><li>Classroom Management Plan</li><li>Discipline Forms</li></ul>Innovative:<ul><li>Observations</li><li>Classroom Management Plan</li><li>Discipline Forms</li><li>Discussion</li></ul>'             where rubricRowID = 931
update seRubricRow set description = 'All:<ul><li>Observations</li></ul>'                                                                                                                                                                                               where rubricRowID = 930
update seRubricRow set description = 'All:<ul><li>Documentation of Student Progress</li><li>Discussion</li></ul>Innovative:<ul><li>Documentation of Additional Data</li><li>Documentation of Student Progress</li><li>Discussion</li></ul>'                             where rubricRowID = 929
update seRubricRow set description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>Innovative:<ul><li>Observations</li><li>Discussions</li><li>Student Goal Sheets</li></ul'                                                                                   where rubricRowID = 928
update seRubricRow set description = 'All:<ul><li>Documentation</li><li>Observations</li></ul>'                                                                                                                                                                         where rubricRowID = 927
update seRubricRow set description = 'All:<ul><li>Documentation</li><li>Observations</li><li>Discussions</li></ul>'                                                                                                                                                     where rubricRowID = 926
update seRubricRow set description = 'All:<ul><li>Documentation</li><li>Observations</li><li>Discussions</li></ul>Innovative:<ul><li>Documentation</li><li>Observations</li><li>Discussions</li><li>Lesson Plans</li></ul>'                                             where rubricRowID = 925
update seRubricRow set description = 'All:<ul><li>Discussions</li><li>Observations</li></ul>'                                                                                                                                                                           where rubricRowID = 924
update seRubricRow set description = 'All:<ul><li>Observations</li><li>Discussions</li><li>Documentation</li></ul>'                                                                                                                                                     where rubricRowID = 923
 
--kennewick teacher evidence descriptions
update seRubricRow set description ='PRO: Plans are completed; activities are connected to lesson objective(s); materials are readily available and match the instructional level of the students'                                                                                                                                                      where rubricRowID = 678
update seRubricRow set description ='PRO: Facts and information shared are accurate; recognizes and anticipates common misconceptions; connects information to students'' lives'                                                                                                                                                                         where rubricRowID = 679
update seRubricRow set description ='PRO: Professional development could be in collaboration with administrator, colleagues, building and/or district resources or individually.'                                                                                                                                                                       where rubricRowID = 680
update seRubricRow set description ='PRO: The purpose is clearly communicated and focuses on what the student is to learn. Purpose is communicated throughout the lesson. Activities and purpose are clearly related.'                                                                                                                                  where rubricRowID = 681
update seRubricRow set description ='PRO: District-approved materials are in use during lesson. Supplemental materials connect to and support district adopted curriculum and standards. '                                                                                                                                                              where rubricRowID = 682
update seRubricRow set description ='PRO: Teacher uses a variety of strategies, including lesson delivery, student groupings, pacing, and other effective techniques, to engage students. Lesson has a clear beginning, middle and end.  Adjusts to the student level of interaction.'                                                                  where rubricRowID = 683
update seRubricRow set description ='PRO: Modification of assignments based on student need; seating arrangement accommodates individual needs. Teacher adjusts instruction and/or routines to accommodate special needs. '                                                                                                                             where rubricRowID = 684
update seRubricRow set description ='PRO: A variety of instructional strategies are utilized to meet the diverse learning styles of the students. These strategies include, but are not limited to, GLAD strategies, cooperative learning, use of graphic organizers, chants and rhymes, readers'' theatre, think-pair-share, use of white boards, etc.' where rubricRowID = 685
update seRubricRow set description ='PRO: Clear expectations and standards for quality work are communicated through course syllabus, lesson purpose, modeling, rubrics etc. Grading practices and student/teacher interaction reflects expectations and standards.'                                                                                    where rubricRowID = 686
update seRubricRow set description ='PRO: Questions and activities extend beyond the knowledge level.'                                                                                                                                                                                                                                                  where rubricRowID = 687
update seRubricRow set description ='PRO: Formal and infomal checks of student learning are ongoing and used throughout lessons and/or  units. Strategies may include class discussions, every pupil response activities, tests, daily assignments.'                                                                                                    where rubricRowID = 688
update seRubricRow set description ='PRO: Evidence of teacher use of student data to adjust lesson instruction and assignments through reteaching, pacing, student grouping and interventions.'                                                                                                                                                         where rubricRowID = 689
update seRubricRow set description ='PRO: Teaches, establishes and reinforces routines and procedures.  Transitions between activities result in minimal loss of instructional time.'                                                                                                                                                                   where rubricRowID = 690
update seRubricRow set description ='PRO: Clear pathways for student and teacher movement through the room, district safety guidelines are followed, materials are easily accessible.'                                                                                                                                                                  where rubricRowID = 691
update seRubricRow set description ='PRO: Responds to student behavior in a manner that is appropriate and respectful.  Communicates with and involves parents when appropriate.'                                                                                                                                                                       where rubricRowID = 692
update seRubricRow set description ='PRO: Builds a relationship with students by recognizing students'' opinions through listening and demonstrating empathy.'                                                                                                                                                                                           where rubricRowID = 693
update seRubricRow set description ='PRO: Regularly attends team planning meetings, and is an active participant in the process.  Evidence of shared workload and follow-through as appropriate.'                                                                                                                                                       where rubricRowID = 694
update seRubricRow set description ='PRO: Participates and contributes to conversations that are constructive, respectful, and focused on student learning. Conflicts are addressed professionally. '                                                                                                                                                   where rubricRowID = 695
update seRubricRow set description ='PRO: Examples may include assignment sheets, web page, email, newsletters, phone calls, notes, attendance at open house, report cards etc.'                                                                                                                                                                        where rubricRowID = 696
update seRubricRow set description ='PRO: Turns in daily attendance. Grades recorded and updated regularly, report cards and progress reports created.'                                                                                                                                                                                                 where rubricRowID = 697
*/
--end 840 patches ********************************************************************

--begin 862 patches ********************************************************************

/* ANACORTES TSTATE/TINSTRUCTIONAL */

/*
update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher refers to learning target throughout the lesson to assess progress of class and/or individual learning.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students can identify the core learning in the standard and tell how the learning target aligns with the standard.</li>
    <li>Students understand how the learning target will help them answer bigger essential questions.</li>
</ul>' 
where RubricRowID=601

update SERubricRow set Description=

'<p><b><span>Possible Observables: Teacher</span></b></p>
<ul>
    <li>Teacher links standard to prior and future lessons.</li>
    <li>Teacher writes the learning target on the board and either tells or asks students to explain why this is relevant to the student.</li>
</ul>
<p><b><span>Possible Observables: Student</span></b></p>
<ul>
    <li><span>Students understand and can articulate the relevance of the learning.</span></li>
    <li>Students apply new learning to solve a math problem.</li>
</ul>'
where RubricRowID=602

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>The standard is listed on the board, in a writing journal or notebook, and the teacher directs student attention to the standard.</li>
    <li>The learning target is on the board and teacher tells or asks students to explain why this is relevant to the student.</li>
    <li>Big idea, standard, and daily teaching point/learning target are posted in the room, or in student notebooks.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>When asked, students describe the standard and how it relates to a &ldquo;big idea&rdquo; in the content area.</li>
    <li>When asked, students can describe the learning target.</li>
</ul>'
where RubricRowID=603

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher establishes listening center for students to listen to literature.</li>
    <li>Teacher uses the partner reading approach.</li>
    <li>Teacher assigns science lab groups to support success for all students.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Three students who were out on a field trip work as a group on concepts they missed. </li>
    <li>A new non-native English speaker is assessed in his/her first language with regards to the content.</li>
</ul>'
where RubricRowID=604

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher leads students through an exercise of self-assessment.</li>
    <li>Teacher asks students to self-assess against a learning target and to share their understanding with a partner.</li>
    <li>Teacher uses exit slips for students to self-assess and to communicate understanding of the learning targets.</li>
</ul>
<p><b>Possible Observables: Student</b> </p>
<ul>
    <li>Students have a chart of success criteria for the unit.</li>
    <li>Students seek assistance if they do not understand one of the success criteria.</li>
    <li>Students discuss their understandings of the success criteria in their group and help each other improve their understanding.</li>
</ul>'
where RubricRowID=605

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Students are expected to explain their thinking.</li>
    <li>Teacher asks a question and asks A-B partners to first think, then share, then answer and justify their thinking with each other.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students talk to their “elbow partner” about a posed question and explain their reasoning with each other. </li>
    <li>Lab partners talk about their hypotheses and how to prove them.</li>
</ul>'
where RubricRowID=606

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Partner-talk with protocols results in equitable sharing.</li>
    <li>Wait time is used to increase student response to questions.</li>
    <li>Teacher asks questions to probe and deepen students’ conceptual understanding.</li>
    <li>Teacher questions students to uncover misconceptions and assists students to clarify their thinking.</li>
    <li>Teacher engages with students’ ideas to deepen/broaden understanding rather than “correcting” student misconceptions.</li>
    <li>Teacher and students ask probing questions that foster deeper thinking.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students continually try to re-clarify their thinking by explaining reasoning in multiple ways.</li>
    <li>Third graders demonstrate understanding of multiplication by showing a problem solution in words, pictures and numbers.</li>
</ul>'
where RubricRowID=607

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Students have choice about reading or topics to research.</li>
    <li>Teacher models how to solve a problem, works on another one with students, then asks students to solve one on their own.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students reflect on learning.</li>
    <li>Students independently choose new reading at their reading level.</li>
    <li>Students are collecting recording, and interpreting data.</li>
</ul>'
where RubricRowID=608

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Small group work with protocols (e.g. peer editing rubrics, lab rubrics, and discussion rubrics).</li>
    <li>Partner-talk with protocols results in equitable sharing.</li>
    <li>Teacher uses a variety of instructional moves to ensure that all students participate in the talk (providing wait time, who can repeat, who wants to add on, where can we find that, why do you think that?).</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students each have a role in their cooperative groups and are accountable for their work.</li>
    <li>Students in A-B partners hear each other’s ideas then paraphrase what the other student is thinking.
</li>
</ul>'
where RubricRowID=609

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher uses knowledge of students in giving examples (e.g. during read aloud a student to text example, or in analogies).</li>
    <li>Teacher knows where each student “is at” in their ability/skills to participate in talk and scaffolds instruction to ensure equitable participation.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students share personal stories that help clarify and support their personal understanding of the content.</li>
    <li>Students reference their background experiences to support and enhance the understanding of fellow students related to the content.</li>
</ul>'
where RubricRowID=610

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher monitors discourse to be sure that students are on topic.</li>
    <li>Teacher displays a chart with sentence stems for students to use when talking to one another.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students facilitate each other’s learning.</li>
    <li>Students dialogue with each other about ideas.</li>
    <li>Students are engaged and participate in content specific talk or action.</li>
</ul>'
where RubricRowID=611

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher monitors discourse and reminds students to use content-specific vocabulary.</li>
    <li>Teacher reminds students that they are all scientists in her class and must act and talk like scientists.</li>

</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students explain their thinking using analogies/examples/evidence.</li>
    <li>Students explain the options they thought about and why they chose a certain option to attack a math problem.</li>
    <li>Students are responding to a social studies scenario predicting outcomes using evidence from resources.</li>
    <li>Students provide accurate information and refer to text or previously learned information.</li>
    <li>Students elaborate by making analogies, comparing, and contrasting.</li>
    <li>Students justify their reasoning by using multiple models or data ranges.</li>
    <li>Students support their analysis by connecting multiple examples.</li>
    <li>Students make inferences and explain how they know their inference is feasible using evidence.</li>
    <li>Teacher and students ask probing questions that foster deeper thinking.</li>
 </ul>'
where RubricRowID=612

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Posted purpose requires students to think at high levels.</li>
    <li>Text is age appropriate and directly relates to purpose.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students can explain why they chose a specific manipulative to solve a math problem.</li>
    <li>Students make sense of complex concepts by using manipulatives and explaining the connection between concepts and symbols.
</li>
</ul>'
where RubricRowID=613

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Current events include multiple points-of-view.</li>
    <li>Teacher explains to class they are skipping the next section based on the pre-assessment data.
</li>

</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students engage in content-related conversations with peers in their native language if their ability to engage with the content is stronger in that language.</li>
</ul>'
where RubricRowID=614

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher shows clips from a movie and asks students “Could that really happen? Justify your answer.”</li>
    <li>Teacher poses a problem in which students must explore and explain the relationship between area and perimeter.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students talk about making text-to-text, text-to-self and text-to-the-world connections in a literature class.</li>
    <li>Students draw conclusions from observations during a lab experiment using scientific language.</li>
</ul>'
where RubricRowID=615

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher has students create an experiment to test their hypotheses then draw conclusions.</li>
    <li>Teacher has students create their own haiku.</li>

</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students in science describe what might have happened with an experiment when results seem unexpected and decide if it is feasible to do multiple trials.</li>
    <li>Using mathematical vocabulary, students attempt to explain and generalize a process that worked for one math problem.</li>
    <li>Students can explain what they are thinking about while they are reading.</li>
    <li>Students can articulate which part of the writing process they are engaged in.</li>
</ul>'
where RubricRowID=616

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>In trying to decide if a confusing answer from a student is conceptual or a linguistic problem, the teacher asks an ELL student to, “think of the answer in your native language and translate the answer the best you can.” </li>
    <li>Teacher establishes centers for skill practice based on need and students can articulate that they need practice with specific skills.</li>
    <li>Groups are set up to scaffold work and students can articulate their roles.</li>
    <li>Teacher invites a small group to study with her to focus on a specific aspect of the learning target or specific learning targets.</li>
    <li>Leveled readings are provided to cover content at all reading levels.</li>
    <li>Teacher sends different problem sets to students using graphing calculators based on students’ needs.</li>
    <li>Teacher works with a small group to re-teach a specific concept so the class can move forward.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students use anchor charts to refer to when solving problems.</li>
    <li>Groups are set up to scaffold work and students can articulate their roles.</li>
</ul>'
where RubricRowID=617

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher points to purpose and does a class check on progress.</li>
    <li>Routines are in place to support independent work.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students refer to purpose to modify pre-writing, in discussion or group actions.</li>
    <li>Students work successfully without teacher assistance.</li>
    <li>Students use appropriate strategies to edit writing.</li>
</ul>'
where RubricRowID=618

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher uses document cameras to readily display student work.</li>
    <li>Smart boards are used to highlight vocabulary in a text and explain their meaning before reading.</li>

</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students use graphing calculators to determine whether or not their predictions about graphs are accurate.</li>
    <li>Students use computers to manipulate geometric figures and create theories about them.</li>
</ul>'
where RubricRowID=619

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Posted purpose requires students to think at high levels.</li>
    <li>Text is age-appropriate and directly relates to purpose.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students can explain why they chose a specific manipulative to solve a math problem.</li>
</ul>'
where RubricRowID=620

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher uses progress of current laws during the legislative session to teach students about how laws are made.</li>
    <li>Teacher has students read “The Pit and the Pendulum” then has students explore the factors that would determine if the prisoner could actually escape.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Second graders clip coupons from a magazine and add up their savings using various addition techniques. </li>
    <li>Students test their theory about “The Pit and the Pendulum” by making a model and testing it.</li>
</ul>'
where RubricRowID=621

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher formative assessments are aligned with learning targets both in content and processes.</li>
    <li>Summative assessment includes only what was taught and processed during instruction.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students hold up work on small white boards and teacher scans for all students’ responses.</li>
    <li>Each student in small group takes turns explaining thinking while teacher monitors groups.</li>
    <li>Students turn to an “elbow partner” to explain thinking.</li>
    <li>Students participate and respond to probing questions from the teacher.</li>
    <li>At the end of the lesson, students reflect on their learning.</li>
</ul>'
where RubricRowID=622

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Each student in small group takes turns explaining thinking while teacher assesses for progress towards learning targets.</li>
    <li>Teacher confers with individuals or small groups to assess progress.</li>
    <li>Teacher sorts students to practice skills based on previous work.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students have the opportunity to compare their work to an exemplary.</li>
    <li>Students use a rubric to determine their individual levels of proficiency.
</li>
</ul>'
where RubricRowID=623

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher documents student progress and next steps.</li>
    <li>Teacher reads exit slips to check for understanding.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students explain thinking in an exit slip read by the teacher.</li>
    <li>Student record current learning focus on a classroom chart.</li>
    <li>Students chart fluency score.</li>
</ul>'
where RubricRowID=624

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Based on assessment data, teacher pulls aside small group while others work independently.</li>
    <li>Teacher has multiple prompts or questions for students to respond to based on predictions from formative assessment.</li>
    <li>Teacher leads discussion regarding test results, common errors, and goal setting for the next unit.</li>
    <li>Teacher uses planned and “in the moment” assessment feedback to clarify a common misconception.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students use the assessment information to set learning goals and identify strategies to meet the goals.</li>
    <li>Students analyze feedback from teacher and strategize how to incorporate feedback into final product</li>
</ul>'
where RubricRowID=625

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teachers have students compare test results with success criteria and make adjustments.</li>
    <li>Teacher leads discussion regarding test results, common errors, and goal setting for the next unit.</li>
</ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students compare test results with their own assessment of success criteria and see if their assessments are accurate.</li>
    <li>Students analyze common errors on a test or final paper and strategize how to avoid errors next time.</li>
</ul>'
where RubricRowID=626

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>The document camera is ready and set up for use. </li>
    <li>Teacher wants students to talk in groups so desks are arranged in clusters of four.</li>
    <li>Teacher can move around the classroom to monitor, observe and confer.</li>
    <li>There are public records of student work on the walls.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students know where the “meeting area” is and know where to sit so they have personal space.</li>
    <li>Students know where anchor charts are located for their reference.</li>
</ul>'
where RubricRowID=627

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Libraries, materials, charts, technology, and tools are neatly arranged and can be easily accessed by students.</li>
    <li>Teacher puts pens, pencils, erasers and scissors in the middle of group tables so students don’t have to look for them.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students know where materials are kept and access them readily.</li>
    <li>Students are choosing to use a variety of resources for learning.</li>
</ul>'
where RubricRowID=628

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Displayed materials are relevant to and support student success for current content, classroom procedures, learning targets, daily routines, and assignments.</li>
    <li>Teacher makes public records of student ideas related to lesson purpose.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Without prompting, students check a display to collect information missed from previous day.</li>
    <li>Without prompting, students look at and use posted discussion prompts in small groups.</li>
</ul>'
where RubricRowID=629

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher posts sentence stems and invitations such as: “What do you think?” or “Do you agree?” or “What evidence do you have?”</li>
    <li>Teacher uses A-B partners and has one go first/then the other and has set times for the conversation. </li>
    <li>Teacher uses a fish bowl protocol to demonstrate expectations for a discussion or activity.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students utilize content specific language in discourse with other students.</li>
    <li>Students utilize a protocol that was previously taught.</li>
    <li>Students use phrases like “I agree with …” or “I disagree with…” as a routine to continue discourse about a topic.</li>
</ul>'
where RubricRowID=630

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher reviews student homework daily and gives feedback.</li>
    <li>Teacher monitors group work and ensures use of participation protocols.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students turn in homework at the beginning of the class in a designated place.</li>
    <li>Students critique each other’s written work before it is revised and handed in.</li>
    <li>Students perform closing procedures which include student reflection and materials/assignment management.</li>
    <li>Students redirect peers when they are off task.</li>
</ul>'
where RubricRowID=631

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>When needed, check-out procedures are efficient and seamless.</li>
    <li>Teacher re-collects class at the rug to review behavior expectations.  Students then successfully transition to the small group activity.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students change room configuration quickly and efficiently to support different groupings.</li>
    <li>Students engage in learning immediately after a transition.</li>
</ul>'
where RubricRowID=632

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher reserves time for student questions.</li>
    <li>Teacher reserves time for student reflection.</li>
    <li>Teacher provides ample time for exploration in a math class.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students engage in learning for the entire period.</li>
    <li>Students enter classroom and immediately engage in entry tasks.</li>
</ul>'
where RubricRowID=633

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>After teacher cue, misbehaving student immediately stops poor behavior and attends to task at hand.</li>
    <li>After following the student’s behavior plan, teacher sends the student to the office if appropriate.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students independently follow classroom routines and behavioral expectations.</li>
    <li>Students know that they are responsible for their own work and own behavior.</li>
    <li>Students remind each other about classroom behavior routines.</li>
</ul>'
where RubricRowID=634

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Safety posters are easy to read and pertinent.</li>
    <li>Teacher and students are using safety equipment appropriately.</li>
    <li>Teacher demonstrates appropriate use of equipment and follows with step-by-step instructions for students.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students are using safety equipment appropriately.</li>
    <li>Students lead safety drills and become door monitors during such drills.</li>
</ul>'
where RubricRowID=635

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher engages students in a norm-setting activity for the class.</li>
    <li>Teacher displays the written norms, refers to them, and gives the class feedback on adhering to the norms. </li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students engage in debate over an issue in a respectful manner.</li>
    <li>Students refer to discussion/behavioral norms on a chart or in their notebook to redirect a student behavior.</li>
    <li>Students suggest revisions to classroom norms.</li>
</ul>'
where RubricRowID=636

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher models alternative ways of thinking about problems.</li>
    <li>Teacher uses a wrong answer to uncover a common misconception and how to avoid it.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Student says, “I’m not sure if this is correct, but here is my idea.”</li>
    <li>Students know that their status in the classroom comes from their ability to think and reason.</li>
    <li>Student brings problem to the document camera and says, “I need help with this!”  </li>
</ul>'
where RubricRowID=637

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher demonstrates how new skills can be used in student’s lives outside of school.</li>
    <li>Teacher validates student thinking.</li>
    <li>Teacher makes short-term adjustments to address student’s individual emotional needs.</li>
    <li>Teacher references anecdotal notes for student before beginning a lesson. </li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students feel comfortable and at ease in the class.</li>
    <li>Students ask for help from peers when needed.</li>
    <li>Students value peers’ opinions. </li>
    <li>Students assist each other to fully participate in classroom activities.</li>
</ul>'
where RubricRowID=638

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher uses guiding questions to help students problem-solve on their own.</li>
    <li>Students who are struggling with a concept are supported by probing questions from the teacher.</li>
 </ul>
<p><b>Possible Observables: Student</b></p>
<ul>
    <li>Students ask each other for help.</li>
    <li>Students explain issues impacting their learning with the teacher.</li>
</ul>'
where RubricRowID=639

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher is fully prepared for parent conferences.</li>
    <li>Teacher facilitates student-led conferences with parents and caretakers.</li>
    <li>Teacher collaborates with peers.</li>
    <li>Teacher has multiple data points to share with parents and caretakers.</li>
    <li>Teacher communicates positively with parents and caretakers using multiple formats.</li>
</ul>
'
where RubricRowID=640

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher web page is updated weekly with course syllabus, assignments, and policies.</li>
    <li>Teacher uses blog or parent access to enter project information, homework updates, etc.</li>
    <li>Written and verbal communication to parents and caretakers is accessible.</li>
    <li>Teacher ensures important learning documents are translated into the first language of parents and caretakers as needed.</li>
 </ul>
'
where RubricRowID=641

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher shares succinct and relevant information about student progress at an intervention team meeting.</li>
 </ul>
'
where RubricRowID=642

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>When asked, teacher is able to fluently describe the instructional programs in the school.</li>
    <li>Teacher prepares communication about the instructional program in a timely fashion.</li>
    <li>Teacher communicates with students, colleagues, parents, the principal, and support services.</li>
 </ul>
'
where RubricRowID=643

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher communicates with grade level team accurately and positively about successes and challenges for students in the Advanced Placement courses.</li>
    <li>Teacher responds accurately and positively to a request from a special education teacher.</li>
    <li>Teacher requests additional information from support staff in order to assist a student.</li>
 </ul>
'
where RubricRowID=644

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>In a team situation, the teacher gives fair air time, participates, shares ideas and work load, and helps teammates.</li>
    <li>Teacher shares resources fairly with department or grade level.</li>
    <li>Teacher focuses on student achievement during teacher collaboration time.</li>
 </ul>
'
where RubricRowID=645

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher shares successful lessons and asks for feedback.</li>
    <li>Teacher works with peers on a lesson, asks for a peer to observe, and participates in a reflective conversation.</li>
    <li>Teacher makes specific observable changes in his/her practice as a result of collaboration.</li>
    <li>Teacher works with a colleague to set professional goals related to student achievement.</li>
 </ul>
'
where RubricRowID=646

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher knows how to communicate with peers in a way that is honest about practice but respects the individual.</li>
    <li>Teacher is able to pose inquiry questions to peers and engage in professional dialogue.</li>
    <li>Teacher sets and works towards instructional practice goals with colleagues.</li>
 </ul>
'
where RubricRowID=647

update SERubricRow set Description=
'<p><b>Possible Observables: Teacher</b></p>
<ul>
    <li>Teacher works with colleagues to understand and better implement instruction toward state standards.</li>
    <li>Teacher relates current successful practices to new initiatives.</li>
    <li>Teacher asks thoughtful questions about new initiatives to clarify purpose and expectations.</li>
 </ul>
'
where RubricRowID=648

/* KENNEWICK PSTATE */



update SERubricRow set Description=
'<p><b>Emerging:</b></p>
<ul>
    <li>Status quo is accepted.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Is accessible for staff when needed.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Seeks out opportunities for shared decision making.</li>
</ul>' 
where RubricRowID=650

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>No student voice on building decisions. Abdicates away individual responsibility for improvement.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Power is isolated in the hands of select few. Opaque decision making. Student representative on building decisions is a silent.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Models democratic principles of decision making. Being open and accepting to new ideas. Decisions are made with input from all stakeholders. Models appropriate behavior for staff and students. Students are active participants and have a voice as part of building. Basic procedures and norms are transparent and communicated
decisions. Demonstrates and models high expectations for students and staff.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Constantly engaged in self reflection  to improve teaching and learning. Demonstrates high level of transparency. Seeks student input on operation of school.</li>
</ul>' 
where RubricRowID=651


update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Drills are not done, or are done incompetently. School Safety plan is incomplete.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Drills are scheduled in accordance with district policy and state law. Safety plans are written, stored on the shelf and communicated to staff. Safety plan reviewed annually with all stakeholders.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Staff and students can demonstrate an understanding of crisis response plan. Clear communication around school safety issues. Dialogue around safety issues takes place.
Enures proper prevention training.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Crisis plan is tested in dynamic situations.</li>
</ul>' 
where RubricRowID=655

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Inconsistency in application of school discipline. Lack of a school discipline plan.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>School discipline plan is communicated with all stakeholders. Plan is in place. Annual review of school discipline plan based upon school data. Follows school district policies and state law. Knows and applies special education/504 regulations and laws regarding discipline.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Changes in school discipline plan based upon data. Consistent application of school rule. All stakeholders (Parents, Students) voice is part of the development/review of school discipline plan.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Proactive planning designed to address variety of issues. School wide commitment to student discipline plan. Principal is visible in high incident areas. Promotes and models an atmosphere of inclusiveness, equity and respect among students, staff and community.
</li>
</ul>' 
where RubricRowID=656

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Classroom management plans not available. Teachers need help and help is inadequate.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Clear expectations and communication of classroom and school discipline. Clear communication to students around behaviors. Collects classroom management plans and keep in a central location.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Visits classrooms regularly to provide teacher feedback on student management plan. Creates an academic culture where students are safe and engaged in their own learning.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Solution-focused plans implemented at the classroom level. </li>
</ul>' 
where RubricRowID=659

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Principal doesn’t demonstrate knowledge of effective teaching strategies (PERR +). Principal fails to follow state law and contract language regarding observation and evaluation cycle.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal demonstrates knowledge of effective teaching strategies, with support. Principal inconsistently follows state law and contract language regarding observation and evaluation cycle.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Principal demonstrates knowledge of effective teaching strategies and assists staff in self-evaluation leading to effective practice.
Principal consistently follows state laws and contract language observation and evaluation cycle.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Develop collaboration and peer mentoring among staff.</li>
</ul>' 
where RubricRowID=660

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Little or no evidence of assisting staff in the use of data to modify instruction or student learning.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Limited evidence of assisting staff in the use of data to modify instruction or student learning.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Principal assists staff in the use of multiple data elements to modify instruction and improve student learning.</li>
</ul>
' 
where RubricRowID=654

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Little or no evidence of feedback to staff.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal provides feedback to staff.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Two way communication between principal and staff regarding feedback leading to effective practice.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Assist staff in self-evaluation leading to effective practice.</li>
</ul>' 
where RubricRowID=657

update SERubricRow set Description=
'
<p><b>Emerging:</b></p>
<ul>
    <li>Works to procure good curriculum materials in literacy and math. Member of District Curriculum Advisory Committees. Ensures that curriculum is aligned to district, state and national standards. Ensures that curriculum maps exist vertically and horizontally.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Gets the best possible literacy, math, science and social studies materials into teachers’ hands. Active participant in District CAC. Assists staff in adjusting to and accepting curriculum, instruction and assessment changes. Demonstrates consistent understanding and application of curriculum alignment strategies.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Ensures that all teachers have training on how to use curriculum. Ensures that curriculum addresses both remediation and enrichment needs . Is a leader of district curriculum adoption cycles. Advocates for successful implementation of curriculum adoptions by mobilizing stakeholders.
</li>
</ul>' 
where RubricRowID=664

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Absence of clear and consistent focus. Curriculum unconnected vertically and horizontally. Unaware of curriculum implementation.
</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Knows Power  Standards/GLE’s in multiple areas. Provides time for teachers to work collaboratively. Ensures pacing guides in place.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Creates a sense of ownership and shared accountability for the alignment of curriculum. Facilitates the development and use of common assessments. Works with staff to ensure fidelity to pacing guides.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>The  use of frequent common assessments is a building norm and ensures that they are used to drive instruction. Is a resource for teachers as they encounter challenges in pacing.
</li>
</ul>' 
where RubricRowID=665


update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Is not aware of school  performance expectations. Little to no consensus around common expectations</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>School performance expectations are communicated frequently to multiple stakeholders.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>School performance expectations are based on state and district expectations. Ensures staff collaborates on the development and alignment of curriculum based on district and state standards.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Evidence of implementation of school performance expectations.</li>
</ul>' 
where RubricRowID=666

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Supporting Documentation. Does not address difficult personnel issues.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Mostly comply with state law & contract language with support. Incompletely addresses difficult personnel issues with support.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Fully implements state law and contract language. Adequately addresses difficult personnel issues.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Use evaluation tool to enhance professional growth. Seeks and initiates strategies to address difficult personnel issues.</li>
</ul>' 
where RubricRowID=667

update SERubricRow set Description=
'
<p><b>Proficient:</b></p>
<ul>
    <li>Well-planned and connected to school improvement plan.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Plans are based on staff needs and student data. </li>
</ul>' 
where RubricRowID=658

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Supporting Documentation. Does not create budgets that comply with state law and district policy, with support.
</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Supporting Documentation. Generally creates budgets that comply with state law and district policy, with support.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Supporting Documentation. Creates budgets that comply with state law and district policy.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Supporting Documentation. Making use of data. Involving staff in budget development</li>
</ul>' 
where RubricRowID=668

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Principal fails to demonstrate ability to staff building to meet basic student needs (i.e. class size course requirements).</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal demonstrates ability to staff the building to meet basic student needs.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Principal demonstrates the ability to staff the building to meet student needs and some interventions.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Principal seeks and initiates innovative strategies to meet student needs for basic education and interventions for both the challenged and gifted students.</li>
</ul>' 
where RubricRowID=669

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Principal does not follow district policies and procedures for hiring. Doesn’t comply with state law and contract language</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal follows basic school district policies and contract language for hiring staff.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Principal uses school district policies and contract language to hire staff based on needs.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Principal involves staff in recruiting and hiring successful staff members based on predetermined needs.</li>
</ul>' 
where RubricRowID=670

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>SIP is incomplete, is poorly written, is not current, or does not meet the needs of the building. SIP is written and on the shelf, not utilized to guide building decisions. No formal process for how the SIP is created, revised and reviewed.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>All components are present and principal can verbalize the purpose of the SIP. SIP contains relevant data. Goals are apparent, visible and apply to school. SIP substantially the same from year to year without careful review.
</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Ensures SIP is focused feasible and implementable. Data is analyzed, clearly communicated to stakeholders and used to drive decisions. SIP contains a wide variety of data. Each goal contained in the SIP is in SMART format.SIP is developed collaboratively with numerous stakeholder voices present annually.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>SIP is used to collaborate, problem solve and build consensus with individuals and groups. SIP is a living document that is adjusted throughout the year. Principal utilizes extensive data to make building goals and decisions with a high level of specificity. Principal leads a formal process to set goals, reflect on data and modify throughout the year.</li>
</ul>' 
where RubricRowID=671

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Principal is not aware of the variety of data that is available. Data is created for principal but is not used to make decisions.
</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal is aware of and uses mainly student achievement data to make decisions. Principal makes minimal use of data provided in decision making.
</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Principal integrates multiple data points to make informed decisions. Principal creates and disseminates data to a variety of stakeholders. Principal schedules data meetings,  engaged in a no-blame search for root causes and constant hypothesis testing.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Principal utilizes focus groups, surveys, assessment data, grades, demographic data, research, and best practices. Principal searches for and creates opportunities for data to impact decisions from a wide variety of sources. Principal creates data, disseminates data to stakeholders and ensures that decisions are made based upon it. Data is used to assist teachers in modifying and  changing instruction.
</li>
</ul>' 
where RubricRowID=672

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Little or no evidence of communication. No attempt to engage families. Interacts negatively.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Required communication completed. Student Handbooks, Newsletters, State assessment data.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Regular communication. Develop strategies to engage parents and community. Promptly responds to parents appropriately. Uses resources to develop bridges with a variety of cultures and languages.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Engagement strategies become two-way communication. Initiates contact.
</li>
</ul>' 
where RubricRowID=673

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Stays in Office; not in classrooms. No attempt to engage any of the school stakeholders in school activities.
</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Principal is working within their own building. Principal works with those who seek to be involved with their building. Minimal parent involvement.
</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Seeks to involve school community in school activities. Partner and collaborate with administrative colleagues. Build collegial  /collaborative relationships with staff.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Seeks and develops frequent parent, business and community leader involvement related to school improvement. </li>
</ul>' 
where RubricRowID=674

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li> Principal provides little or no training.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li> Principal provides minimal training.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li> Principal provides training to ensure student data system is used to report progress.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Principal supports staff in regular use of a variety of innovative communication methods with community to improve student learning.</li>
</ul>' 
where RubricRowID=675

update SERubricRow set Description=
'
<p><b>Emerging:</b></p>
<ul>
    <li>Is aware of diversity issues.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Collects and analyzes data associated with student achievement.</li>
</ul>
' 
where RubricRowID=661


update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Absence of a plan to address equity and access issues in the classroom.</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Develops, reviews and revises plans to address the achievement gap.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Develops, reviews and revises plans to address the achievement gap. Evidence of revision. 
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Analyzes plan for system effectiveness and revises as needed.</li>
</ul>' 
where RubricRowID=662

update SERubricRow set Description=
'
<p><b>Emerging:</b></p>
<ul>
    <li>Identifies targeted student populations.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Ensures instruction is modified to meet learner needs. Utilizes resources to meet the needs of targeted student populations.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Seeks opportunities for staff to engage in professional development and reflect on achievement gap issues (poverty, ethnicity, special services, gender, ELL, etc.) Utilizes human resources to meet the needs of targeted populations.
</li>
</ul>' 
where RubricRowID=663

update SERubricRow set Description=
'
<p><b>Emerging:</b></p>
<ul>
    <li>Inconsistent collegial conversations focusing on improving instruction working with diverse learners. Expects that teachers consistently have welcoming, inviting classrooms. </li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Consistent collegial conversations focusing on improving instruction working with diverse learners. Consistently communicates and reinforces that teachers have welcoming, inviting classrooms.
</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Provides opportunities and encourages staff to have collegial conversations focusing on improving instruction working with diverse learners. Student achievement data demonstrates a commitment closing the achievement gap. 
</li>
</ul>' 
where RubricRowID=676

update SERubricRow set Description=
'<p><b>Unsatisfactory:</b></p>
<ul>
    <li>Absence of a plan to address equity and access issues in the classroom. Targeted students generally not demonstrating growth in literacy and mathematics. Unaware of demographic issues and the impact on student achievement. Absence of a plan for addressing impact of demographic issues on student achievement.
</li>
</ul>
<p><b>Emerging:</b></p>
<ul>
    <li>Knowledge of low performing students. Targeted students generally demonstrating annual growth in literacy and mathematics. Demonstrates an awareness of variety of cultures present in school. Regularly monitor the progress of underperforming students. Selecting appropriate interventions for underperforming students.</li>
</ul>
<p><b>Proficient:</b></p>
<ul>
    <li>Knowledge of low performing students. Targeted students generally demonstrating annual growth in literacy and mathematics. Demonstrates an awareness of variety of cultures present in school. Regularly monitor the progress of underperforming students. Selecting appropriate interventions for underperforming students.</li>
</ul>
<p><b>Exemplary:</b></p>
<ul>
    <li>Majority of targeted students demonstrate more than annual growth in literacy and mathematics. Engage community to provide equity and access for all students. Actively pursue resources that will address student needs. Creates opportunities for stakeholders to become actively involved in the school community.</li>
</ul>' 
where RubricRowID=677

*/


--end 862 patches ********************************************************************
--begin 866 patches ********************************************************************
/*
--kennewick teacher evidence tweaks...
update seRubricRow set description = 'PRO: Questions and activities extend beyond the knowledge level.'                                                                                                                                                 where rubricRowID = 689
update seRubricRow set description = 'PRO: Formal and infomal checks of student learning are ongoing and used throughout lessons and/or  units. Strategies may include class discussions, every pupil response activities, tests, daily assignments.'   where rubricRowID = 687
update seRubricRow set description = 'PRO: Evidence of teacher use of student data to adjust lesson instruction and assignments through reteaching, pacing, student grouping and interventions.'                                                        where rubricRowID = 688    
update seRubricRow set title = 'Promotes Higher Level Thinking       - Rigorous Content (ambiguous, complex, provocative, emotionally/personally challenging)' where rubricRowID = 689


--othello teache evidence tweaks...
update seRubricRow set description = 'All:<ul><li>Lesson Plans</li></ul>Innovative: All *and* Unit Plans' where RubricRowID = 920
update SERubricRow set Description = 'All:<ul><li>Observation</li></ul>' where RubricRowID in  (923, 924, 925)
update SERubricRow set Description = 'All:<ul><li>Observations</li></ul>' where RubricRowID =922
update SERubricRow Set Description = 'All:<ul><li>Pre-Observation Meeting</li></ul>Innovative:All *and* Documentation of Interventions and Observation Reports</li></ul>' where RubricRowID = 926
update SERubricRow set Description = 'All:<ul><li>Discussion</li></ul>Innovative: All *and* Documentation' where RubricRowID = 927
update SERubricRow set Description = 'All:<ul><li>Observation</li></ul>Innovative: All *and* Documentation' where RubricRowID = 928
update SERubricRow set Description = 'All:<ul><li>Observations</li></ul>' where RubricRowID in (929, 930, 931, 932)
update SERubricRow set Description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>Proficient and Innovative: All *and* Classroom Management Plan' where RubricRowID in (933)
update SERubricRow set Description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>' where RubricRowID in (934)
update SERubricRow set Description = 'All:<ul><li>Observations</li><li>Classroom Management Plan</li><li>Discpline Forms</li></ul>Innotvative: All *and* Discussion' where RubricRowID in (935)
update SERubricRow set Description = 'All:<ul><li>Documentation of Student Progress</li><li>Discussion</li></ul>Innovative: All *and* Documentation of Additional Data' where RubricRowID in (937)
update SERubricRow set Description = 'All:<ul><li>Observations</li><li>Discussions</li></ul>Innovative: All *and* Student Goal Sheets' where RubricRowID in (938)
                                         
update SERubricRow set Description = 'All:<ul><li>Documentation</li><li>Discussions</li></ul>' where RubricRowID in (939)
update SERubricRow set Description = 'All:<ul><li>Documentation</li><li>Observations</li><li>Discussions</li></ul>' where RubricRowID in (940)
update SERubricRow set Description = 'All:<ul><li>Documentation</li><li>Observations</li><li>Discussions</li></ul>Innovative: All *and* Lesson Plans' where RubricRowID in (941)
update SERubricRow set Description = 'All:<ul><li>Discussions</li><li>Observations</li></ul>' where RubricRowID in (942)
update SERubricRow set Description = 'All:<ul><li>Observations</li><li>Discussions</li><li>Documenation</li></ul>' where RubricRowID in (943)

--othello principal tweaks
update SERubricRow set Description = '<ul><li></li><li>PLC Minutes/Agenda</li><li>Staff Meeting Agenda and  Minutes</li><li>LID Agendas/Minutes</li><li>Inservices</li><li>Curriculum Day Requests</li></ul>' where RubricRowID=906
update SERubricRow set Description = '<ul><li></li><li>Plans of support & improvement</li><li>Documentation of coaching & support</li><li>Documentation of pre- and post observations</li><li>Teacher Evaluations</li><li>Planning and scheduling for new teacher mentoring and meetings; list of new teachers and assigned mentors</li><li>Evidence of agendas and staff/department/grade level meetings and staff development</li><li>Staff development activities that  address identified   needs</li></ul>' where RubricRowID=907

--bugzilla 2434
update SERubricRow set Description = REPLACE (Description, '<li></li>', '') where RubricRowID between 895 and 919

--bugzilla 2423
update seRubricRow set description = Replace(description, 'PRO:', 'PROFICIENT:') where belongsToDistrict = '03017' and Description like 'PRO:%'


--bugzilla 2422
update seRubricRow set description = Replace(description, 'EVIDENCE: ', '') where belongsToDistrict = '32356' and Description like 'EVIDENCE: %'
update seRubricRow set description = Replace(description, 'Examples of EVIDENCE: ', '') where belongsToDistrict = '32356' and Description like 'Examples Of EVIDENCE: %'

*/

--end 866 patches ********************************************************************

--begin 872 patches ********************************************************************
/*
--bugzilla 2447 *****************************************************************
--con princ ifw is framework id 24

delete SERubricRowFrameworkNode where FrameworkNodeID in
(select FrameworkNodeID from seFrameworkNode where frameworkID =24)

delete SEFrameworkNode where FrameworkID =24
delete SEFrameworkPerformanceLevel where FrameworkID =24


--*****************North Mason Teacher - State fix
-- what rrs are we talking about?
--select distinct RubricRowID, title from vRowsInFramework where FrameworkID in (9, 29) order by RubricRowID

delete seRubricRowFrameworkNode
where frameworkNodeID in (
select frameworkNodeID from SEFrameworkNode where FrameworkID in (9)  --9 is state
)

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select  frameworkNodeid, rubricRowID, rubricRowID--, fn.ShortName, rr.title 
from SEFrameworkNode fn
join stateeval_prepro.dbo.d2sII m on CONVERT (varchar(2), m.s) = SUBSTRING(fn.shortname, 2, 1)
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = m.d 
where fn.FrameworkID = 9 and rr.rubricRowID between 841 and 862
order by ShortName--, rr.title

--********************North Thurston Teacher - State fix
-- what rrs are we talking about?
--select distinct RubricRowID, title from vRowsInFramework where FrameworkID in (7,16) order by RubricRowID

delete seRubricRowFrameworkNode
where frameworkNodeID in (
select frameworkNodeID from SEFrameworkNode where FrameworkID =16   --16 is state
)
insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select  frameworkNodeid, rubricRowID, rubricRowID--, fn.ShortName, rr.title 
from SEFrameworkNode fn
join stateeval_prepro.dbo.d2sII m on CONVERT (varchar(2), m.s) = SUBSTRING(fn.shortname, 2, 1)
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = m.d 
where fn.FrameworkID = 16 and rr.rubricRowID between 863 and 884
order by ShortName--, rr.title
*/
--end 872 patches ********************************************************************
--begin 908 patches  ********************************************************************
/*
--indiana state rubrics

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IFWTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved) 
VALUES('Indiana TS', 'Indiana State Teacher Rubrics', 'IST01', 2012, 1, 1
			, 1, '', 0, 1)

DECLARE @fid bigint
select @fid= frameworkId from SEFramework where Name = 'Indiana TS'
			
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode)
select  @fid, Criteria, [criteria Description], [Criteria Shortname]
,ROW_NUMBER() over (order by [criteria shortname]),1
from stateeval_prepro.dbo.INFN_TState

insert SERubricRow (Title, PL1Descriptor, PL2Descriptor, PL3Descriptor,PL4Descriptor, Description, IsStateAligned, BelongsToDistrict) 
select [Criteria ShortName] + title,PLD1, ISNULL(PLD2, ''), PLD3, ISNULL(PLD4, ''),isnull(evidence, ''), 1, 'IST01' from stateeval_prepro.dbo.INRR_TState


insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER()   over ( partition by frameworkNodeID order by RubricRowID) * 10 from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1,2) = fn.shortname

update SERubricRow set Title = SUBSTRING (title, 3, 5000) where BelongsToDistrict = 'IST01'

insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 1, 'Ineffective', 'I','')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 2, 'Improvement Needed', 'IN','')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 3, 'Effective', 'E','')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 4, 'Highly Effective', 'HE','')

*/

--end 908 patches  ********************************************************************
--begin 940 patches  ********************************************************************

--bugzilla 2447
--bugzilla 2493

/*
--eliminate all ifw from framework
-- rearrange teacher self and teacher
create table #s2dConSelf (st int, dan varchar(2))
insert #s2dConSelf(st, dan) values(1	,'1c')
insert #s2dConSelf(st, dan) values(1	,'2b')
insert #s2dConSelf(st, dan) values(1	,'3a')
insert #s2dConSelf(st, dan) values(2	,'1e')
insert #s2dConSelf(st, dan) values(2	,'3b')
insert #s2dConSelf(st, dan) values(2	,'3c')
insert #s2dConSelf(st, dan) values(2	,'4a')
insert #s2dConSelf(st, dan) values(3	,'1b')
insert #s2dConSelf(st, dan) values(3	,'1d')
insert #s2dConSelf(st, dan) values(3	,'3e')
insert #s2dConSelf(st, dan) values(4	,'1a')
insert #s2dConSelf(st, dan) values(5	,'2a')
insert #s2dConSelf(st, dan) values(5	,'2c')
insert #s2dConSelf(st, dan) values(5	,'2d')
insert #s2dConSelf(st, dan) values(5	,'2e')
insert #s2dConSelf(st, dan) values(6	,'1f')
insert #s2dConSelf(st, dan) values(6	,'3d')
insert #s2dConSelf(st, dan) values(6	,'4b')
insert #s2dConSelf(st, dan) values(7	,'4c')
insert #s2dConSelf(st, dan) values(8	,'4d')
insert #s2dConSelf(st, dan) values(8	,'4e')
insert #s2dConSelf(st, dan) values(8	,'4f')

create table #s2dCon (st int, dan varchar(2))
insert #s2dCon(st, dan) values(1	,'1c')
insert #s2dCon(st, dan) values(1	,'2b')
insert #s2dCon(st, dan) values(2	,'3b')
insert #s2dCon(st, dan) values(2	,'3c')
insert #s2dCon(st, dan) values(2	,'4a')
insert #s2dCon(st, dan) values(3	,'1b')
insert #s2dCon(st, dan) values(4	,'1a')
insert #s2dCon(st, dan) values(5	,'2a')
insert #s2dCon(st, dan) values(5	,'2c')
insert #s2dCon(st, dan) values(6	,'1f')
insert #s2dCon(st, dan) values(6	,'3d')
insert #s2dCon(st, dan) values(7	,'4c')
insert #s2dCon(st, dan) values(8	,'4d')

update seRubricRow set belongsToDistrict = 'CTEAC' where RubricRowID in (

select distinct rubricRowId from vRowsInFramework where FrameworkID in (25, 26, 27, 28)
)

--get rid of the links
delete SERubricRowFrameworkNode where FrameworkNodeID in 
(
select distinct FrameworkNodeID from vRowsInFramework where FrameworkID in (24, 25, 26, 27, 28)
)

--get rid of framework nodes and frameworks for all IFWs
delete SEFrameworkNode where FrameworkID in (24, 25, 26)
delete SEFrameworkPerformanceLevel where FrameworkID in (24, 25, 26)
delete SEFramework where FrameworkID in (24, 25, 26)

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select  frameworkNodeid, rubricRowID, rubricRowID--, fn.ShortName, rr.title 
from SEFrameworkNode fn
join #s2dCon m on CONVERT (varchar(2), m.st) = SUBSTRING(fn.shortname, 2, 1)
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = m.dan 
where fn.FrameworkID =27 and rr.BelongsToDistrict = 'cteac'
order by ShortName--, rr.title

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select  frameworkNodeid, rubricRowID, rubricRowID--, fn.ShortName, rr.title 
from SEFrameworkNode fn
join #s2dConSelf m on CONVERT (varchar(2), m.st) = SUBSTRING(fn.shortname, 2, 1)
join SERubricRow rr on SUBSTRING(rr.title, 1, 2) = m.dan 
where fn.FrameworkID =28 and rr.BelongsToDistrict = 'cteac'
order by ShortName--, rr.title

update seRubricRow set belongsToDistrict = '00000' where belongsToDistrict = 'CTEAC'


GO
*/

--end 908 patches  ********************************************************************
--begin 969 patches  ********************************************************************
--bugzilla 2506
/*
update seRubricRowFrameworkNode set frameworkNodeID = 365 where frameworkNodeID = 359 and rubricRowID=824
update seRubricRowFrameworkNode set frameworkNodeID = 365 where frameworkNodeID = 359 and rubricRowID=825
update seRubricRowFrameworkNode set frameworkNodeID = 365 where frameworkNodeID = 359 and rubricRowID=826
update seRubricRowFrameworkNode set frameworkNodeID = 365 where frameworkNodeID = 359 and rubricRowID=827
update seRubricRowFrameworkNode set frameworkNodeID = 359 where frameworkNodeID = 365 and rubricRowID=834
update seRubricRowFrameworkNode set frameworkNodeID = 359 where frameworkNodeID = 365 and rubricRowID=835
update seRubricRowFrameworkNode set frameworkNodeID = 359 where frameworkNodeID = 365 and rubricRowID=836
update seRubricRowFrameworkNode set frameworkNodeID = 359 where frameworkNodeID = 365 and rubricRowID=837
*/

--end 969 patches  ********************************************************************
--begin 977 patches  ********************************************************************
/*
-- north mason relink; equivalent to patch _9 in the production tree
delete seRubricRowFrameworkNode where frameworkNodeID = 334	and rubricRowID =843
delete seRubricRowFrameworkNode where frameworkNodeID = 335	and rubricRowID =845
delete seRubricRowFrameworkNode where frameworkNodeID = 335	and rubricRowID =854
delete seRubricRowFrameworkNode where frameworkNodeID = 336	and rubricRowID =844
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowID, sequence) values (334, 854, 900)
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowID, sequence) values (337, 843, 901)
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowID, sequence) values (337, 844, 902)
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowID, sequence) values (337, 845, 903)
*/
--end 977 patches  ********************************************************************
--begin 987 patches  ********************************************************************

/*
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype
, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) 
VALUES('Indiana PS', '', 'IST01', 2012, 3, 1, null, 0, 1, 1) 

DECLARE @fwid bigint
SELECT @fwid = SCOPE_IDENTITY()

--select @fwid = 32


insert SEFrameworkNode (FrameworkID, ParentNodeID, Title, Description, ShortName, Sequence, IsLeafNode)
select  @fwid, NULL, Criteria, '', shortName, row_number() over (order by shortname), 1
from 
(
	select distinct Criteria, shortName
	from StateEval_PrePro.dbo.INPrinRR
) X
order by ShortName

insert SERubricRow (Title,Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor,BelongsToDistrict, IsStateAligned, ev1)
select RRNo + ' - ' + Title,'', PLD1, PLD2, PLD3, pld4 , 'INST01', 1, criteria
from StateEval_PrePro.dbo.InPrinRR
order by RRNo

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)
select FrameworkNodeID, RubricRowID, 10 *ROW_NUMBER() over (order by rr.rubricRowID) from SERubricRow rr 
join SEFrameworkNode fn on fn.Title = rr.ev1

update SERubricRow set BelongsToDistrict = 'IST01' , ev1 = '' where BelongsToDistrict = 'INST01'

insert SEFrameworkPerformanceLevel(FrameworkID, PerformanceLevelID, Shortname, FullName, Description)
select @fwid, PerformanceLevelId, ShortName, FullName, ''
from SEFrameworkPerformanceLevel
where FrameworkID = 31
*/
--end 987 patches  ********************************************************************
--begin 993 patches  ********************************************************************
--North Thurston Principal Rubrics
/*
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IFWTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved) 
VALUES('North Thurston PS', 'North Thurston Principal Rubrics', '34003', 2012, 3, 1
			, 1, null, 0, 1)

DECLARE @fid bigint
select @fid= frameworkId from SEFramework where Name = 'North Thurston PS'
			
Insert SEFrameworkNode (FrameworkId, Title, Description, ShortName, Sequence, isLeafNode)
select  @fid, title, description, shortname, sequence, isLeafnode
from SEFrameworkNode where FrameworkID = 2

DECLARE @LastFWNid bigint
select @LastFWNid = max(frameworkNodeID) from seFrameworkNode
update SEFrameworkNode set Title = 'Managing both staff and fiscal resources to support student achievement and legal responsibilities.'
where FrameworkNodeID = @LastFWNid-2


insert SERubricRow (Title, PL1Descriptor, PL2Descriptor, PL3Descriptor,PL4Descriptor, Description, IsStateAligned, BelongsToDistrict) 
select title, p1, p2, p3, p4, '', 1, '34003'
from stateeval_prepro.dbo.NTPrr


insert SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence)
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER()   over ( partition by frameworkNodeID order by RubricRowID) * 10 from SEFrameworkNode fn
join SERubricRow rr on SUBSTRING(rr.title, 1,2) = fn.shortname
where RubricRowID > 1000 and FrameworkNodeID > 391


insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 1, 'Unsatisfactory', 'UNS'
,'Principal rarely demonstrates minimum application of the components.')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 2, 'Basic', 'BAS'
,'Principal occasionally demonstrates application of the components.')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 3, 'Proficient', 'PRO'
,'Principal consistently demonstrates application of the c
omponents.')
insert SEFrameworkPerformanceLevel (frameworkID, performanceLevelID, fullname, shortname, Description) values (@fid, 4, 'Distinguished', 'DIS'
,'Principal consistently demonstrates application of the components that results in increased student achievement.')
*/
--end 993 patches  ********************************************************************
--begin 1065 patches  ********************************************************************
--bug2579_IsStateAligned_patch_13.sql
/*

UPDATE seRubricRow 
SET isStateAligned = 0
FROM seRubricRow rr
JOIN dbo.vRowsInFramework rif ON rif.rubricrowID = rr.rubricrowID
JOIN dbo.SEFramework f ON f.FrameworkID = rif.FrameworkID
WHERE name LIKE '%thurston%'
AND f.FrameworkTypeID IN (1, 2)



UPDATE seRubricRow
SET IsStateAligned = 1
WHERE rubricRowID IN 
(
SELECT DISTINCT rubricRowID FROM dbo.vRowsInFramework rif
JOIN seframework f ON f.FrameworkID = rif.FrameworkID
WHERE name LIKE '%thurston%'
AND f.FrameworkTypeID IN (1, 2)
)


*/
/*
SELECT DISTINCT * FROM dbo.vRowsInFramework rif
JOIN seframework f ON f.FrameworkID = rif.FrameworkID
WHERE name LIKE '%thurston%'
AND f.FrameworkTypeID IN (1, 2)

*/



--end 1066 patches  ********************************************************************
/* helpful for kenn pre pro recreation...
UPDATE dbo.PR_Evidence SET p1Text = '<li><b>Unsatisfactory:</b>&nbsp;-&nbsp;' + p1 + '</li>' WHERE p1 IS NOT NULL
UPDATE dbo.PR_Evidence SET p2Text = '<li><b>Emerging:</b>&nbsp;-&nbsp;' + p2 + '</li>' WHERE p2 IS NOT NULL
UPDATE dbo.PR_Evidence SET p3Text = '<li><b>Proficient:</b>&nbsp;-&nbsp;' + p3 + '</li>' WHERE p3 IS NOT NULL
UPDATE dbo.PR_Evidence SET p4Text = '<li><b>Exemplary:</b>&nbsp;-&nbsp;' + p4 + '</li>' WHERE p4 IS NOT NULL

UPDATE pr_evidence SET DESCRIPTION = ''
UPDATE pr_evidence SET DESCRIPTION = DESCRIPTION + p1Text WHERE p1Text IS NOT NULL
UPDATE pr_evidence SET DESCRIPTION = DESCRIPTION + p2Text WHERE p2Text IS NOT NULL
UPDATE pr_evidence SET DESCRIPTION = DESCRIPTION + p3Text WHERE p3Text IS NOT NULL
UPDATE pr_evidence SET DESCRIPTION = DESCRIPTION + p4Text WHERE p4Text IS NOT NULL
UPDATE pr_evidence SET DESCRIPTION = '<ul>' + DESCRIPTION + '</ul>'

--sql data compare cannot verify the rrfn table... so if something shows up in this query, something is wrong..
SELECT * FROM seRubricRow rr
JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.RubricRowID = rr.RubricRowID
JOIN dbo.SEFrameworkNode fn ON fn.FrameworkNodeID = rrfn.FrameworkNodeID
WHERE rr.BElongsToDistrict = '03017' AND frameworkId NOT IN (5, 6)

*/


--begin 1320 patches  **From now on, this number of the _prototypes sub project*********

--bugzilla 2619
--kennewick... current teacher framework = 6
--                   , principal framework = 5
--                   , district code = 03017
--first, delete *all* the kennewick rrs 

--kennewick... current teacher framework =
--                   , principal framework = 5
--                   , district code = 03017
--first, delete *all* the kennewick rrs 
/*
DELETE seRubricRowFrameworkNode
WHERE rubricRowID IN 
(SELECT rubricRowID FROM dbo.SERubricRow WHERE BelongsToDistrict = '03017')

DELETE seRubricRow WHERE BelongsToDistrict = '03017'

DECLARE @teacherXferId UNIQUEIDENTIFIER, @prinXferID UNIQUEIDENTIFIER
SELECT @teacherXferID = NEWID();
SELECT @prinXferID = NEWID();


--Teacher (frameworkid = 6)

INSERT dbo.SERubricRow
        ( Title ,
		  Description,
          PL1Descriptor ,
          PL2Descriptor ,
          PL3Descriptor ,
          PL4Descriptor ,
          XferID,
          BelongsToDistrict
        )
SELECT    Title , '', l1, l2, l3, l4
,@teacherXferId, '03017'
FROM StateEval_PrePro.dbo.TeacherRR
ORDER BY title 


INSERT dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
        )

SELECT fn.FrameworkNodeID, rr.RubricRowID, rr.RubricRowID
FROM seframeworkNOde fn
JOIN seRubricRow rr ON SUBSTRING(rr.title,1, 1) = SUBSTRING(fn.ShortName, 2, 1) 
WHERE frameworkID = 6 AND rr.xferId = @teacherXferID
ORDER BY rr.rubricrowid

UPDATE dbo.SERubricRow 
SET Description = 'Proficient: ' + ev.evidence
FROM dbo.SERubricRow rr JOIN StateEval_PrePro.dbo.teacherEvidence ev ON ev.title = rr.title
WHERE rr.BelongsToDistrict = '03017' and rr.xferId = @teacherXferID


--Principal (frameworkid = 5)

INSERT dbo.SERubricRow
        ( Title ,
          Description ,
          PL1Descriptor ,
          PL2Descriptor ,
          PL3Descriptor ,
          PL4Descriptor ,
          XferID,
          BelongsToDistrict
        )
SELECT    Title ,'' , p1, p2, p3, p4, @prinXferId, '03017'
FROM StateEval_PrePro.dbo.PrinRR ORDER BY title

INSERT dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
        )

SELECT fn.FrameworkNodeID, rr.RubricRowID, rr.RubricRowID
FROM seframeworkNOde fn
JOIN seRubricRow rr ON SUBSTRING(rr.title,1, 1) = SUBSTRING(fn.ShortName, 2, 1) 
WHERE frameworkID = 5 AND rr.xferId = @prinXferId
ORDER BY rr.rubricrowid


UPDATE dbo.SERubricRow SET BelongsToDistrict = 'prKenn' WHERE xferId = @prinXferID

UPDATE dbo.SERubricRow
SET description  = ISNULL(ex.description, '')
FROM dbo.SERubricRow rr
JOIN StateEval_PrePro.dbo.PR_Evidence ex ON SUBSTRING (rr.title,1, 2) = SUBSTRING(ex.which,1,2)
WHERE rr.BelongsToDistrict = 'prKenn'

UPDATE dbo.SERubricRow SET BelongsToDistrict = '03017' WHERE BelongsToDistrict = 'prkenn'
*/
--end 1320 patches    **From now on, this number of the _prototypes sub project*********

--begin 1835 patches    **From now on, this number of the _prototypes sub project*********
--bug 2621
/*
UPDATE dbo.SERubricRow SET description = 
'<ul><li><b>Unsatisfactory:</b>&nbsp;-&nbsp;Absence of a plan to address equity and access issues in the classroom. '
+'Targeted students generally not demonstrating growth in literacy and mathematics. Unaware of demographic issues '
+'and the impact on student achievement. Absence of a plan for addressing impact of demographic issues on student '
+'achievement.</li><li><b>Emerging:</b>&nbsp;-&nbsp;Knowledge '
+'of low performing students. Targeted students generally demonstrating annual growth in literacy and mathematics. '
+'Demonstrates an awareness of variety of cultures present in school. Regularly monitor the progress of underperforming '
+'students. Selecting appropriate interventions for underperforming '
+'students.</li><li><b>Proficient:</b>&nbsp;-&nbsp;Utilize a variety of assessment data and ensure instruction meets '
+'the needs of students. Ensuring that students are challenged academically to the highest level. Communication to '
+'parents the need for a student to have a strong educational foundation. Targeted students generally demonstrating '
+'more than annual growth in literacy and mathematics. Developing systems of interventions to ensure that students '
+'needs are met. Personalizing educational experience for students. Monitor and adjust students experiences as needed. '
+'Ensure that all students/parents/community members  feel comfortable at school.</li><li><b>Exemplary:</b>&nbsp;-&nbsp;'
+'Majority of targeted students demonstrate more than annual growth in literacy and mathematics. Engage community '
+'to provide equity and access for all students. Actively pursue resources that will address student needs. Creates '
+'opportunities for stakeholders to become actively involved in the school community.</li></ul>'
WHERE RubricRowID = 1072


UPDATE seRubricRow SET DESCRIPTION =
'<ul><li><b>Proficient:</b> The purpose is clearly communicated and focuses on what the student is to learn. Purpose is '
+'communicated throughout the lesson. Activities and purpose are clearly related.' 
+'</li><li><b>Exemplary:</b> Purpose is communicated in more than one form.  Purpose is clearly understood by students.'
WHERE RubricRowID = 1029
*/
--end 1385 patches    **From now on, this number of the _prototypes sub project*********

/**********begin patches to dbcreate 1586 ****************************************************************************/
/*
DECLARE @danState BIGINT, @danIFW BIGINT, @celState BIGINT, @celIFW BIGINT, @marState BIGINT, @marIFW bigint
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Dan, StateView', 'BDAN',2013, 1, 1, 1, NULL, 0, 1)
SELECT @danState = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Dan, IFW View',  'BDAN' ,2013, 2, 1, 1, NULL, 0, 1)
SELECT @danIFW = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('CEL, StateView', 'BCEL',2013, 1, 3, 1, NULL, 0, 1)
SELECT @celState = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('CEL, IFW View',  'BCEL' ,2013, 2, 3, 1, NULL, 0, 1)
SELECT @celIFW = SCOPE_IDENTITY()


INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @danState, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =1 AND fwcode = 'ste'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @danIFW, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =2 AND fwcode = 'dan'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @celState, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =1 AND fwcode = 'ste'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @celIFW, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =2 AND fwcode = 'cel'

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BDAN','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bDanx

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BCEL','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bCEL

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, bdx.Sequence FROM seFrameworkNode fn
JOIN stateeval_prepro.dbo.bdanx bdx ON bdx.criteria = fn.title
JOIN seRubricRow rr ON rr.title = bdx.RowTitle
WHERE fn.FrameworkID = @danState AND rr.BelongsToDistrict = 'bdan'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 1,2)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = CONVERT(VARCHAR(5), bfn.idx)
WHERE fn.FrameworkID = @danIFW AND bfn.fwcode = 'dan' AND rr.BelongsToDistrict = 'bdan' 
 ORDER BY SUBSTRING(rr.title, 1,2)
 
 


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, bdx.sequence
FROM seFrameworkNode fn
JOIN stateeval_prepro.dbo.bcel bdx ON bdx.critshortname = fn.ShortName
JOIN seRubricRow rr ON bdx.RowTitle = rr.title
WHERE fn.frameworkID = @celState


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT  fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 2, 1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = CONVERT(VARCHAR(5), bfn.idx)
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'p_:%'


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 3,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 2) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'se_:%'




INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 3,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 2) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND rr.title LIKE 'cp_:%' AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' 



INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 2,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'a_:%'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 4,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 3) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'cec_:%'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 4,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 3) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'pcc_:%'




insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')
*/
/**********End patches to 1586 ****************************************************************************/
/**********begin patches to dbcreate 1680 ****************************************************************************/
--minor edits to bCEL
--bMarzano


--cel edits
/*
update seRubricRow set title = 'P1    Purpose – Standards: Connection to standards, broader purpose and transferable skill'                                                                              where RubricRowID = 1095
update seRubricRow set title = 'P4    Purpose – Learning Target: Communication of learning target(s) '                                                                                                   where RubricRowID = 1096
update seRubricRow set title = 'P5    Purpose – Learning Target: Success criteria and performance task(s)'                                                                                               where RubricRowID = 1097
update seRubricRow set title = 'SE3    Student Engagement – Engagement Strategies: High cognitive demand'                                                                                                where RubricRowID = 1098
update seRubricRow set title = 'CEC3    Classroom Environment & Culture – Classroom Routines & Rituals: Discussion, collaboration and accountability'                                                    where RubricRowID = 1099
update seRubricRow set title = 'SE1    Student Engagement – Intellectual Work: Quality of questioning'                                                                                                   where RubricRowID = 1100
update seRubricRow set title = 'SE5    Student Engagement – Engagement Strategies: Expectation, support and opportunity for participation and meaning making'                                            where RubricRowID = 1101
update seRubricRow set title = 'SE6    Student Engagement – Talk: Substance of student talk'                                                                                                             where RubricRowID = 1102
update seRubricRow set title = 'CP6    Curriculum & Pedagogy – Scaffolds for Learning: Scaffolds the task'                                                                                               where RubricRowID = 1103
update seRubricRow set title = 'CP7    Curriculum & Pedagogy – Scaffolds for Learning: Gradual release of responsibility'                                                                                where RubricRowID = 1104
update seRubricRow set title = 'P3    Purpose – Teaching Point: Teaching point(s) are based on students’ learning needs'                                                                                 where RubricRowID = 1105
update seRubricRow set title = 'SE2    Student Engagement – Intellectual Work: Ownership of learning'                                                                                                    where RubricRowID = 1106
update seRubricRow set title = 'SE4    Student Engagement – Engagement Strategies: Strategies that capitalize on learning needs of students'                                                             where RubricRowID = 1107
update seRubricRow set title = 'CP5    Curriculum & Pedagogy – Teaching Approaches and/or Strategies: Differentiated instruction'                                                                        where RubricRowID = 1108
update seRubricRow set title = 'A6    Assessment for Student Learning – Adjustments: Teacher use of formative assessment data'                                                                           where RubricRowID = 1109
update seRubricRow set title = 'P2    Purpose – Standards: Connection to previous and future lessons'                                                                                                    where RubricRowID = 1110
update seRubricRow set title = 'CP1    Curriculum & Pedagogy – : Alignment of instructional materials and tasks'                                                                                         where RubricRowID = 1111
update seRubricRow set title = 'CP2    Curriculum & Pedagogy – Teaching Approaches and/or Strategies: Discipline-specific conceptual understanding'                                                      where RubricRowID = 1112
update seRubricRow set title = 'CP3    Curriculum & Pedagogy – Teaching Approaches and/or Strategies: Pedagogical content knowledge'                                                                     where RubricRowID = 1113
update seRubricRow set title = 'CP4    Curriculum & Pedagogy – Teaching Approaches and/or Strategies: Teacher knowledge of content'                                                                      where RubricRowID = 1114
update seRubricRow set title = 'CEC1    Classroom Environment & Culture – Use of Physical Environment: Arrangement of classroom'                                                                         where RubricRowID = 1115
update seRubricRow set title = 'CEC2    Classroom Environment & Culture – Use of Physical Environment: Accessibility and use of materials'                                                               where RubricRowID = 1116
update seRubricRow set title = 'CEC4    Classroom Environment & Culture – Classroom Routines & Rituals: Use of learning time '                                                                           where RubricRowID = 1117
update seRubricRow set title = 'CEC5    Classroom Environment & Culture – Classroom Routines & Rituals: Managing student behavior'                                                                       where RubricRowID = 1118
update seRubricRow set title = 'CEC6    Classroom Environment & Culture – Classroom Culture: Student status'                                                                                             where RubricRowID = 1119
update seRubricRow set title = 'CEC7    Classroom Environment & Culture – Classroom Culture: Norms for learning'                                                                                         where RubricRowID = 1120
update seRubricRow set title = 'A1    Assessment for Student Learning – Assessment: Self-assessment of learning connected to the success criteria'                                                       where RubricRowID = 1121
update seRubricRow set title = 'A2    Assessment for Student Learning – Assessment: Demonstration of learning'                                                                                           where RubricRowID = 1122
update seRubricRow set title = 'A3    Assessment for Student Learning – Assessment: Formative assessment opportunities'                                                                                  where RubricRowID = 1123
update seRubricRow set title = 'A4    Assessment for Student Learning – Assessment: Collection systems for formative assessment data'                                                                    where RubricRowID = 1124
update seRubricRow set title = 'A5    Assessment for Student Learning – Assessment: Student use of assessment data'                                                                                      where RubricRowID = 1125
update seRubricRow set title = 'PCC3    Professional Collaboration & Communication – Communication and Collaboration: Parents and guardians'                                                             where RubricRowID = 1126
update seRubricRow set title = 'PCC4    Professional Collaboration & Communication – Communication and Collaboration: Communication within the school '                                                  where RubricRowID = 1127
update seRubricRow set title = 'PCC1    Professional Collaboration & Communication – Professional Learning and Collaboration: Collaboration with peers and administrators to improve student learning'   where RubricRowID = 1128
update seRubricRow set title = 'PCC2    Professional Collaboration & Communication – Professional Learning and Collaboration: Professional and collegial relationships'                                  where RubricRowID = 1129
update seRubricRow set title = 'PCC5    Professional Collaboration & Communication – Professional Responsibilities: Supports school, district, and state curriculum, policy and initiatives'             where RubricRowID = 1130
update seRubricRow set title = 'PCC6    Professional Collaboration & Communication – Professional Responsibilities: Ethics and advocacy'                                                                 where RubricRowID = 1131


--bMar
DECLARE @marstate BIGINT
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Mar, StateView', 'BMAR',2013, 1, 5, 1, NULL, 0, 1)
SELECT @marState = SCOPE_IDENTITY()


INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @marstate, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =1 AND fwcode = 'ste'



INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BMZSV','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bMar



INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, bmar.sequence
FROM seFrameworkNode fn
JOIN stateeval_prepro.dbo.bmar bmar ON bmar.critshortname = fn.ShortName
JOIN seRubricRow rr ON bmar.RowTitle = rr.title
WHERE fn.frameworkID = @marState


insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@marState,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@marState,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@marState,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@marState,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')
*/
/**********End patches to 1680 ****************************************************************************/
/**********begin patches to 1745 ****************************************************************************/
--problem with shortnames in last danielson, state frameworks
/*
UPDATE seFrameworkNode SET shortname = RTRIM(shortname) WHERE shortname LIKE '% '
UPDATE seFrameworkNode SET shortname = 'D' + shortname WHERE shortname IN ('1','2','3','4')
*/
/**********End patches to 1745 ****************************************************************************/

/**********begin patches to 1792 ****************************************************************************/
/*
--result of dave morrison's check...
UPDATE seRubricRow SET pl1descriptor = '<p>The instructional purpose of the lesson is unclear to students, and the '
+'directions and procedures are confusing.</p><p> The teacher’s explanation of the content contains major errors. </p>'
+'<p> The teacher’s spoken or written language contains errors of grammar or syntax.</p> The teacher’s vocabulary is '
+'inappropriate, vague, or used incorrectly, leaving students confused.'

WHERE BelongsToDistrict = 'bdan' AND title LIKE '3a%'

UPDATE seRubricRow SET pl4descriptor = '<p>The classroom is safe, and learning is accessible to all students, including '
+'those with special needs. </p><p>Teacher makes effective use of physical resources, including computer technology. The '
+'teacher ensures that the physical arrangement is appropriate to the learning activities. </p> Students contribute to '
+'the use or adaptation of the physical environment to advance learning.'
  WHERE BelongsToDistrict = 'bdan' AND title LIKE '2e%'

UPDATE dbo.SERubricRow SET pl2descriptor = 'Teacher states the learning target(s) at the beginning of each lesson.'
WHERE BelongsToDistrict = 'bcel' AND title LIKE 'p4%'
 


UPDATE seRubricRow SET pl1descriptor = 'The lesson is rarely or never linked to previous and future lessons.'
, pl2descriptor = 'The lesson is clearly linked to previous and future lessons.'
, pl3descriptor = 'Lessons build on each other in a logical progression.'
, pl4descriptor = 'The lesson is clearly linked to previous and future lessons. Lessons build on each'
+'other in ways that enhance student learning. Students understand how the lesson relates to previous lesson.'
WHERE BelongsToDistrict = 'bcel' AND title LIKE 'p2%'

UPDATE seRubricRow SET title ='CP1    Curriculum & Pedagogy – Curriculum: Alignment of instructional materials and tasks'
WHERE BelongsToDistrict = 'bcel' AND title LIKE 'cp1%'

update dbo.seRubricRow set pl1Descriptor = 'Instruction is rarely or never consistent with pedagogical content knowledge and does not support students in discipline-specific habits of thinking.'	
,pl2Descriptor = 'Instruction is occasionally consistent with pedagogical content knoweldge and supports students in discipline-specific habits of thinking.' 
,pl3Descriptor = 'Instruction is frequently consistent with pedagogical content jnwoeldge and supports students in discipline-specific habits of thinking.'	
,pl4Descriptor = 'Instruction is always consistent with pedagogical content knowledge and supports students in discipline-specific habits of thinking.' 
WHERE title LIKE 'cp3%' AND belongsToDistrict ='bcel'


update dbo.seRubricRow set pl1Descriptor = 
'Teacher does not develop appropriate and positive teacher-student relationships that attend to students’ well-being. Patterns of '
+'interaction or lack of interaction promote rivalry and/or unhealthy competition among students or some students are relegated '
+'to low status positions.'	
WHERE title LIKE 'cec6%' AND belongsToDistrict ='bcel'

update dbo.seRubricRow set pl1Descriptor = 
'Students are rarely or never given an opportunity to assess their own learning in relation to the success criteria for the learning target.'
WHERE title LIKE 'a1%' AND belongsToDistrict ='bcel'


update dbo.seRubricRow set title = 
'PCC4    Professional Collaboration & Communication – Communication and Collaboration: Communication within the school community about student progress'
WHERE title LIKE 'PCC4%' AND belongsToDistrict ='bcel'

update dbo.seRubricRow set PL3Descriptor = 
'Teacher develops and sustains professional and collegial relationships for the purpose of student, staff or district growth.'
WHERE title LIKE 'PCC2%' AND belongsToDistrict ='bcel'


--SELECT * FROM dbo.SERubricRow
UPDATE dbo.seRubricrow SET pl2Descriptor=
'The teacher identifies interventions that meet the needs of specific sub-populations (e.g., ELL, special education, and students'
+' who come from environments that offer little support for learning), but does not ensure that all identified students are'
+' adequately served by the interventions'
WHERE belongsToDistrict ='bmar' AND title LIKE '3.2%'

--SELECT * FROM dbo.SERubricRow
UPDATE dbo.seRubricrow SET pl2Descriptor=
'The teacher develops a written professional growth and development plan but does not articulate clear goals and timelines. '
+'The teacher charts his or her progress on the professional growth and development plan using established goals and timelines but does '
+'not make adaptations as needed.'
WHERE belongsToDistrict ='bmar' AND title LIKE '8.4%'


UPDATE dbo.SERubricRowFrameworkNode SET sequence = rubricRowID - 1158
WHERE rubricrowID IN (1159, 1160, 1161, 1162)


UPDATE dbo.SERubricRowFrameworkNode SET sequence = rubricRowID - 1147
WHERE rubricrowID IN (1148,1149,1150,1151,1152,1153)
*/

/**********End patches to 1792 ****************************************************************************/
/**********Begin patches to 1835 ****************************************************************************/
--blessed 'leadership' framework

/*
DECLARE @prinstate BIGINT
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('PRIN, StateView', 'BPRIN',2013, 3, 5, 1, NULL, 0, 1)
SELECT @prinstate = SCOPE_IDENTITY()

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT DISTINCT @prinState, NULL, [Criteria], CritShortName, '', CONVERT(INT, SUBSTRING(critshortname,2, 1)), 0 
FROM stateeval_prePro.dbo.bPrin  ORDER BY critshortname

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BPRIN','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bPrin

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, r.RubricRowID, x.Sequence FROM dbo.SEFrameworkNode fn
JOIN StateEval_PrePro.dbo.bPrin x ON x.critShortName = fn.ShortName
JOIN seRubricRow r ON r.title = x.rowtitle
WHERE fn.FrameworkID = @prinState


insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@prinState,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@prinState,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@prinState,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@prinState,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

*/

/**********End patches to 1835 ****************************************************************************/
/**********Begin patches to 2026 ****************************************************************************/
/*
--bug 2837
UPDATE seframeworkPerformanceLevel SET fullname = RTRIM(fullname)

*/
/**********end patches to 2026 ****************************************************************************/
/**********begin patches to 2055 ****************************************************************************/
--this is just a log entry; the patch was trivial.  To fix bug 2839, 
--something like 
--'update SEFrameWorkPerformanceLevel set description = replace (description, '  ', ' ') where description like '%  %'
/**********end patches to 2055 ****************************************************************************/

/**********begin patches to 2150 ****************************************************************************/
--Wenatchee Principal Rubric 
/*
DECLARE @wenPrin BIGINT
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Wenatchee PR', 'prWEN',2013, 3, 5, 1, NULL, 0, 1)
SELECT @wenPrin = SCOPE_IDENTITY()

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT DISTINCT @wenPrin, NULL, [Criteria], CritShortName, description, CONVERT(INT, SUBSTRING(critshortname,2, 1)), 0 
FROM stateeval_prePro.dbo.WenPrinCrit  ORDER BY critshortname

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'prWen','', p1, p2, p3, p4 FROM StateEval_PrePro.dbo.WenPrinRR

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, r.RubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 3,1)) FROM dbo.SEFrameworkNode fn
JOIN StateEval_PrePro.dbo.WenPrinRR x ON x.critShortName = fn.ShortName
JOIN seRubricRow r ON r.title = x.rowtitle
WHERE fn.FrameworkID = @wenPrin


insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@wenPrin,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@wenPrin,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@wenPrin,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@wenPrin,   4,'DIS',LTRIM('Distinguished '),'Consistently exceeds expected levels of performance')
*/
/**********end patches to 2150 ****************************************************************************/
/******************begin patches to 2192*********************/
--update descriptions for the wenatchee principal rubrics
/*
update seRubricRow set description = 'CIPP Plan; CIPP Supportive Review; 9 Characteristics Survey; Collaboration Minutes; Staff Meeting Minutes; Student Study; Team Minutes; LIT Minutes; Use of Formative Assessments; Building CIPP Review Calendar '   where belongsToDistrict = 'prWen' and Title = rtrim('1.1 Continuous Improvement                                                                                                                                                             ')
update seRubricRow set description = '9 Characteristics Survey; Meeting Minutes; CIPP Plan; Grievances; PLC Professional Development;  Decision-making protocols; Norms & Collective Commitments '                                                         where belongsToDistrict = 'prWen' and Title = rtrim('1.2 Trusting and collaborative environment                                                                                                                                             ')
update seRubricRow set description = '9 Characteristics Survey; Observations; Artifacts – Mission/Vision Meeting; agendas/minutes; Processes for developing/reviewing, mission/vision; School communications '                                             where belongsToDistrict = 'prWen' and Title = rtrim('1.3 Mission and vision focused on learning and teaching                                                                                                                                ')
update seRubricRow set description = 'Observation-Collaboration; CIPP Supportive Review; Data Reports; Budget reports; CIPP Plan; PRTI; 9 Characteristics; Staff assignment; LIT Agendas/Minutes '                                                         where belongsToDistrict = 'prWen' and Title = rtrim('1.4 Promoting data driven decision making                                                                                                                                              ')
update seRubricRow set description = 'Student Handbook; Observation; MYD Self-Assessments; Training agendas/Sign-ins; 9 Characteristics Survey '                                                                                                           where belongsToDistrict = 'prWen' and Title = rtrim('2.1 Building and classroom discipline                                                                                                                                                  ')
update seRubricRow set description = 'Safety Committee Agendas/Minutes '                                                                                                                                                                                   where belongsToDistrict = 'prWen' and Title = rtrim('2.2 Maintains a safe and clean physical plant                                                                                                                                          ')
update seRubricRow set description = 'Safety Drill Summary; Crisis Action Plan '                                                                                                                                                                           where belongsToDistrict = 'prWen' and Title = rtrim('2.3 Crisis Action Plan                                                                                                                                                                 ')
update seRubricRow set description = 'Training Agendas/Sign Ins; Safety Bulletin Boards; Confirmation of online trainings '                                                                                                                                where belongsToDistrict = 'prWen' and Title = rtrim('2.4 Prevention and training                                                                                                                                                            ')
update seRubricRow set description = 'CIPP Plan; Data Reports; SMART Goal Samples; Observations/Collaboration; LIT/Dept. Heads; Agendas/Minutes '                                                                                                          where belongsToDistrict = 'prWen' and Title = rtrim('3.1 Collaboratively develops a school improvement plan based on data                                                                                                                   ')
update seRubricRow set description = 'CIPP Supportive Review; Data Reports; 1 on 1 Reflections; Agendas/Minutes; CIPP formal review plan '                                                                                                                 where belongsToDistrict = 'prWen' and Title = rtrim('3.2 Monitors implementation and effectiveness of the school improvement plan                                                                                                           ')
update seRubricRow set description = 'CIPP Plans (Staff plans to Building plans to District Initiatives); LIT Agendas '                                                                                                                                    where belongsToDistrict = 'prWen' and Title = rtrim('3.3 Ensures alignment of the school improvement plan                                                                                                                                   ')
update seRubricRow set description = 'Professional Development Calendar; CIPP Plans; Observations; 9 Characteristics '                                                                                                                                     where belongsToDistrict = 'prWen' and Title = rtrim('3.4 Supports implementation of the school improvement plan                                                                                                                             ')
update seRubricRow set description = 'Reflection; Agendas; Trainings aligned to initiatives; Observation Notes; Collaboration Agendas & Minutes '                                                                                                          where belongsToDistrict = 'prWen' and Title = rtrim('4.1 Focus on state and district standards                                                                                                                                              ')
update seRubricRow set description = 'Professional Development Calendar; Sign-Ins; CIPP Plans; Self-Reflection/Assessment '                                                                                                                                where belongsToDistrict = 'prWen' and Title = rtrim('4.2 Supports staff through professional development focused on state, district, and building learning goals                                                                            ')
update seRubricRow set description = 'Teacher work samples; Observations of collaboration; Training Agendas; Data Reports PRTI Model '                                                                                                                     where belongsToDistrict = 'prWen' and Title = rtrim('4.3 Focus on the implementation of formative and summative assessments                                                                                                                 ')
update seRubricRow set description = 'PLC Artifacts; Observations of collaboration; Participation/Presentation; Leadership Academy; Agendas/Minutes; Reflection '                                                                                          where belongsToDistrict = 'prWen' and Title = rtrim('4.4 Supports staff collaboration that focuses on effective instruction, use of data, and common planning                                                                               ')
update seRubricRow set description = 'Professional Development Calendar; Training/Staff meeting Agendas; Data Reports Needs; Assessment; Observation Notes; Assessment data entry reports; Collaboration notes; Teacher planning documents '               where belongsToDistrict = 'prWen' and Title = rtrim('5.1 Promotes and monitors use of adopted curriculum                                                                                                                                    ')
update seRubricRow set description = 'Observation; Notes 1 on 1 Self Reflection; Self-Assessment; Observation/Accountability System '                                                                                                                      where belongsToDistrict = 'prWen' and Title = rtrim('5.2 Uses a variety of methods for gathering observational data                                                                                                                         ')
update seRubricRow set description = 'Artifacts; Observation; Data gathering forms; Feedback forms; Intervention summaries; Professional development; Collaboration minutes; Data analysis protocols   '                                                   where belongsToDistrict = 'prWen' and Title = rtrim('5.3 Uses a variety of data to monitor and assist instructional practice                                                                                                                ')
update seRubricRow set description = 'Observation Data; Data Reports; Teacher work Samples '                                                                                                                                                               where belongsToDistrict = 'prWen' and Title = rtrim('5.4 Uses the District evaluation process to provide staff with assistance and feedback to improve instruction                                                                          ')
update seRubricRow set description = 'HR Feedback; Self-Reflection; 1 on 1 Questions; Collaborative hiring practice; Evidence of hiring practices; Master schedule; Intervention schedule  '                                                               where belongsToDistrict = 'prWen' and Title = rtrim('6.1 Effectively manages Human Resources                                                                                                                                                ')
update seRubricRow set description = 'School Budget; Overview of budgeting process and expenditures; LIT Minutes; Self-Reflection; CIPP plans and supportive reviews; Grants '                                                                             where belongsToDistrict = 'prWen' and Title = rtrim('6.2 Effectively manages school budget                                                                                                                                                  ')
update seRubricRow set description = 'Bus/Fin Feedback; HR Feedback; Student Services Feedback; Artifacts; 9 Characteristics Survey '                                                                                                                      where belongsToDistrict = 'prWen' and Title = rtrim('6.3 Legal and Ethical Practice                                                                                                                                                         ')
update seRubricRow set description = 'Artifacts; Newsletters; Website; 9 Characteristics Survey; Parent Education Efforts Sample; Communication Methods '                                                                                                  where belongsToDistrict = 'prWen' and Title = rtrim('7.1   Frequent and effective communication with parents and community                                                                                                                  ')
update seRubricRow set description = 'Attendance & participation at District Meetings; Participation on District Level Committees; Sharing Best Practices; Mentoring '                                                                                     where belongsToDistrict = 'prWen' and Title = rtrim('7.2   Builds positive and collaborative relationships with colleagues                                                                                                                  ')
update seRubricRow set description = '9 Characteristics Survey; LIT Agendas/Minutes; Staff Meeting Agendas/Minutes; Building Decision-making Protocols; Self-Reflection/Assessment '                                                                       where belongsToDistrict = 'prWen' and Title = rtrim('7.3   Understands community dynamics and considers stakeholder input when making decisions                                                                                             ')
update seRubricRow set description = 'Volunteer Sign Ups; Activity Log; PTO/PTSA Minutes; Parent Education Strategies; Participation in Community Organizations '                                                                                          where belongsToDistrict = 'prWen' and Title = rtrim('7.4   Promotes parent and community involvement                                                                                                                                        ')
update seRubricRow set description = 'PRTI Building Model; Data Reports; Master Schedule; Intervention placement process/criteria '                                                                                                                        where belongsToDistrict = 'prWen' and Title = rtrim('8.1 Uses data to align resources and programs in closing the achievement gap                                                                                                           ')
update seRubricRow set description = 'CIPP Plan; Professional Development Calendar; Self-Reflection; Activity Log; PRTI Model; Teacher Work Samples; Master Schedule; Student Monitoring Processes '                                                       where belongsToDistrict = 'prWen' and Title = rtrim('8.2 Recognizes and responds to factors that contribute to the achievement gap                                                                                                          ')
update seRubricRow set description = 'Data Reports'                                                                                                                                                                                                        where belongsToDistrict = 'prWen' and Title = rtrim('8.3 Student Growth Data                                                                                                                                                                ')


--new awsp prin rubrics

DECLARE @prinstate BIGINT
SELECT @prinState = 39

CREATE TABLE #nodes (nodeId BIGINT)
INSERT #nodes (nodeID)
SELECT frameworkNodeID FROM seFrameworkNode WHERE frameworkID = 39

DELETE dbo.SERubricRowFrameworkNode WHERE FrameworkNodeID IN (SELECT nodeID FROM #nodes)
DELETE dbo.SERubricRow WHERE belongsToDistrict = 'bprin'

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BPRIN','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bPrin

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, r.RubricRowID, x.Sequence FROM dbo.SEFrameworkNode fn

--SELECT fn.shortName, r.Title FROM dbo.seFrameworkNode fn
JOIN StateEval_PrePro.dbo.bPrin x ON x.critShortName = fn.ShortName
JOIN seRubricRow r ON r.title = x.rowtitle
WHERE fn.FrameworkID = 39 
AND belongsTodistrict = 'bprin'
ORDER BY fn.ShortName

*/
/******************end patches to 2192*********************/
/******************begin patches to 2245*********************/
/*

this is a comment only.  Refer to bug 2944

anne found truncated performance level descriptors in the AWSP rubric.
The problem was traced to a bad access load (this was one of them where the 
excel wouldn't import directly into sql, and so had to take a side trip through
access.

Patched in the corrected rubric rows directly from the xcel spreadsheet that 
came from tammy le.  basically wrote:

update seRubricrow set Pl[N]Descriptor = 'blah' where belongsToDistrict='bprin' and title = 'blacht'
 for each n=1,2,3,4
 
In addition to this, got ride of the string 'Criteria X:' in the wenatchee principal criteria titles.



*/
/******************end patches to 2245*********************/
/******************begin patches to 2282*********************/
--scratch the last comment about patches to 2245.  here, i have
-- to revert to the 2245 version dbcreate, (i lost the patches somehow)
-- so, I might as well do this right... forthwith are the modifications
/*
update seRubricRow set pl1descriptor = rtrim('Does not communicate mission, vision, and core values; tolerates behaviors and school activities in opposition to a culture of ongoing improvement                                                                                                                                                                                                                          ') where title like '1.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Avoids conversations; does not make time for conversations; is not available to staff, students, other stakeholders, does not communicate high expectations and high standards for staff and students regarding ongoing improvement                                                                                                                                         ') where title like '1.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not actively support or facilitate collaboration among staff; tolerates behaviors that impede collaboration among staff; fosters a climate of competition and supports unhealthy interactions among staff                                                                                                                                                              ') where title like '1.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Offers no model or opportunity for shared leadership (ie. delegation, internship, etc.); makes decisions unilaterally                                                                                                                                                                                                                                                       ') where title like '1.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Neglects to consider the physical safety of students and staff; does not maintain and/or implement a current school safety plan; plan in place is insufficient to ensure physical safety of students and staff; major safety and health concerns                                                                                                                            ') where title like '2.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Neglects the social, emotional or intellectual safety of students and staff; does not have an anti-bullying policy or behavior plan in place that promotes emotional safety; does not model an appreciation for diversity of ideas and opinions                                                                                                                             ') where title like '2.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not recognize multiple sources or quality of data or has a limited understanding of the power and meaning of data                                                                                                                                                                                                                                                      ') where title like '3.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Reviews and shares limited school-level data only as required; interpretation of data may be incorrect or incomplete; uses data in ways unintended by assessment purpose                                                                                                                                                                                                    ') where title like '3.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Plan is limited, not data driven and/or not aligned with the needs of the school; little stakeholder involvement and commitment                                                                                                                                                                                                                                             ') where title like '3.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not assist staff to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction, and to determine whether re-teaching, practice or moving forward is appropriate; focuses more on student characteristics rather than the actions of teachers; no improvement in student academic achievement') where title like '3.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Has incomplete or insufficient knowledge of state and local district learning goals across grades and content areas; has insufficient knowledge to evaluate curricula; does not effectively assist staff to align curricula to state and district learning goals                                                                                                            ') where title like '4.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Has incomplete or insufficient knowledge of best instructional practices across grades level and content areas; does not effectively assist staff to align instructional practices to state and district learning goals                                                                                                                                                     ') where title like '4.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Has incomplete or insufficient knowledge of assessment in terms of reliability, validity and fairness; does not effectively assist staff to align assessments to instructional practices                                                                                                                                                                                    ') where title like '4.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not adequately monitor instruction and assessment practices of staff; untimely and irregular evaluations; provides insufficient feedback to staff regarding instruction and assessment practices                                                                                                                                                                       ') where title like '5.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not meet with faculty members to develop, review and modify student growth plans; student growth plans do not meet minimum requirements; does not assist staff in the identification of performance indicators or performance indicators are not sufficient; assessment results of selected teachers show little to no academic growth of students                     ') where title like '5.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not fully support staff in their efforts to improve teaching and assessment; does not have knowledge or understanding of best instruction and assessment practices; does not make assisting staff in improved teaching and assessment a priority                                                                                                                       ') where title like '5.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Evaluations lack  strong evidence yielding potentially unreliable staff evaluations; makes claims about staff performance that are not valid; does not establish systems or routines that support improved instruction and assessment practices; little to no understanding of student diversity and its meaning in instruction and assessment                              ') where title like '5.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not adequately address issues in hiring, retention ,and placement of staff for the benefit of students in classrooms; does not put student needs at the forefront of human resource decisions; does not make an effort to ensure quality personnel in each position                                                                                                    ') where title like '6.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Staff receive inadequate  opportunities for professional development to meet students’ and staffs’ needs;  professional development offered is not of sufficient quality to be effective                                                                                                                                                                                    ') where title like '6.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not make fiscal decisions that maximize resources in support of improved teaching and learning; provides little or no evidence of lists of milestones or deadlines in managing time or fiscal resources; does not work with teachers to establish goals for student achievement linked to individual teacher professional development                                  ') where title like '6.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Fails to demonstrate adequate knowledge of legal responsibilities; entertains behaviors and policies that conflict with the vision of improved teaching and learning or with law; tolerates behavior from self, staff and/or students that is not legal                                                                                                                     ') where title like '6.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Communication is sparse and opportunities for community involvement are not fully realized or made available; not visible in community or perceived as community advocate                                                                                                                                                                                                   ') where title like '7.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Demonstrates little effort to engage families or the community in school activities; fails to share the vision of improved teaching and learning beyond school; does not identify and utilize community resources in support of improved student learning                                                                                                                   ') where title like '7.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Is unaware of achievement gaps that exist in school population and how the school and teachers have  played a role in perpetuating gaps; attributes gaps to factors outside of the school''s locus of control; opportunities to learn and resources are not distributed equitably among students                                                                             ') where title like '8.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Does not acknowledge the responsibility of school to close gaps; does not consider subpopulations when constructing school learning goals and targets; does not have a plan to close gaps                                                                                                                                                                                   ') where title like '8.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl1descriptor = rtrim('Achievement data  from multiple sources or data points show no evidence of student growth toward the district’s learning goals; there are growing achievement gaps between student subgroups                                                                                                                                                                                ') where title like '8.3%' and belongsToDistrict = 'bprin'


update seRubricRow set pl2descriptor = rtrim('Vision and mission are   developing; connections between school activities, behaviors and the vision are made explicit; vision and mission are shared and supported by stakeholders                                                                                                                                                                                                                                                         ') where title like '1.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Communication reflects essential issues with  members of the school community; supports a feedback loop that reaches  students and staff; barriers to improvement are  identified and addressed; conversations are mostly   data-driven for the purposes of assessing improvement with infrequent high expectations for  students                                                                                                           ') where title like '1.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Demonstrates some understanding of the value of collaboration and what it takes to support it (i.e. building trust); facilitates collaboration among staff for certain purposes; emerging  consensus-building and negotiation skills                                                                                                                                                                                                        ') where title like '1.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Offers opportunities for staff and students to be in leadership roles;  engages processes for shared decision-making; uses  strategies to develop the capacity for shared leadership (ie. delegation, internship, etc.)                                                                                                                                                                                                                     ') where title like '1.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Maintains and implements a school safety plan  monitored on a regular basis;  minor safety and sanitary concerns in school plant or equipment; problems  are confronted  and resolved in a timely manner; eager to improve  knowledge about school security and issues relating to school facilities; an emergency operations plan is reviewed by appropriate external officials and posted in classrooms, meeting areas and office settings') where title like '2.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Strives to provide appropriate emotional support to staff and students; policies clearly define acceptable behavior; demonstrates acceptance for diversity of ideas and opinions; anti-bullying prevention program in place.                                                                                                                                                                                                                ') where title like '2.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Seeks multiple sources of data to guide decision making; emerging  knowledge of what constitutes valid and reliable sources of data and data integrity                                                                                                                                                                                                                                                                                      ') where title like '3.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Uses numerous  data analysis methods and eager to broaden  knowledge of data analysis and interpretation;  uses school-level data to inform improvement across eight Criteria                                                                                                                                                                                                                                                               ') where title like '3.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Plan is monitored, evaluated and revised resulting in data driven changes; works to build stakeholder involvement and commitment; models data-driven conversations in support of plan                                                                                                                                                                                                                                                       ') where title like '3.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Occasionally assists staff to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction, and to determine whether re-teaching, practice or moving forward is appropriate; strategies result in incomplete relationship between the actions of teachers and the impact on student achievement; minimum improvement in student academic growth                    ') where title like '3.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Has emerging knowledge and understanding of state and local district learning goals across grades and content areas to facilitate some alignment activities with staff                                                                                                                                                                                                                                                                      ') where title like '4.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Has sufficient  knowledge and understanding of best instructional practices across grades levels and content areas to facilitate some alignment activities with staff; emerging knowledge of culturally-relevant teaching & learning methodologies                                                                                                                                                                                          ') where title like '4.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Has emerging knowledge and understanding of assessment in terms of reliability, validity and fairness; facilitates the  implementation of  certain aspects of a balanced (diagnostic, formative and summative) assessment system; facilitates the alignment  of assessment to best instructional practices in some grade levels                                                                                                             ') where title like '4.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Develops and uses observable systems and routines for monitoring instruction and assessment practices; provides some effective feedback to staff; feedback is  linked back to instruction and assessment; partly  familiar with evaluating technology-rich instruction                                                                                                                                                                      ') where title like '5.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Meets minimum teachers’ contract requirements to develop, review and modify student growth plans (individual or group plans) based on identified areas of need; assists identification of  performance indicators  to monitor and benchmark progress; assessment results of selected teachers show minimum academic growth of students                                                                                                      ') where title like '5.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Facilitates staff in the implementation of effective instruction and balanced assessment systems assessments; emerging knowledge of applied learning theories to create a personalized and motivated learning environment                                                                                                                                                                                                                   ') where title like '5.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Regularly and systematically evaluates all staff yielding valid and reliable results; recommendations lead staff to some improvement in instruction and assessment practices; developing understanding of  student diversity (culture, ability, etc.) and its meaning in instruction and assessment                                                                                                                                         ') where title like '5.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Places  the needs of students at the center of some human resource decisions with moderate effect; possesses some skills and knowledge required to recruit and retain highly qualified individuals in school positions                                                                                                                                                                                                                      ') where title like '6.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Professional development plan somewhat aligns to organization’s vision and plan; PD is partly effective in leading to minor improvements in staff practice;  little or no documentation of effectiveness of  past professional development offerings and teacher outcomes                                                                                                                                                                   ') where title like '6.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Makes some fiscal decisions that maximize resources and support some aspects of improved teaching and learning; projects are managed using milestones and deadlines but not updated frequently; sometimes meets project deadlines but impact not frequently documented; frequently works with teachers to establish goals for student achievement linked to individual teacher professional development                                     ') where title like '6.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Demonstrates basic knowledge and understanding of legal responsibilities; does not entertain behaviors and policies that conflict with the vision of improved teaching and learning and with law; does not tolerate illegal behavior from self, staff and/or students                                                                                                                                                                       ') where title like '6.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Communication with the community is regular, yet is mainly informational rather than two-way; channels of communication are not accessible to all families; practices some discretion when dealing with personal information about students and staff.                                                                                                                                                                                      ') where title like '7.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Encourages and supports involvement of community and families in some school activities; shares the vision for improving teaching and learning with some families and communities; identifies and utilizes some community talent and resources in support of improved teaching and learning; limited family participation in some school decision-making processes and engagement activities                                                ') where title like '7.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Demonstrates emerging awareness of specific school-wide achievement gaps and issues of equity access; recognizes responsibility and has some confidence in teachers and school to impact these gaps; creates  new opportunities to learn                                                                                                                                                                                                    ') where title like '8.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim(' Achievement data  is accessible and shared with a portion of the school community; attempts to  target efforts towards closing achievement gaps; uses  culturally-relevant methodologies to close gaps; demonstrates  emerging  progress in closing gaps                                                                                                                                                                                   ') where title like '8.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl2descriptor = rtrim('Achievement data from multiple sources or data points shows minimum evidence of student growth toward the district’s learning goals for identified subgroups of students                                                                                                                                                                                                                                                                    ') where title like '8.3%' and belongsToDistrict = 'bprin'

update seRubricRow set pl3descriptor = rtrim('Communicates a vision of ongoing improvement in teaching and learning such that staff and students perceive and agree upon what the school is working to achieve; encourages and supports behaviors and school activities that explicitly align with vision; shares enthusiasm and optimism that the vision will be realized; regularly communicates a strong commitment  to the mission and vision of the school and holds stakeholders accountable for implementation                                                                                                                                                                ') where title like '1.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Assumes responsibility for accurate communication and productive flow of ideas among staff, students and stakeholders;  provides leadership such that the essential conversations take place and in ways that maintain trust, dignity, and ensure accountability of participants; creates and sustains productive feedback loops that include staff members and students; keeps the dialogue ongoing and purposeful; regularly communicates high expectations and standards for staff and students regarding ongoing improvement                                                                                                       ') where title like '1.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Actively models, supports, and facilitates collaborative processes among staff utilizing diversity of skills, perspectives and knowledge in the group; assumes responsibility for monitoring group dynamics and for promoting an open and constructive atmosphere for group discussions; creates opportunities for staff to initiate collaborative processes across grade levels and subject areas that support ongoing improvement of teaching and learning                                                                                                                                                                           ') where title like '1.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Provides continual opportunity and invitation for staff to develop leadership qualities; consistently engages processes that support high participation in decision-making; assesses, analyzes and anticipates emerging trends and initiatives in order to adapt shared leadership opportunities                                                                                                                                                                                                                                                                                                                                       ') where title like '1.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Implements a school safety plan that is based upon open communication systems and is effective and responsive to new threats and changing circumstances; proactively monitors and adjusts the plan in consultation with staff, students, and outside experts/consultants; staff proficiency in safety procedures as measured and monitored by group assessments followed by group reflection                                                                                                                                                                                                                                           ') where title like '2.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Assumes responsibility for the social, emotional and intellectual safety of all staff and students; supports the development, implementation, and monitoring of plans, systems, curricula, and programs that provide resources to support social, emotional and intellectual safety;  reinforces protective factors that reduce risk for all students and staff                                                                                                                                                                                                                                                                        ') where title like '2.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Systematically collects valid and reliable data from at least three sources to be used in problem solving and decision making; builds capacity of staff to recognize information as data by providing examples of using data throughout the building and in staff meetings; systematically gathers data on grades, attendance, behavior and other variables to inform efforts                                                                                                                                                                                                                                                          ') where title like '3.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Analysis includes at least three years of data including state, district, school and formal and informal classroom assessments; interprets available data at the subscale level to make informed decisions about strengths and areas of need;  provides teacher teams with previous year’s data and asks them to assess students’ current needs                                                                                                                                                                                                                                                                                        ') where title like '3.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Provides leadership such that plan is clearly articulated and includes action steps and progress monitoring strategies, and strategies in the plan are directly aligned with the data analysis process and are research based; leads ongoing review of progress and results to make timely adjustments to the plan; data insights are regularly the subject of faculty meetings and PD sessions                                                                                                                                                                                                                                        ') where title like '3.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Regularly assists staff to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction (highly achieving as well as non-proficient) and to determine whether re-teaching, practice or moving forward with instruction is appropriate at both the group and individual level; strategies result in clear relationship between the actions of teachers and the impact on student achievement; demonstrated and measureable  improvements in student academic growth readily apparent                                                                           ') where title like '3.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Every class has a curriculum based on the standards of the state and district learning goals/targets; has deep knowledge of state and district learning goals and how to align these with curricula for diverse populations; systematically focuses staff on alignment; establishes a system that uses a feedback loop from the instruction and assessment alignment work to make makes adjustments to curricula                                                                                                                                                                                                                       ') where title like '4.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Has deep knowledge of best instructional practices for diverse populations and how to align these with curricula; systematically focuses staff on alignment; establishes a system for ongoing alignment that involves  staff; continually supports, monitors alignment and makes adjustments; has teacher teams cooperatively plan aligned units, reviews them and then gives teachers feedback; reads and shares research that fosters an ongoing, school wide discussion on best practices for non-proficient to above proficient students                                                                                           ') where title like '4.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Has deep knowledge of assessment; every course has a document (syllabus, course outline or learning objectives) that identifies the learning outcomes in language accessible to students and parents; student work created in response to teachers’ assessments of the learning outcomes accurately reflect the state standards and district learning goals/targets; continually provides support to systematically focus staff on alignment of assessment to instruction using best practices; establishes a system for ongoing alignment of formative and summative assessment that involves staff members                           ') where title like '4.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Develops and uses observable systems and routines for monitoring instruction and assessment; uses data consistently to provide staff meaningful, personal feedback that is effective for improving instruction and assessment practices; ensures that teachers go beyond what students fail to learn and delve into why (root causes); deep understanding of evaluating technology-rich instruction                                                                                                                                                                                                                                    ') where title like '5.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Meets with faculty members regularly (beyond minimum teachers ‘contract)  to develop, review and modify student growth plans (individual or group plans); assists identification of performance indicators to benchmark progress; research-based planning and performance-linked goal setting strategies, such as “SMART” goals, are used allowing timely feedback to make mid-course corrections and improve teacher practice; assessment results of selected teachers show measurable and improving academic growth of students                                                                                                      ') where title like '5.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Facilitates and supports staff in the implementation of effective instruction and assessment practices; has deep and thorough knowledge and understanding of best practices in instruction and assessment; devotes considerable time and effort to the improvement of instruction and assessment; assists staff to use the most effective and appropriate technologies to support teaching and learning                                                                                                                                                                                                                                ') where title like '5.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Evaluates staff reliably and validly; provides triangulated data evidence to support claims; recommendations are effective and lead to consistently improved instruction and assessment practices; demonstrating knowledge of  student diversity (culture, ability, etc.) and its meaning in instruction and assessment                                                                                                                                                                                                                                                                                                                ') where title like '5.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Places students’ needs at the center of human resource decisions and decisions regarding hiring, retention and placement of staff; conducts a rigorous hiring process when choosing staff; focuses energy on ensuring productivity through staff placement                                                                                                                                                                                                                                                                                                                                                                             ') where title like '6.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Professional development plan has three to four areas of emphasis, job embedded, ongoing and linked to the organization’s vision and plan; systematic evaluation of the effectiveness of past PD offerings and outcomes; creates and supports informal professional development (ie. professional learning communities); offers PD that meets teachers’ needs and has elements of high-quality PD (sufficient duration, content, etc.)                                                                                                                                                                                                 ') where title like '6.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Engages others in dialogue on budget decisions based on data, School Improvement Plan, and district priorities that support learning; makes fiscal decisions that maximize resources and supports improved teaching and learning; uses defined process to track expenditures; frequently monitors data, documents and evaluates results; uses  findings to improve fiscal decisions made in the future; documented history reveals ability to manage complex projects and meet deadlines within budget; regularly works with teachers to establish goals for student achievement linked to individual teachers professional development') where title like '6.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Assumes responsibility for operating within the law; demonstrates deep and thorough knowledge and understanding of the intent of the law; operates with deep and thorough knowledge and understanding of district policies, grant requirements and collective bargaining agreements; keeps student and staff well-being at the forefront of legal responsibilities; tolerates no behavior outside of the law and approaches problems proactively                                                                                                                                                                                       ') where title like '6.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Builds effective communication systems between home, community and school that are interactive and regularly used by students, school staff and families and other stakeholders; uses multiple communication channels appropriate for cultural and language differences that exist in the community; practices a healthy discretion with personal information of students and staff                                                                                                                                                                                                                                                    ') where title like '7.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Encourages and supports consistent and ongoing community and family engagement for stakeholders in school activities; consistently implements effective plans for engaging community outside of school to participate in school decision making to improve teaching and learning; community resources are identified and utilized in support of improved teaching and learning; actively monitors community involvement and adjusts, creating new opportunities for families and community to be a part of the vision of improving teaching and learning                                                                               ') where title like '7.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Identifies learning gaps early using formative assessments; demonstrates complete knowledge and understanding of the existence of gaps; accepts responsibility for impacting these gaps; identifies and addresses barriers to closing gaps                                                                                                                                                                                                                                                                                                                                                                                             ') where title like '8.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Achievement data is accessible to all members of the school community including non-English speaking parents; constructs plan with specific strategies to impact gaps; communicates, monitors and adjust efforts to effectively make progress toward reducing gaps; models and builds the capacity of school personnel to be culturally competent and to implement socially just practices; demonstrates improvement in closing identified gaps                                                                                                                                                                                        ') where title like '8.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl3descriptor = rtrim('Achievement data from multiple sources or data points show evidence of improving student growth toward the district’s learning goals; the average achievement of the student population improved as does the achievement of each subgroup of students identified as needing improvement                                                                                                                                                                                                                                                                                                                                                ') where title like '8.3%' and belongsToDistrict = 'bprin'

update seRubricRow set pl4descriptor = rtrim('Is proficient AND provides leadership and support such that shared vision and goals are at the forefront of attention for  students and staff and at the center of their  work; communicates mission, vision, and core values to community stakeholders such that the wider community knows, understands and supports the vision of the changing world in the 21st Century that schools are preparing children to enter and succeed                                                                                                                                                                                                                                                                                                                           ') where title like '1.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND establishes and promotes successful systems and methods for communication that extend beyond the school  community; creates a productive feedback loop among  stakeholders that keeps the dialogue ongoing and purposeful;  methods are recognized and adopted for purposes beyond school; staff report confidence in their ability to engage in essential conversations for ongoing improvement; consistently communicates high expectations and standards for staff and students regarding ongoing improvement                                                                                                                                                                                                                            ') where title like '1.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND successfully creates generative systems that build the capacity of  stakeholders to collaborate across grade levels and subject areas; is recognized by school community and other stakeholders for leadership that results in a high degree of meaningful collaboration                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ') where title like '1.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND proactively cultivates leadership qualities in others; builds a sense of efficacy and empowerment among staff and students that results in increased capacity to accomplish substantial outcomes; involves staff in leadership roles that foster career development; expands opportunities for community stakeholders to engage  in shared leadership                                                                                                                                                                                                                                                                                                                                                                                       ') where title like '1.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND serves as a resource for others in leadership roles beyond school who are developing and implementing comprehensive physical safety systems to include prevention, intervention, crisis response and recovery                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ') where title like '2.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND makes emotional and intellectual safety a top priority for  staff and students; ensures a school culture in which  students and staff are acknowledged and connected; advocates for  students to be a part of and responsible for their school community; ensures that  school community members are trained and empowered to improve and sustain a culture of emotional safety; cultivates intellectual safety of  students and staff by advocating  for diversity of ideas, respecting  perspectives that arise, promoting an open exchange of ideas; involves  school community in active intellectual inquiry                                                                                                                           ') where title like '2.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND explores and uses a wide variety of monitoring and data collection strategies (both formal and informal) to triangulate data; responds to an identified need for timely data by putting new data collection processes in place to collect  reliable and valid data                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ') where title like '3.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently leads in data interpretation, analysis, and  communication;  links at least three years of student data to teachers and builds capacity of  staff to understand and use their data for improved teaching and learning; practices a high standard for data reliability, validity and fairness and keeps these concepts in the forefront of conversations with  staff                                                                                                                                                                                                                                                                                                                                                            ') where title like '3.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND creates a school culture of using data for decisions and continuous improvement in  aspects of school life; orchestrates high-quality, low-stakes action planning meetings after each round of assessments; data driven plan specifically documents examples of decisions made on the basis of data analysis and results are documented  to inform future decisions; provides coaching to other school administrators to improve their data driven plan and analysis                                                                                                                                                                                                                                                                        ') where title like '3.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND demonstrates leadership by routinely and consistently assisting teachers to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction, and to determine whether re-teaching, practice or moving forward with instruction is appropriate at both the group and individual level; explicitly demonstrates consistent and measurable improvements in student academic growth                                                                                                                                                                                                                                                                                       ') where title like '3.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND provides leadership and support such that all teachers have fully aligned curriculum materials (including high achieving) and training on how to use them; staff takes ownership of the alignment processes of goals to curricula;  staff understand alignment of curricula to state and local district learning goals as foundational to the improvement of teaching and learning; staff use feedback loop from their classroom instructional practices and assessments to suggest adjustments to curricula                                                                                                                                                                                                                                ') where title like '4.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND provides leadership and support such that staff understand alignment of best instructional practice to state and district learning goals as foundational to the improvement of teaching and learning ; staff takes ownership and backward-design high quality, aligned units to discuss with their teams; ensures that staff is current on professional literature regarding instructional practices                                                                                                                                                                                                                                                                                                                                        ') where title like '4.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND provides leadership and support such that staff takes ownership of the alignment processes of assessment to instructional practices;  staff understand the alignment of assessment to teaching as foundational to the improvement of teaching and learning                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ') where title like '4.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently demonstrates leadership  in the practice of monitoring effective instruction and assessment practices; develops exemplary systems and routines for effective observation of staff; shares systems and routines with colleagues and stakeholders; regularly monitors, reflects on and  develops or adjusts systems as needed to improve assessment practices                                                                                                                                                                                                                                                                                                                                                                    ') where title like '5.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently demonstrates leadership in the practice of developing comprehensive student growth plans; regularly meets with faculty members to reflect on student growth plans and progress; assessment results of selected teachers show consistent academic growth of students                                                                                                                                                                                                                                                                                                                                                                                                                                                            ') where title like '5.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND serves as a driving force to  build capacity for staff to initiate and implement improved instruction and assessment practices; encourages staff to conduct action research; seeks ways to extend influence of knowledge and contribute to the application of effective instruction and assessment practices                                                                                                                                                                                                                                                                                                                                                                                                                                ') where title like '5.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently demonstrates leadership in the practice of thoroughly, reliably and validly evaluating staff in such a way that continuous improvement in instruction and assessment becomes the professional standard; provides detailed, formative assessment with exemplary feedback that leads to improvement; builds capacity in staff to accurately and validly assess self and others, promoting a culture of continual improvement due to ongoing evaluation of effective instruction and assessment practices                                                                                                                                                                                                                         ') where title like '5.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND optimizes the school''s human resources and assets of staff members to maximize opportunities for student growth; is distinguished in management of human resources and is called upon to share those successful processes outside of school; efforts produce a positive work environment that attracts outstanding talent; continuously searches for staff with outstanding potential as educators and provides the best placement of both new and existing staff to fully benefits from their strengths in  meeting the needs of a diverse student population                                                                                                                                                                              ') where title like '6.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND has adopted research-based strategies for evaluating the effectiveness of PD documenting growth in teacher knowledge to student outcomes; can identify specific PD offerings of prior years that were systematically reviewed and either eliminated or modified to support organizational goals                                                                                                                                                                                                                                                                                                                                                                                                                                             ') where title like '6.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND demonstrates leadership in the design and successful enactment of uniquely creative approaches that regularly save time and money; results indicate that strategically redirected resources have positive impact in achieving priorities; guides  decision-making such that efficacy grows among stakeholders for arriving at fiscal decisions for  improvement of teaching and learning; augments resources by writing successful state and/or federal grants; seeks numerous external funding sources; consistently works with teachers to establish goals for student achievement linked to individual teachers professional development                                                                                                 ') where title like '6.3%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently demonstrates leadership for developing systems that communicate and support staff in upholding legal responsibilities; creates a culture of shared legal responsibility among students and staff; involves  stakeholders in the creation of a school culture that thrives upon and benefits from addressing legal responsibilities                                                                                                                                                                                                                                                                                                                                                                                             ') where title like '6.4%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND moves beyond typical communication practices to proactively develop relationships through  home visits, innovative technology, visiting community groups, etc. with parents/guardians and community ; creates and promotes opportunities for students and families to explain and share their experiences with school; establishes a feedback loop that is invitational, transparent, effective and trusted by members of the community including open forums, focus groups or surveys; employs successful models of school, family, business, community, government and higher education partnerships to promote learning ; use of exemplary education marketing skills to establish partnerships to mobilize wealth of community resources') where title like '7.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND consistently demonstrates leadership in the area of effectively engaging families and the greater community in support of students, staff and the vision of improved teaching and learning; is recognized outside of school for developing and implementing programs that partner with school, family and greater community; programs are held as a model for other schools to adopt and follow; builds capacity in the community for initiating new and beneficial forms of community involvement in school; service integration through partnerships involving school, civic, counseling, cultural, health, recreation and others to meet needs of parents, caregivers and students                                                       ') where title like '7.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND focuses attention of school community on the goal of closing gaps; systematically challenges the status quo by leading change, based on data, resulting in beneficial outcomes; builds capacity among community to support the effort to close  gaps                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ') where title like '8.1%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Is proficient AND successfully keeps the work of closing gaps at the forefront of intention for  staff and community members; assumes responsibility for closing  gaps; builds capacity in staff members and others to advance learning for  students; has deep knowledge and understanding of the nature of gaps that exist at the level of group and at the level of individual students who are not reaching full learning potential                                                                                                                                                                                                                                                                                                                       ') where title like '8.2%' and belongsToDistrict = 'bprin'
update seRubricRow set pl4descriptor = rtrim('Achievement data from multiple sources or data points show  evidence of consistent growth toward the district’s learning goals; there is consistent record of improved student achievement, on multiple indicators,  with identified subgroups of students                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ') where title like '8.3%' and belongsToDistrict = 'bprin'


update seFrameworkNode set title = rtrim('Creating a school culture that promotes the ongoing improvement of learning and teaching for students and staff                                                        ') where title like 'Criterion #1:%' 
update seFrameworkNode set title = rtrim('Providing for School Safety                                                                                                                                            ') where title like 'Criterion #2:%' 
update seFrameworkNode set title = rtrim('Leads development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements         ') where title like 'Criterion #3:%' 
update seFrameworkNode set title = rtrim('Assisting instructional staff with alignment of curriculum, instruction, and assessment with state and local district learning goals                                   ') where title like 'Criterion #4:%' 
update seFrameworkNode set title = rtrim('Monitoring, assisting and evaluating effective instruction and assessment practices                                                                                    ') where title like 'Criterion #5:%' 
update seFrameworkNode set title = rtrim('Managing both staff and fiscal resources to support student achievement and legal responsibilities                                                                     ') where title like 'Criterion #6:%' 
update seFrameworkNode set title = rtrim('Partnering with the school community to promote student learning                                                                                                       ') where title like 'Criterion #7:%' 
update seFrameworkNode set title = rtrim('Demonstrate a commitment to closing the achievement gap                                                                                                                ') where title like 'Criterion #8:%' 

*/
/******************end patches to 2282*********************/
/******************begin patches to 2291*********************/
--they revised the teacher frameworks without telling me, and now here it is, sunday before monday release, 
-- and i've got to hack the proto db!!!

/*

--update danielson rows
UPDATE seRubricRow SET title = '3b: Using Questions and Discussion Techniques' where belongstodistrict = 'bdan' and title LIKE  '3b: %'

update seRubricRow set pl1descriptor = rtrim('<p>In planning and practice, teacher makes content errors or does not correct errors made by students.</p> <p>Teacher’s plans and practice display little understanding of prerequisite relationships important to student’s learning of the content.</p> Teacher displays little or no understanding of the range of pedagogical approaches suitable to student’s learning of the content.') where belongsToDistrict = 'bdan' and title like '1a: %'
update seRubricRow set pl1descriptor = rtrim('Teacher demonstrates little or no understanding of how students learn and little knowledge of students’ backgrounds, cultures, skills, language proficiency, interests, and special needs and does not seek such understanding.                                                                                                                                                            ') where belongsToDistrict = 'bdan' and title like '1b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Outcomes represent low expectations for students and lack of rigor, and not all of them reflect important learning in the discipline.</p><p>Outcomes are stated as activities rather than as student learning. </p>Outcomes reflect only one type of learning and only one discipline or strand and are suitable for only some students.                                                ') where belongsToDistrict = 'bdan' and title like '1c: %'
update seRubricRow set pl1descriptor = rtrim('Teacher is unaware of school or district resources for classroom use, for the expansion of his or her own knowledge, or for students.                                                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '1d: %'
update seRubricRow set pl1descriptor = rtrim('<p>The series of learning experiences is poorly aligned with the instructional outcomes and does not represent a coherent structure.</p> The activities are not designed to engage students in active intellectual activity and have unrealistic time allocations. Instructional groups do not support the instructional outcomes and offer no variety.                                    ') where belongsToDistrict = 'bdan' and title like '1e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Assessment procedures are not congruent with instructional outcomes; the proposed approach contains no criteria or standards.</p> Teacher has no plan to incorporate formative assessment in the lesson or unit nor any plan to use assessment results in designing future instruction.                                                                                                 ') where belongsToDistrict = 'bdan' and title like '1f: %'
update seRubricRow set pl1descriptor = rtrim('<p>Patterns of classroom interactions, both between the teacher and students and among students, are mostly negative, inappropriate, or insensitive to students’ ages, cultural backgrounds, and developmental levels. Interactions are characterized by sarcasm, put-downs, or conflict. </p>Teacher does not deal with disrespectful behavior.                                           ') where belongsToDistrict = 'bdan' and title like '2a: %'
update seRubricRow set pl1descriptor = rtrim('<p>The classroom culture is characterized by a lack of teacher or student commitment to learning and/or little or no investment of student energy into the task at hand. Hard work is not expected or valued.  </p> Medium or low expectations for student achievement are the norm, with high expectations for learning reserved for only one or two students.                            ') where belongsToDistrict = 'bdan' and title like '2b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Much instructional time is lost through inefficient classroom routines and procedures. </p><p>There is little or no evidence that the teacher is managing instructional groups, transitions, and/or the handling of materials and supplies effectively. </p>There is little evidence that students know or follow established routines.                                                 ') where belongsToDistrict = 'bdan' and title like '2c: %'
update seRubricRow set pl1descriptor = rtrim('<p>There appear to be no established standards of conduct and little or no teacher monitoring of student behavior.</p><p> Students challenge the standards of conduct. </p>Response to students’ misbehavior is repressive or disrespectful of student dignity.                                                                                                                            ') where belongsToDistrict = 'bdan' and title like '2d: %'
update seRubricRow set pl1descriptor = rtrim('<p>The physical environment is unsafe, or many students don’t have access to learning resources. </p>There is poor coordination between the lesson activities and the arrangement of furniture and resources, including computer technology.                                                                                                                                               ') where belongsToDistrict = 'bdan' and title like '2e: %'
update seRubricRow set pl1descriptor = rtrim('<p>The instructional purpose of the lesson is unclear to students, and the directions and procedures are confusing.</p><p> The teacher’s explanation of the content contains major errors. </p><p> The teacher’s spoken or written language contains errors of grammar or syntax.</p> The teacher’s vocabulary is inappropriate, vague, or used incorrectly, leaving students confused.    ') where belongsToDistrict = 'bdan' and title like '3a: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s questions are of low cognitive challenge, require single correct responses, and are asked in rapid succession. </p><p>Interaction between teacher and students is predominantly recitation style, with the teacher mediating all questions and answers.</p> A few students dominate the discussion.                                                                           ') where belongsToDistrict = 'bdan' and title like '3b: %'
update seRubricRow set pl1descriptor = rtrim('<p>The learning tasks and activities, materials, resources, instructional groups and technology are poorly aligned with the instructional outcomes or require only rote responses. </p><p>The pace of the lesson is too slow or too rushed. </p>Few students are intellectually engaged or interested.                                                                                     ') where belongsToDistrict = 'bdan' and title like '3c: %'
update seRubricRow set pl1descriptor = rtrim('<p>There is little or no assessment or monitoring of student learning; feedback is absent or of poor quality.</p> Students do not appear to be aware of the assessment criteria and do not engage in self-assessment.                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '3d: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher adheres to the instruction plan in spite of evidence of poor student understanding or lack of interest.</p> Teacher ignores student questions; when students experience difficulty, the teacher blames the students or their home environment.                                                                                                                                  ') where belongsToDistrict = 'bdan' and title like '3e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher does not know whether a lesson was effective or achieved its instructional outcomes, or he/she profoundly misjudges the success of a lesson. </p>Teacher has no suggestions for how a lesson could be improved.                                                                                                                                                                 ') where belongsToDistrict = 'bdan' and title like '4a: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s system for maintaining information on student completion of assignments and student progress in learning is nonexistent or in disarray. </p>Teacher’s records for noninstructional activities are in disarray, resulting in errors and confusion.                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '4b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher communication with families— about the instructional program, about individual students—is sporadic or culturally inappropriate.</p> Teacher makes no attempt to engage families in the instructional program.                                                                                                                                                                  ') where belongsToDistrict = 'bdan' and title like '4c: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s relationships with colleagues are negative or self-serving.</p><p> Teacher avoids participation in a professional culture of inquiry, resisting opportunities to become involved. </p>Teacher avoids becoming involved in school events or school and district projects.                                                                                                      ') where belongsToDistrict = 'bdan' and title like '4d: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher engages in no professional development activities to enhance knowledge or skill.</p><p> Teacher resists feedback on teaching performance from either supervisors or more experienced colleagues. </p>Teacher makes no effort to share knowledge with others or to assume professional responsibilities.                                                                         ') where belongsToDistrict = 'bdan' and title like '4e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher displays dishonesty in interactions with colleagues, students, and the public.</p><p> Teacher is not alert to students’ needs and contributes to school practices that result in some students’ being ill served by the school.</p> Teacher makes decisions and recommendations based on self-serving interests. Teacher does not comply with school and district regulations.  ') where belongsToDistrict = 'bdan' and title like '4f: %'


update seRubricRow set pl2descriptor = rtrim('<p>Teacher is familiar with the important concepts in the discipline but displays lack of awareness of how these concepts relate to one another.</p><p> Teacher’s plans and practice indicate some awareness of prerequisite relationships, although such knowledge may be inaccurate or incomplete. </p>Teacher’s plans and practice reflect a limited range of pedagogical approaches to the discipline or to the students.                                                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '1a: %'
update seRubricRow set pl2descriptor = rtrim('Teacher indicates the importance of under- standing how students learn and the students’ backgrounds, cultures, skills, language proficiency, interests, and special needs, and attains this knowledge about the class as a whole.                                                                                                                                                                                                                                                                                                                                                                    ') where belongsToDistrict = 'bdan' and title like '1b: %'
update seRubricRow set pl2descriptor = rtrim('<p>Outcomes represent moderately high expectations and rigor.</p> <p>Some reflect important learning in the discipline and consist of a combination of outcomes and activities. </p><p>Outcomes reflect several types of learning, but teacher has made no attempt at coordination or integration.</p> Most of the outcomes are suitable for most of the students in the class in accordance with global assessments of student learning.                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '1c: %'
update seRubricRow set pl2descriptor = rtrim('Teacher displays basic awareness of school or district resources available for classroom use, for the expansion of his or her own knowledge, and for students, but no knowledge of resources available more broadly.                                                                                                                                                                                                                                                                                                                                                                                  ') where belongsToDistrict = 'bdan' and title like '1d: %'
update seRubricRow set pl2descriptor = rtrim('<p>Some of the learning activities and materials are suitable to the instructional outcomes and represent a moderate cognitive challenge but with no differentiation for different students. Instructional groups partially support the instructional outcomes, with an effort by the teacher at providing some variety. </p>The lesson or unit has a recognizable structure; the progression of activities is uneven, with most time allocations reason- able.                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '1e: %'
update seRubricRow set pl2descriptor = rtrim('<p>Some of the instructional outcomes are assessed through the proposed approach, but others are not. </p><p>Assessment criteria and standards have been developed, but they are not clear.</p><p> Approach to the use of formative assessment is rudimentary, including only some of the instructional outcomes. </p>Teacher intends to use assessment results to plan for future instruction for the class as a whole.                                                                                                                                                                              ') where belongsToDistrict = 'bdan' and title like '1f: %'
update seRubricRow set pl2descriptor = rtrim('<p>Patterns of classroom interactions, both between the teacher and students and among students, are generally appropriate but may reflect occasional inconsistencies, favoritism, and disregard for students’ ages, cultures, and developmental levels.</p><p> Students rarely demonstrate disrespect for one another.</p> Teacher attempts to respond to disrespectful behavior, with uneven results. The net result of the interactions is neutral, conveying neither warmth nor conflict.                                                                                                         ') where belongsToDistrict = 'bdan' and title like '2a: %'
update seRubricRow set pl2descriptor = rtrim('<p>The classroom culture is characterized by little commitment to learning by teacher or students. </p> <p> The teacher appears to be only going through the motions, and students indicate that they are interested in completion of a task, rather than quality.  </p> The teacher conveys that student success is the result of natural ability rather than hard work; high expectations for learning are reserved for those students thought to have a natural aptitude for the subject.                                                                                                          ') where belongsToDistrict = 'bdan' and title like '2b: %'
update seRubricRow set pl2descriptor = rtrim('<p>Some instructional time is lost through only partially effective classroom routines and procedures.</p><p> The teacher’s management of instructional groups, transitions, and/or the handling of materials and supplies is inconsistent, the result being some disruption of learning.</p> With regular guidance and prompting, students follow established routines.                                                                                                                                                                                                                              ') where belongsToDistrict = 'bdan' and title like '2c: %'
update seRubricRow set pl2descriptor = rtrim('<p>Standards of conduct appear to have been established, but their implementation is inconsistent. </p><p>Teacher tries, with uneven results, to monitor student behavior and respond to student misbehavior. </p>There is inconsistent implementation of the standards of conduct.                                                                                                                                                                                                                                                                                                                   ') where belongsToDistrict = 'bdan' and title like '2d: %'
update seRubricRow set pl2descriptor = rtrim('<p>The classroom is safe, and essential learn- ing is accessible to most students. </p><p>The teacher’s use of physical resources, including computer technology, is moderately effective. </p>Teacher makes some attempt to modify the physical arrangement to suit learning activities, with partial success.                                                                                                                                                                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '2e: %'
update seRubricRow set pl2descriptor = rtrim('<p>The teacher’s attempt to explain the instructional purpose has only limited success, and/or directions and procedures must be clarified after initial student confusion.</p><p> The teacher’s explanation of the content may contain minor errors; some portions are clear; other portions are difficult to follow. </p><p>The teacher’s explanation consists of a monologue, with no invitation to the students for intellectual engagement. </p>Teacher’s spoken language is correct; how- ever, his or her vocabulary is limited, or not fully appropriate to the students’ ages or backgrounds.') where belongsToDistrict = 'bdan' and title like '3a: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher’s questions lead students through a single path of inquiry, with answers seemingly determined in advance. </p><p> Alternatively, the teacher attempts to frame some questions designed to promote student thinking and understanding, but only a few students are involved.</p> Teacher attempts to engage all students in the discussion and to encourage them to respond to one another, but with uneven results.                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '3b: %'
update seRubricRow set pl2descriptor = rtrim('<p>The learning tasks and activities are partially aligned with the instructional out- comes but require only minimal thinking by students, allowing most to be passive or merely compliant.</p> The pacing of the lesson may not provide students the time needed to be intellectually engaged.                                                                                                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '3c: %'
update seRubricRow set pl2descriptor = rtrim('<p>Assessment is used sporadically by teacher and/or students to support instruction through some monitoring of progress in learning.</p><p> Feedback to students is general, students appear to be only partially aware of the assessment criteria used to evaluate their work, and few assess their own work.</p> Questions, prompts, and assessments are rarely used to diagnose evidence of learning.                                                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '3d: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher attempts to modify the lesson when needed and to respond to student questions and interests, with moderate success.</p> Teacher accepts responsibility for student success but has only a limited repertoire of strategies to draw upon.                                                                                                                                                                                                                                                                                                                                                   ') where belongsToDistrict = 'bdan' and title like '3e: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher has a generally accurate impression of a lesson’s effectiveness and the extent to which instructional outcomes were met. </p>Teacher makes general suggestions about how a lesson could be improved.                                                                                                                                                                                                                                                                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '4a: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher’s system for maintaining information on student completion of assignments and student progress in learning is rudimentary and only partially effective.</p> Teacher’s records for noninstructional activities are adequate but require frequent monitoring to avoid errors.                                                                                                                                                                                                                                                                                                                ') where belongsToDistrict = 'bdan' and title like '4b: %'
update seRubricRow set pl2descriptor = rtrim('Teacher makes sporadic attempts to communicate with families about the instructional program and about the progress of individual students but does not attempt to engage families in the instructional program. Communications are one-way and not always appropriate to the cultural norms of those families.                                                                                                                                                                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '4c: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher maintains cordial relationships with colleagues to fulfill duties that the school or district requires.</p><p> Teacher becomes involved in the school’s culture of professional inquiry when invited to do so.</p> Teacher participates in school events and school and district projects when specifically asked to do so.                                                                                                                                                                                                                                                                ') where belongsToDistrict = 'bdan' and title like '4d: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher participates in professional activities to a limited extent when they are convenient.</p><p> Teacher accepts, with some reluctance, feedback on teaching performance from both supervisors and colleagues. </p>Teacher finds limited ways to contribute to the profession.                                                                                                                                                                                                                                                                                                                 ') where belongsToDistrict = 'bdan' and title like '4e: %'
update seRubricRow set pl2descriptor = rtrim('<p>Teacher is honest in interactions with col- leagues, students, and the public. </p><p>Teacher attempts, though inconsistently, to serve students. Teacher does not knowingly contribute to some students’ being ill served by the school. </p><p>Teacher’s decisions and recommendations are based on limited but genuinely professional considerations.</p> Teacher complies minimally with school and district regulations, doing just enough to get by.                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '4f: %'

update seRubricRow set pl3descriptor = rtrim('<p>Teacher displays solid knowledge of the important concepts in the discipline and the ways they relate to one another. </p><p>Teacher’s plans and practice reflect accurate understanding of prerequisite relationships among topics and concepts.</p> Teacher’s plans and practice reflect familiarity with a wide range of effective pedagogical approaches in the discipline.                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '1a: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher understands the active nature of student learning and attains information about levels of development for groups of students. </p>The teacher also purposefully seeks knowledge from several sources of students’ backgrounds, cultures, skills, language proficiency, interests, and special needs and attains this knowledge about groups of students.                                                                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '1b: %'
update seRubricRow set pl3descriptor = rtrim('<p>Most outcomes represent rigorous and important learning in the discipline. </p><p>All the instructional outcomes are clear, are written in the form of student learning, and suggest viable methods of assessment.</p> <p>Outcomes reflect several different types of learning and opportunities for coordination. </p>Outcomes take into account the varying needs of groups of students.                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '1c: %'
update seRubricRow set pl3descriptor = rtrim('Teacher displays awareness of resources—not only through the school and district but also through sources external to the school and on the Internet—available for classroom use, for the expansion of his or her own knowledge, and for students.                                                                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '1d: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher coordinates knowledge of content, of students, and of resources, to design a series of learning experiences aligned to instructional outcomes and suitable to groups of students.</p> <p>The learning activities have reasonable time allocations; they represent significant cognitive challenge, with some differentiation for different groups of students.</p> The lesson or unit has a clear structure, with appropriate and varied use of instructional groups.                                                                          ') where belongsToDistrict = 'bdan' and title like '1e: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher’s plan for student assessment is aligned with the instructional outcomes; assessment methodologies may have been adapted for groups of students. </p><p>Assessment criteria and standards are clear. Teacher has a well-developed strategy for using formative assessment and has designed particular approaches to be used.</p> Teacher intends to use assessment results to plan for future instruction for groups of students.                                                                                                              ') where belongsToDistrict = 'bdan' and title like '1f: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher-student interactions are friendly and demonstrate general caring and respect. Such interactions are appropriate to the ages of the students. </p><p>Students exhibit respect for the teacher. Inter- actions among students are generally polite and respectful.</p> Teacher responds successfully to disrespectful behavior among students. The net result of the interactions is polite and respectful, but impersonal.                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '2a: %'
update seRubricRow set pl3descriptor = rtrim('<p>The classroom culture is a cognitively busy place where learning is valued by all, with high expectations for learning being the norm for most students. </p> <p> The teacher conveys that with hard work students can be successful. </p> <p> Students understand their role as learners and consistently expend effort to learn. </p> Classroom interactions support learning and hard work.                                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '2b: %'
update seRubricRow set pl3descriptor = rtrim('<p>There is little loss of instructional time because of effective classroom routines and procedures. </p><p>The teacher’s management of instructional groups and the handling of materials and sup- plies are consistently successful.</p> With minimal guidance and prompting, students follow established classroom routines.                                                                                                                                                                                                                          ') where belongsToDistrict = 'bdan' and title like '2c: %'
update seRubricRow set pl3descriptor = rtrim('<p>Student behavior is generally appropriate.</p><p> The teacher monitors student behavior against established standards of conduct. </p>Teacher response to student misbehavior is consistent, proportionate, respectful to students, and effective.                                                                                                                                                                                                                                                                                                     ') where belongsToDistrict = 'bdan' and title like '2d: %'
update seRubricRow set pl3descriptor = rtrim('<p>The classroom is safe, and learning is accessible to all students; teacher ensures that the physical arrangement is appropriate to the learning activities. </p>Teacher makes effective use of physical resources, including computer technology.                                                                                                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '2e: %'
update seRubricRow set pl3descriptor = rtrim('<p>The teacher clearly communicates instructional purpose of the lesson, including where it is situated within broader learning, and explains procedures and directions clearly. </p> <p>Teacher’s explanation of content is well scaffolded, clear and accurate, and connects with students’ knowledge and experience. </p><p>During the explanation of content, the teacher invites student intellectual engagement. </p>Teacher’s spoken and written language is clear and correct and uses vocabulary appropriate to the students’ ages and interests.') where belongsToDistrict = 'bdan' and title like '3a: %'
update seRubricRow set pl3descriptor = rtrim('<p>Although the teacher may use some low-level questions, he or she asks the students questions designed to promote thinking and understanding.</p><p> Teacher creates a genuine discussion among students, providing adequate time for students to respond and stepping aside when appropriate.</p> Teacher successfully engages most students in the discussion, employing a range of strategies to ensure that most students are heard.                                                                                                                ') where belongsToDistrict = 'bdan' and title like '3b: %'
update seRubricRow set pl3descriptor = rtrim('<p>The learning tasks and activities are aligned with the instructional outcomes and designed to challenge student thinking, the result being that most students display active intellectual engagement with important and challenging content and are supported in that engagement by teacher scaffolding. </p>The pacing of the lesson is appropriate, providing most students the time needed to be intellectually engaged.                                                                                                                            ') where belongsToDistrict = 'bdan' and title like '3c: %'
update seRubricRow set pl3descriptor = rtrim('<p>Assessment is used regularly by teacher and/or students during the lesson through monitoring of learning progress and results in accurate, specific feedback that advances learning.</p> <p>Students appear to be aware of the assessment criteria; some of them engage in self-assessment. </p>Questions, prompts, assessments are used to diagnose evidence of learning.                                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '3d: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher promotes the successful learning of all students, making minor adjustments as needed to instruction plans and accommodating student questions, needs, and interests. </p>Drawing on a broad repertoire of strategies, the teacher persists in seeking approaches for students who have difficulty learning.                                                                                                                                                                                                                                    ') where belongsToDistrict = 'bdan' and title like '3e: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher makes an accurate assessment of a lesson’s effectiveness and the extent to which it achieved its instructional outcomes and can cite general references to support the judgment.</p> Teacher makes a few specific suggestions of what could be tried another time the lesson is taught.                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '4a: %'
update seRubricRow set pl3descriptor = rtrim('Teacher’s system for maintaining information on student completion of assignments, student progress in learning, and noninstructional records is fully effective.                                                                                                                                                                                                                                                                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '4b: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher communicates frequently with families about the instructional program and conveys information about individual student progress. </p><p>Teacher makes some attempts to engage families in the instructional program.</p> Information to families is conveyed in a culturally appropriate manner.                                                                                                                                                                                                                                               ') where belongsToDistrict = 'bdan' and title like '4c: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher’s relationships with colleagues are characterized by mutual support and cooperation; teacher actively participates in a culture of professional inquiry.</p> Teacher volunteers to participate in school events and in school and district projects, making a substantial contribution.                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '4d: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher seeks out opportunities for professional development to enhance content knowledge and pedagogical skill.</p><p> Teacher welcomes feedback from colleagues—either when made by supervisors or when opportunities arise through professional collaboration. </p>Teacher participates actively in assisting other educators.                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '4e: %'
update seRubricRow set pl3descriptor = rtrim('<p>Teacher displays high standards of honesty, integrity, and confidentiality in interactions with colleagues, students, and the public.</p><p> Teacher is active in serving students, working to ensure that all students receive a fair opportunity to succeed. </p><p>Teacher maintains an open mind in team or departmental decision making. </p>Teacher complies fully with school and district regulations.                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '4f: %'

update seRubricRow set pl1descriptor = rtrim('<p>Teacher displays extensive knowledge of the important concepts in the discipline and the ways they relate both to one another and to other disciplines. </p><p>Teacher’s plans and practice reflect understanding of prerequisite relationships among topics and concepts and provide a link to necessary cognitive structures needed by students to ensure understanding.</p> Teacher’s plans and practice reflect familiarity with a wide range of effective pedagogical approaches in the discipline, anticipating student misconceptions.                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '1a: %'
update seRubricRow set pl1descriptor = rtrim('Teacher actively seeks knowledge of students’ levels of development and their backgrounds, cultures, skills, language proficiency, interests, and special needs from a variety of sources. This information is acquired for individual students.                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '1b: %'
update seRubricRow set pl1descriptor = rtrim('<p>All outcomes represent rigorous and important learning in the discipline.</p><p> The outcomes are clear, are written in the form of student learning, and permit viable methods of assessment.</p><p> Outcomes reflect several different types of learning and, where appropriate, represent opportunities for both coordination and integration. </p>Outcomes take into account the varying needs of individual students.                                                                                                                                                                                                                                                                                           ') where belongsToDistrict = 'bdan' and title like '1c: %'
update seRubricRow set pl1descriptor = rtrim('Teacher displays extensive knowledge of resources—not only through the school and district but also in the community, through professional organizations and universities, and on the Internet—for classroom use, for the expansion of his or her own knowledge, and for students.                                                                                                                                                                                                                                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '1d: %'
update seRubricRow set pl1descriptor = rtrim('<p>Plans represent the coordination of in-depth content knowledge, understanding of different students’ needs, and available resources (including technology), resulting in a series of learning activities designed to engage students in high-level cognitive activity.</p><p> Learning activities are differentiated appropriately for individual learners. Instructional groups are varied appropriately with some opportunity for student choice. </p>The lesson’s or unit’s structure is clear and allows for different pathways according to diverse student needs.                                                                                                                                              ') where belongsToDistrict = 'bdan' and title like '1e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s plan for student assessment is fully aligned with the instructional outcomes and has clear criteria and standards that show evidence of student contribution to their development.</p><p> Assessment methodologies have been adapted for individual students, as needed. </p>The approach to using formative assessment is well designed and includes student as well as teacher use of the assessment information. Teacher intends to use assessment results to plan future instruction for individual students.                                                                                                                                                                                          ') where belongsToDistrict = 'bdan' and title like '1f: %'
update seRubricRow set pl1descriptor = rtrim('<p>Classroom interactions among the teacher and individual students are highly respectful, reflecting genuine warmth and caring and sensitivity to students as individuals.</p> Students exhibit respect for the teacher and contribute to high levels of civil interaction between all members of the class. The net result of interactions is that of connections with students as individuals.                                                                                                                                                                                                                                                                                                                       ') where belongsToDistrict = 'bdan' and title like '2a: %'
update seRubricRow set pl1descriptor = rtrim('<p>The classroom culture is a cognitively vibrant place, characterized by a shared belief in the importance of learning. </p> <p> The teacher conveys high expectations for learning by all students and insists on hard work. </p> Students assume responsibility for high quality by initiating improvements, making revisions, adding detail, and/or helping peers.                                                                                                                                                                                                                                                                                                                                                  ') where belongsToDistrict = 'bdan' and title like '2b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Instructional time is maximized because of efficient classroom routines and procedures.</p><p>Students contribute to the management of instructional groups, transitions, and the handling of materials and supplies. </p>Routines are well understood and may be initiated by students.                                                                                                                                                                                                                                                                                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '2c: %'
update seRubricRow set pl1descriptor = rtrim('<p>Student behavior is entirely appropriate. </p><p>Students take an active role in monitoring their own behavior and that of other students against standards of conduct.</p><p> Teachers’ monitoring of student behavior is subtle and preventive.</p> Teacher’s response to student misbehavior is sensitive to individual student needs and respects students’ dignity.                                                                                                                                                                                                                                                                                                                                             ') where belongsToDistrict = 'bdan' and title like '2d: %'
update seRubricRow set pl1descriptor = rtrim('<p>The classroom is safe, and learning is accessible to all students, including those with special needs. </p><p>Teacher makes effective use of physical resources, including computer technology. The teacher ensures that the physical arrangement is appropriate to the learning activities. </p> Students contribute to the use or adaptation of the physical environment to advance learning.                                                                                                                                                                                                                                                                                                                      ') where belongsToDistrict = 'bdan' and title like '2e: %'
update seRubricRow set pl1descriptor = rtrim('<p>The teacher links the instructional purpose of the lesson to student interests; the directions and procedures are clear and anticipate possible student misunderstanding.</p> <p>The teacher’s explanation of content is thorough and clear, developing conceptual understanding through artful scaffolding and connecting with students’ interests.</p><p> Students contribute to extending the content and help explain concepts to their classmates.</p> The teacher’s spoken and written language is expressive, and the teacher finds opportunities to extend students’ vocabularies.                                                                                                                           ') where belongsToDistrict = 'bdan' and title like '3a: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher uses a variety or series of questions or prompts to challenge students cognitively, advance high-level thinking and discourse, and promote metacognition.</p><p> Students formulate many questions, initiate topics, and make unsolicited contributions. </p>Students themselves ensure that all voices are heard in the discussion.                                                                                                                                                                                                                                                                                                                                                                         ') where belongsToDistrict = 'bdan' and title like '3b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Virtually all students are intellectually engaged in challenging content through well-designed learning tasks and suitable scaffolding by the teacher and fully aligned with the instructional outcomes.</p> <p>In addition, there is evidence of some student initiation of inquiry and of student contribution to the exploration of important content. </p><p>The pacing of the lesson provides students the time needed to intellectually engage with and reflect upon their learning and to consolidate their understanding.</p> Students may have some choice in how they complete tasks and may serve as resources for one another.                                                                           ') where belongsToDistrict = 'bdan' and title like '3c: %'
update seRubricRow set pl1descriptor = rtrim('<p>Assessment is fully integrated into instruction through extensive use of formative assessment.</p><p> Students appear to be aware of, and there is some evidence that they have contributed to, the assessment criteria.</p><p> Students self-assess and monitor their progress. </p><p>A variety of feedback, from both their teacher and their peers, is accurate, specific, and advances learning. </p>Questions, prompts, assessments are used regularly to diagnose evidence of learning by individual students.                                                                                                                                                                                                ') where belongsToDistrict = 'bdan' and title like '3d: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher seizes an opportunity to enhance learning, building on a spontaneous event or student interests, or successfully adjusts and differentiates instruction to address individual student misunderstandings. </p>Teacher persists in seeking effective approaches for students who need help, using an extensive repertoire of instructional strategies and soliciting additional resources from the school or community.                                                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '3e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher makes a thoughtful and accurate assessment of a lesson’s effectiveness and the extent to which it achieved its instructional out- comes, citing many specific examples from the lesson and weighing the relative strengths of each. </p>Drawing on an extensive repertoire of skills, teacher offers specific alternative actions, complete with the probable success of different courses of action.                                                                                                                                                                                                                                                                                                        ') where belongsToDistrict = 'bdan' and title like '4a: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s system for maintaining information on student completion of assignments, student progress in learning, and noninstructional records is fully effective. </p>Students contribute information and participate in maintaining the records.                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ') where belongsToDistrict = 'bdan' and title like '4b: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s communication with families is frequent and sensitive to cultural traditions, with students contributing to the communication.</p><p> Response to family concerns is handled with professional and cultural sensitivity. </p>Teacher’s efforts to engage families in the instructional program are frequent and successful.                                                                                                                                                                                                                                                                                                                                                                                ') where belongsToDistrict = 'bdan' and title like '4c: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher’s relationships with colleagues are characterized by mutual support and cooperation, with the teacher taking initiative in assuming leadership among the faculty. </p><p>Teacher takes a leadership role in promoting a culture of professional inquiry.</p> Teacher volunteers to participate in school events and district projects making a substantial contribution, and assuming a leadership role in at least one aspect of school or district life.                                                                                                                                                                                                                                                   ') where belongsToDistrict = 'bdan' and title like '4d: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher seeks out opportunities for professional development and makes a systematic effort to conduct action research.</p><p> Teacher seeks out feedback on teaching from both supervisors and colleagues.</p> Teacher initiates important activities to contribute to the profession.                                                                                                                                                                                                                                                                                                                                                                                                                               ') where belongsToDistrict = 'bdan' and title like '4e: %'
update seRubricRow set pl1descriptor = rtrim('<p>Teacher takes a leadership role with colleagues and can be counted on to hold to the highest standards of honesty, integrity, and confidentiality.</p><p> Teacher is highly proactive in serving students, seeking out resources when needed. Teacher makes a concerted effort to challenge negative attitudes or practices to ensure that all students, particularly those traditionally under- served, are honored in the school. </p><p>Teacher takes a leadership role in team or departmental decision making and helps ensure that such decisions are based on the highest professional standards.</p> Teacher complies fully with school and district regulations, taking a leadership role with col- leagues.') where belongsToDistrict = 'bdan' and title like '4f: %'

update seRubricRow set description = rtrim('Demonstrating Knowledge of Content and Pedagogy') where belongsToDistrict = 'bdan' and title like '1a: %'
update seRubricRow set description = rtrim('Demonstrating Knowledge of Students            ') where belongsToDistrict = 'bdan' and title like '1b: %'
update seRubricRow set description = rtrim('Designing Coherent Instruction                 ') where belongsToDistrict = 'bdan' and title like '1c: %'
update seRubricRow set description = rtrim('Setting Instructional Outcomes                 ') where belongsToDistrict = 'bdan' and title like '1d: %'
update seRubricRow set description = rtrim('Demonstrating Knowledge of Resources           ') where belongsToDistrict = 'bdan' and title like '1e: %'
update seRubricRow set description = rtrim('Using Assessment in Instruction                ') where belongsToDistrict = 'bdan' and title like '1f: %'
update seRubricRow set description = rtrim('Managing classroom procedures                  ') where belongsToDistrict = 'bdan' and title like '2a: %'
update seRubricRow set description = rtrim('?                                              ') where belongsToDistrict = 'bdan' and title like '2b: %'
update seRubricRow set description = rtrim('Managing Student Behavior                      ') where belongsToDistrict = 'bdan' and title like '2c: %'
update seRubricRow set description = rtrim('Creating an environment of respect and rapport ') where belongsToDistrict = 'bdan' and title like '2d: %'
update seRubricRow set description = rtrim('Organizing physical space                      ') where belongsToDistrict = 'bdan' and title like '2e: %'
update seRubricRow set description = rtrim('Communicating with students                    ') where belongsToDistrict = 'bdan' and title like '3a: %'
update seRubricRow set description = rtrim('Using questioning/prompts and discussion       ') where belongsToDistrict = 'bdan' and title like '3b: %'
update seRubricRow set description = rtrim('Engaging students in learning                  ') where belongsToDistrict = 'bdan' and title like '3c: %'
update seRubricRow set description = rtrim('Designing Student Assessments                  ') where belongsToDistrict = 'bdan' and title like '3d: %'
update seRubricRow set description = rtrim('Demonstrating flexibility and responsiveness   ') where belongsToDistrict = 'bdan' and title like '3e: %'
update seRubricRow set description = rtrim('Reflecting on Teaching                         ') where belongsToDistrict = 'bdan' and title like '4a: %'
update seRubricRow set description = rtrim('Maintaining Accurate Records                   ') where belongsToDistrict = 'bdan' and title like '4b: %'
update seRubricRow set description = rtrim('Communicating with Families                    ') where belongsToDistrict = 'bdan' and title like '4c: %'
update seRubricRow set description = rtrim('Participating in a Professional Community      ') where belongsToDistrict = 'bdan' and title like '4d: %'
update seRubricRow set description = rtrim('Growing and Developing Professionally          ') where belongsToDistrict = 'bdan' and title like '4e: %'
update seRubricRow set description = rtrim('Showing Professionalism                        ') where belongsToDistrict = 'bdan' and title like '4f: %'
                                                                                              
INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential. ')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals rely on limited source or low-quality data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BDAN', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BDAN', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for whole classroom.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals rely on limited sources of data or low quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for individual students in collaboration with students and parents, and for whole classroom that align to school goals. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BDAN', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BDAN', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.1 Establish Student Growth Goals, Implement and Monitor Growth')
,rtrim('Does not collaborate or reluctantly collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Does not consistently collaborate with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, measures, to monitor growth and achievement during the year.')
,rtrim('Consistently and actively collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Leads other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
, 1, 'BDAN', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.2  Achievement of Student Growth Goal(s)')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time shows no evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show some evidence of growth for some students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show clear evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show evidence of high growth for all or nearly all students in the grade-level, subject matter or instructional team. ')
, 1, 'BDAN', '')

--update CEL rows

update seRubricRow set pl1Descriptor = rtrim('Students are rarely or never given an opportunity to assess their own learning in relation to the success criteria for the learning target.                                                                                                                                            ')where title like rtrim('A1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Assessments are not aligned with the learning targets.                                                                                                                                                                                                                                 ')where title like rtrim('A2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never provides formative assessment opportunities during the lesson.                                                                                                                                                                                                 ')where title like rtrim('A3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses an observable system and/or routines for recording formative assessment data.                                                                                                                                                                             ')where title like rtrim('A4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Students rarely or never use assessment data to assess their own learning.                                                                                                                                                                                                             ')where title like rtrim('A5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses formative assessment data to make instructional adjustments, give feedback to students or modify lessons.                                                                                                                                                 ')where title like rtrim('A6   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Physical environment of the room is unsafe and the arrangement gets in the way or distracts from student learning and the purpose of the lesson.                                                                                                                                       ')where title like rtrim('CEC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('The resources, materials and technology in the classroom do not relate to the content or current units studied, or are not accessible to all students to support their learning during the lesson.                                                                                     ')where title like rtrim('CEC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Routines for discussion and collaborative work are absent, poorly executed or do not hold students accountable for their work and learning.                                                                                                                                            ')where title like rtrim('CEC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher or students frequently disrupt or interrupt learning activities, which results in loss of learning time. Transitions are disorganized and result in loss of instructional time.                                                                                                ')where title like rtrim('CEC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never responds to student misbehavior by following classroom routines and/or building discipline procedures. Student behavior does not change or may escalate.                                                                                                       ')where title like rtrim('CEC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher does not develop appropriate and positive teacher-student relationships that attend to students’ well-being. Patterns of interaction or lack of interaction promote rivalry and/or unhealthy competition among students or some students are relegated to low status positions.')where title like rtrim('CEC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Classroom norms are not evident and/or do not address risk taking, collaboration, respect for divergent thinking or students’ culture.                                                                                                                                                 ')where title like rtrim('CEC7 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Instructional materials and tasks rarely or never align with the purpose of the unit and lesson.                                                                                                                                                                                       ')where title like rtrim('CP1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses discipline-specific teaching approaches and strategies that develop students’ conceptual understanding.                                                                                                                                                   ')where title like rtrim('CP2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Instruction is rarely or never consistent with pedagogical content knowledge and does not support students in discipline-specific habits of thinking.                                                                                                                                  ')where title like rtrim('CP3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher demonstrates a lack of knowledge of discipline-based concepts by making content errors.                                                                                                                                                                                        ')where title like rtrim('CP4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses strategies that differentiate for individual learning strengths and needs.                                                                                                                                                                                ')where title like rtrim('CP5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never scaffolds tasks for group or individual learning needs or teacher uses strategies that are generic and/or not relevant to the concepts and/or skills to be learned.                                                                                            ')where title like rtrim('CP6  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses strategies for the purpose of gradually releasing responsibility to students to promote learning and independence.                                                                                                                                        ')where title like rtrim('CP7  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('The lesson is not based on grade level standards.  There are no learning targets aligned to the standard. The lesson does not link to broader purpose or a transferable skill.                                                                                                         ')where title like rtrim('P1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('The lesson is rarely or never linked to previous and future lessons.                                                                                                                                                                                                                   ')where title like rtrim('P2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never bases the teaching point(s) on students’ learning needs – academic background, life experiences, culture and language.                                                                                                                                         ')where title like rtrim('P3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never states or communicates with students about the learning target(s).                                                                                                                                                                                             ')where title like rtrim('P4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('The success criteria for the learning target(s) are nonexistent or aren’t clear to students.                                                                                                                                                                                           ')where title like rtrim('P5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never collaborates with peers or engages in reflective inquiry for the purpose of improving instructional practice or student learning.                                                                                                                              ')where title like rtrim('PCC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never develops or sustains professional and collegial relationships for the purpose of student, staff or district growth. Teacher may subvert professional and collegial relationships.                                                                              ')where title like rtrim('PCC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never communicates in any manner with parents and guardians about student progress.                                                                                                                                                                                  ')where title like rtrim('PCC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher maintains minimal student records. Teacher rarely communicates student progress information to relevant individuals within the school community.                                                                                                                               ')where title like rtrim('PCC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher is unaware of or does not support school, district, or state initiatives. Teacher violates a district policy or rarely or never follows district curriculum/pacing guide.                                                                                                      ')where title like rtrim('PCC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher’s professional role toward adults and students is unfriendly or demeaning, crosses ethical boundaries, or is unprofessional.                                                                                                                                                   ')where title like rtrim('PCC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never asks questions to probe and deepen students’ understanding or uncover misconceptions.                                                                                                                                                                          ')where title like rtrim('SE1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never provides opportunities and strategies for students to take ownership of their own learning to develop, test and refine their thinking.                                                                                                                         ')where title like rtrim('SE2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher expectations and strategies engage few or no students in work of high cognitive demand.                                                                                                                                                                                        ')where title like rtrim('SE3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses strategies based on the learning needs of students – academic background, life experiences, culture and language of students.                                                                                                                             ')where title like rtrim('SE4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Teacher rarely or never uses engagement strategies and structures that facilitate participation and meaning making by all students. Few students have the opportunity to engage in quality talk.                                                                                       ')where title like rtrim('SE5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl1Descriptor = rtrim('Student talk is nonexistent or is unrelated to content or is limited to single-word responses or incomplete sentences directed to teacher.                                                                                                                                             ')where title like rtrim('SE6  %') and belongsToDistrict = 'bcel'

update seRubricRow set pl2Descriptor = rtrim('Students are occasionally given an opportunity to assess their own learning in relation to the success criteria for the learning target.                                                                                                ')where title like rtrim('A1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Assessment tasks are partially aligned with the learning targets, allowing students to demonstrate some understanding and/or skill related to the targets.                                                                              ')where title like rtrim('A2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher only provides formative assessment opportunities to determine students’ understanding of directions and task.                                                                                                                   ')where title like rtrim('A3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher has an observable system and routines for recording formative assessment data and occasionally uses the system for instructional purposes.                                                                                      ')where title like rtrim('A4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Students occasionally use assessment data to assess their own learning, determine learning goals and monitor progress over time.                                                                                                        ')where title like rtrim('A5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher uses formative assessment data to modify future lessons.                                                                                                                                                                        ')where title like rtrim('A6   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('The physical environment is safe but the arrangement neither supports nor distracts from student learning or the purpose of the lesson.                                                                                                 ')where title like rtrim('CEC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('The resources, materials and technology in the classroom relate to the content or current unit studied and are accessible to all students but are not referenced by teacher.                                                            ')where title like rtrim('CEC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Routines for discussion and collaborative work are present, but may not result in effective discourse. Students are held accountable for completing their work but not for learning.                                                    ')where title like rtrim('CEC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher or students occasionally disrupt or interrupt learning activities, which results in some loss of learning time. Some transitions are disorganized and result in loss of instructional time.                                     ')where title like rtrim('CEC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher responds to student misbehavior by following classroom routines and/or building discipline procedures, but with uneven student behavior results.                                                                                ')where title like rtrim('CEC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher demonstrates appropriate teacher-student relationships that foster students’ well-being. Patterns of interaction between teacher and students may send messages that some students’ contributions are more valuable than others.')where title like rtrim('CEC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Classroom norms are evident and encourage risk taking, collaboration, respect for divergent thinking and students’ culture. Teacher and student interactions occasionally align with the norms.                                         ')where title like rtrim('CEC7 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Instructional materials and tasks align with the purpose of the unit and lesson.                                                                                                                                                        ')where title like rtrim('CP1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally uses discipline-specific teaching approaches and strategies that develop students’ conceptual understanding.                                                                                                       ')where title like rtrim('CP2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Instruction is occasionally consistent with pedagogical content knoweldge and supports students in discipline-specific habits of thinking.                                                                                              ')where title like rtrim('CP3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher demonstrates a basic knowledge of how discipline-based concepts relate to or build upon one another.                                                                                                                            ')where title like rtrim('CP4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally uses strategies that differentiate for individual learning strengths and needs.                                                                                                                                    ')where title like rtrim('CP5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher provides limited scaffolds for individual or group learning needs. Strategies may or may not be relevant to the concepts and/or skills to be learned.                                                                           ')where title like rtrim('CP6  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally uses strategies for the purpose of gradually releasing responsibility to students to promote learning and independence.                                                                                            ')where title like rtrim('CP7  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('The lesson is based on grade level standards and the learning target(s) align to the standard. The lesson is occasionally linked to broader purpose or a transferable skill.                                                            ')where title like rtrim('P1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('The lesson is clearly linked to previous and future lessons.                                                                                                                                                                            ')where title like rtrim('P2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher bases the teaching point(s) on limited aspects of students’ learning needs – academic background, life experiences, culture and language.                                                                                       ')where title like rtrim('P3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher states the learning target(s) at the beginning of each lesson.                                                                                                                                                                  ')where title like rtrim('P4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('The success criteria for the learning target(s) are clear to students. The performance tasks align to the success criteria in a limited manner.                                                                                         ')where title like rtrim('P5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher collaborates and engages in reflective inquiry with peers and administrators for the purpose of improving instructional practice and student learning. Teacher provides minimal contributions.                                  ')where title like rtrim('PCC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher develops limited professional and collegial relationships for the purpose of student, staff or district growth.                                                                                                                 ')where title like rtrim('PCC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally communicates with all parents and guardians about goals of instruction and student progress, but usually relies on only one method for communication or requires support or reminders.                             ')where title like rtrim('PCC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher communicates student progress information to relevant individuals within the school community; however, performance data may have minor flaws or be narrowly defined (e.g., test scores only).                                  ')where title like rtrim('PCC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher supports and has a basic understanding of school, district, and state initiatives. Teacher follows district policies and curriculum/pacing guide.                                                                               ')where title like rtrim('PCC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher’s professional role toward adults and students is friendly, ethical, and professional and supports learning for all students, including the historically underserved.                                                           ')where title like rtrim('PCC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally asks questions to probe and deepen students’ understanding or uncover misconceptions.                                                                                                                              ')where title like rtrim('SE1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher occasionally provides opportunities and strategies for students to take ownership of their learning. Locus of control is with teacher.                                                                                          ')where title like rtrim('SE2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher expectations and strategies engage some students in work of high cognitive demand.                                                                                                                                              ')where title like rtrim('SE3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher uses strategies that capitalize and are based on learning needs of students – academic background, life experience and culture and language of students – for the whole group.                                                  ')where title like rtrim('SE4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Teacher uses engagement strategies and structures that facilitate participation and meaning making by students. Some students have the opportunity to engage in quality talk.                                                           ')where title like rtrim('SE5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl2Descriptor = rtrim('Student talk is directed to teacher. Talk associated with content occurs between students, but students do not provide evidence for their thinking.                                                                                     ')where title like rtrim('SE6  %') and belongsToDistrict = 'bcel'

update seRubricRow set pl3Descriptor = rtrim('Students frequently assess their own learning in relation to the success criteria for the learning target.                                                                                                                                                                                               ')where title like rtrim('A1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Assessment tasks are aligned with the learning targets, allowing students to demonstrate their understanding and/or skill related to the learning targets.                                                                                                                                               ')where title like rtrim('A2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher provides formative assessment opportunities that align with the learning target(s).                                                                                                                                                                                                              ')where title like rtrim('A3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher has an observable system and routines for recording formative assessment data, uses multiple sources and frequently uses the system for instructional purposes.                                                                                                                                  ')where title like rtrim('A4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Students frequently use assessment data to assess their own learning, determine learning goals and monitor progress over time.                                                                                                                                                                           ')where title like rtrim('A5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher uses formative assessment data to make in-the-moment instructional adjustments, modify future lessons and give general feedback aligned with the learning target.                                                                                                                                ')where title like rtrim('A6   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('The physical environment is safe, and the arrangement supports student learning and the purpose of the lesson.                                                                                                                                                                                           ')where title like rtrim('CEC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('The resources, materials and technology in the classroom relate to the content or current unit studied, are accessible to all students and are intentionally used by teacher to support learning.                                                                                                        ')where title like rtrim('CEC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Routines for discussion and collaborative work have been taught, are evident, and result in effective discourse related to the lesson purpose. With prompts, students use these routines during the lesson. Students are held accountable for their work and learning.                                   ')where title like rtrim('CEC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Learning time is mostly maximized in service of learning. Transitions are teacher-dependent and maximize instructional time.                                                                                                                                                                             ')where title like rtrim('CEC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher responds to student misbehavior by following classroom routines and building discipline procedures. Student misbehavior is rare.                                                                                                                                                                 ')where title like rtrim('CEC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher and students demonstrate appropriate teacher-student and student-student relationships that foster students’ well-being and adapt to meet individual circumstances. Patterns of interaction between teacher and students and among students indicate that all are valued for their contributions.')where title like rtrim('CEC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Classroom norms are evident and encourage risk taking, collaboration, respect for divergent thinking and students’ culture. Teacher and student interactions frequently align with the norms.                                                                                                            ')where title like rtrim('CEC7 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Instructional materials and tasks align with the purpose of the unit and lesson. Materials and tasks frequently align with student’s level of challenge.                                                                                                                                                 ')where title like rtrim('CP1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher frequently uses discipline-specific teaching approaches and strategies that develop students’ conceptual understanding.                                                                                                                                                                          ')where title like rtrim('CP2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Instruction is frequently consistent with pedagogical content jnwoeldge and supports students in discipline-specific habits of thinking.                                                                                                                                                                 ')where title like rtrim('CP3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher demonstrates a solid understanding of how discipline-based concepts relate to or build upon one another. Teacher identifies and addresses student misconceptions in the lesson or unit.                                                                                                          ')where title like rtrim('CP4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher frequently uses strategies that differentiate for individual learning strengths and needs.                                                                                                                                                                                                       ')where title like rtrim('CP5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher provides scaffolds and structures that are clearly related to and support the development of the targeted concepts and/or skills.                                                                                                                                                                ')where title like rtrim('CP6  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher frequently uses strategies for the purpose of gradually releasing responsibility to students to promote learning and independence.                                                                                                                                                               ')where title like rtrim('CP7  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('The lesson is based on grade level standards and the learning target(s) align to the standard. The lesson is frequently linked to broader purpose or a transferable skill.                                                                                                                               ')where title like rtrim('P1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Lessons build on each other in a logical progression.                                                                                                                                                                                                                                                    ')where title like rtrim('P2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher bases the teaching point(s) on the learning needs – academic background, life experiences, culture and language – for some groups of students.                                                                                                                                                   ')where title like rtrim('P3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher communicates the learning target(s) through verbal and visual strategies and checks for student understanding of what the target(s) are.                                                                                                                                                         ')where title like rtrim('P4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('The success criteria for the learning target(s) are clear to students. The performance tasks align to the success criteria.                                                                                                                                                                              ')where title like rtrim('P5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher collaborates and engages in reflective inquiry with peers and administrators for the purpose of improving instructional practice and student learning. Teacher contributes to collaborative work.                                                                                                ')where title like rtrim('PCC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher develops and sustains professional and collegial relationships for the purpose of student, staff or district growth.                                                                                                                                                                             ')where title like rtrim('PCC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher communicates with all parents and guardians about goals of instruction and student progress and uses multiple tools to communicate in a timely and positive manner. Teacher effectively engages in two-way forms of communication and is responsive to parent and guardian insights.             ')where title like rtrim('PCC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher maintains accurate and systematic student records. Teacher communicates student progress information to relevant individuals within the school community in a timely way, accurately, and in an organized manner, including both successes and challenges.                                       ')where title like rtrim('PCC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher supports and has solid understanding of school, district, and state initiatives. Teacher follows district policies and implements district curricula and policy. Teacher makes pacing adjustments as appropriate, to meet whole group needs without compromising an aligned curriculum.          ')where title like rtrim('PCC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher’s professional role toward adults and students is friendly, ethical, and professional and supports learning for all students, including the historically underserved. Teacher advocates for fair and equitable practices for all students.                                                       ')where title like rtrim('PCC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher frequently asks questions to probe and deepen students’ understanding or uncover misconceptions. Teacher assists students in clarifying their thinking with one another.                                                                                                                         ')where title like rtrim('SE1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher provides opportunities and strategies for students to take ownership of their learning. Some locus of control is with students in ways that support students’ learning.                                                                                                                          ')where title like rtrim('SE2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher expectations and strategies engage most students in work of high cognitive demand.                                                                                                                                                                                                               ')where title like rtrim('SE3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher uses strategies that capitalize and are based on learning needs of students – academic background, life experiences, culture and language of students – for the whole group and small groups of students.                                                                                        ')where title like rtrim('SE4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Teacher sets expectation and provides support for a variety of engagement strategies and structures that facilitate participation and meaning making by students. Most students have the opportunity to engage in quality talk.                                                                          ')where title like rtrim('SE5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl3Descriptor = rtrim('Student-to-student talk reflects knowledge and ways of thinking associated with the content. Students provide evidence to support their thinking.                                                                                                                                                        ')where title like rtrim('SE6  %') and belongsToDistrict = 'bcel'

update seRubricRow set pl4Descriptor = rtrim('Students consistently assess their own learning in relation to the success criteria and can determine where they are in connection to the learning target.                                                                                                                                                                                                                  ')where title like rtrim('A1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Assessment tasks are aligned with the learning targets and allow students to demonstrate complex understanding and/or skill related to the learning targets.                                                                                                                                                                                                                ')where title like rtrim('A2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher provides a variety of strategies for formative assessment that align with the learning target(s).                                                                                                                                                                                                                                                                   ')where title like rtrim('A3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher has an observable system and routines for recording formative assessment data, uses multiple sources and consistently uses the system for instructional purposes.                                                                                                                                                                                                   ')where title like rtrim('A4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Students consistently use assessment data to assess their own learning, determine learning goals and monitor progress over time.                                                                                                                                                                                                                                            ')where title like rtrim('A5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher uses formative assessment data to make in-the-moment instructional adjustments, modify future lessons and give targeted feedback aligned with the learning target to individual students.                                                                                                                                                                           ')where title like rtrim('A6   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('The physical environment is safe, and the arrangement supports student learning and the purpose of the lesson. Teacher and students use the physical arrangement for learning.                                                                                                                                                                                              ')where title like rtrim('CEC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('The resources, materials and technology in the classroom relate to the content or current unit studied, are accessible to all students and are intentionally used by both teacher and student to support learning. Students are familiar and comfortable with using the available resources.                                                                                ')where title like rtrim('CEC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Routines for discussion and collaborative work have been explicitly taught, are evident, and result in effective discourse related to the lesson purpose. Students independently use the routines during the lesson. Students are held accountable for their work, take ownership for their learning and support the learning of others.                                    ')where title like rtrim('CEC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('All available time is maximized in service of learning. Transitions are student-managed, efficient, and maximize instructional time.                                                                                                                                                                                                                                        ')where title like rtrim('CEC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher responds to student misbehavior by following classroom routines and building discipline procedures. Student behavior is appropriate. Students manage themselves, assist each other in managing behavior, or there is no student misbehavior.                                                                                                                        ')where title like rtrim('CEC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher and students demonstrate appropriate teacher-student and student-student relationships that foster students’ well-being and adapt to meet individual circumstances. Patterns of interaction between teacher and students and among students indicate that all are valued for their contributions. Teacher creates opportunities for students’ status to be elevated.')where title like rtrim('CEC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Classroom norms are evident and encourage risk taking, collaboration, respect for divergent thinking and students’ culture. Teacher and students refer to the norms and/or interactions consistently align with the norms. Students remind one another of the norms.                                                                                                        ')where title like rtrim('CEC7 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Instructional materials and tasks align with the purpose of the unit and lesson. Materials and tasks consistently align with student’s level of challenge.                                                                                                                                                                                                                  ')where title like rtrim('CP1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher consistently uses discipline-specific teaching approaches and strategies that develop students’ conceptual understanding.                                                                                                                                                                                                                                           ')where title like rtrim('CP2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Instruction is always consistent with pedagogical content knowledge and supports students in discipline-specific habits of thinking.                                                                                                                                                                                                                                        ')where title like rtrim('CP3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher demonstrates an in-depth understanding of how discipline-based concepts relate to or build upon one another. Teacher identifies and addresses student misconceptions that impact conceptual understanding over time.                                                                                                                                                ')where title like rtrim('CP4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher consistently uses strategies that differentiate for individual learning strengths and needs.                                                                                                                                                                                                                                                                        ')where title like rtrim('CP5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher provides scaffolds and structures that are clearly related to and support the development of the targeted concepts and/or skills. Students use scaffolds across tasks with similar demands.                                                                                                                                                                         ')where title like rtrim('CP6  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher consistently uses strategies for the purpose of gradually releasing responsibility to students to promote learning and independence. Students expect to be self-reliant.                                                                                                                                                                                            ')where title like rtrim('CP7  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('The lesson is based on grade level standards and the learning target(s) align to the standard. The lesson is consistently linked to broader purpose or a transferable skill.                                                                                                                                                                                                ')where title like rtrim('P1   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('The lesson is clearly linked to previous and future lessons. Lessons build on each other in ways that enhance student learning. Students understand how the lesson relates to previous lesson.                                                                                                                                                                              ')where title like rtrim('P2   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher bases the teaching point(s) on the learning needs – academic background, life experiences, culture and language – for groups of students and individual students.                                                                                                                                                                                                   ')where title like rtrim('P3   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher communicates the learning target(s) through verbal and visual strategies, checks for student understanding of what the target(s) are and references the target throughout instruction.                                                                                                                                                                              ')where title like rtrim('P4   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('The success criteria for the learning target(s) are clear to students. The performance tasks align to the success criteria. Students refer to success criteria and use them for improvement.                                                                                                                                                                                ')where title like rtrim('P5   %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher collaborates and engages in reflective inquiry with peers and administrators for the purpose of improving instructional practice, and student and teacher learning. Teacher occasionally leads collaborative work.                                                                                                                                                  ')where title like rtrim('PCC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher develops and sustains professional and collegial relationships for the purpose of student, staff or district growth. Teacher serves as a mentor for others’ growth and development.                                                                                                                                                                                 ')where title like rtrim('PCC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher communicates with all parents and guardians about goals of instruction and student progress using multiple tools to communicate in a timely and positive manner. Teacher considers the language needs of parents and guardians. Teacher effectively engages in two-way forms of communication and is responsive to parent and guardian insights.                    ')where title like rtrim('PCC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher maintains accurate and systematic student records. Teacher communicates student progress information to relevant individuals within the school community in a timely way. Teacher and student communicate accurately and positively about student successes and challenges.                                                                                         ')where title like rtrim('PCC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher supports and looks for opportunities to take on leadership roles in developing and implementing school, district, and state initiatives. Teacher follows district policies and implements district curricula and policy. Teacher makes pacing adjustments as appropriate to meet whole group and individual needs, without compromising an aligned curriculum.      ')where title like rtrim('PCC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher’s professional role toward adults and students is friendly, ethical, and professional and supports learning for all students, including the historically underserved. Teacher advocates for fair and equitable practices for all students. Teacher challenges adult attitudes and practices that may be harmful or demeaning to students.                           ')where title like rtrim('PCC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher frequently asks questions to probe and deepen students’ understanding or uncover misconceptions. Teacher assists students in clarifying and assessing their thinking with one another. Students question one another to probe for deeper thinking.                                                                                                                  ')where title like rtrim('SE1  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher consistently provides opportunities and strategies for students to take ownership of their learning. Most locus of control is with students in ways that support students’ learning.                                                                                                                                                                                ')where title like rtrim('SE2  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher expectations and strategies engage all students in work of high cognitive demand.                                                                                                                                                                                                                                                                                   ')where title like rtrim('SE3  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher uses strategies that capitalize and build upon learning needs of students – academic background, life experiences, culture and language of students – for the whole group, small groups of students and individual students.                                                                                                                                        ')where title like rtrim('SE4  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Teacher sets expectation and provides support for a variety of engagement strategies and structures that facilitate participation and meaning making by students. All students have the opportunity to engage in quality talk. Routines are often student-led.                                                                                                              ')where title like rtrim('SE5  %') and belongsToDistrict = 'bcel'
update seRubricRow set pl4Descriptor = rtrim('Student-to-student talk reflects knowledge and ways of thinking associated with the content. Students provide evidence to support their arguments and new ideas.                                                                                                                                                                                                            ')where title like rtrim('SE6  %') and belongsToDistrict = 'bcel'

update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A1   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A2   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A3   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A4   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A5   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('A6   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CEC7 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP1  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP2  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP3  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP4  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP5  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP6  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('CP7  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('Possible Teacher Observables: -A 6th grade teacher presents a lesson on the American Revolution. Content and skills are 5th grade standards.  - A 6th grade teacher presents a lesson on African geography that meets 6th grade standards. Lesson is not connected to a broader purpose such as how African geography is important to the current economics of the continent or how the skills learned will apply to a subsequent geography lesson.  There is no learning target.')where title like rtrim('P1   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('P2   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('P3   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('P4   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('P5   %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC1 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC2 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC3 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC4 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC5 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('PCC6 %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE1  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE2  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE3  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE4  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE5  %') and belongsToDistrict = 'bcel'
update seRubricRow set description = rtrim('                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ')where title like rtrim('SE6  %') and belongsToDistrict = 'bcel'


                                                                                   
INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential. ')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals rely on limited source or low-quality data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BCEL', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BCEL', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for whole classroom.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals rely on limited sources of data or low quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for individual students in collaboration with students and parents, and for whole classroom that align to school goals. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BCEL', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BCEL', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.1 Establish Student Growth Goals, Implement and Monitor Growth')
,rtrim('Does not collaborate or reluctantly collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Does not consistently collaborate with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, measures, to monitor growth and achievement during the year.')
,rtrim('Consistently and actively collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Leads other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
, 1, 'BCEL', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.2  Achievement of Student Growth Goal(s)')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time shows no evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show some evidence of growth for some students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show clear evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show evidence of high growth for all or nearly all students in the grade-level, subject matter or instructional team. ')
, 1, 'BCEL', '')


--update marzanno rows

update seRubricRow set title = '2.2: Organizing Students to Practice and Deepen Knowledge <br> The teacher helps students to practice and deepen their understanding of new knowledge. (Development scales with which to set teacher growth goals are available for specific elements of this component—see Appendix)'
where title like '2.2:%' and belongstodistrict = 'bmar'


update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '1.1: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '1.2: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '1.3: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '1.4: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not employ strategies designed to preview and introduce new knowledge in digestible chunks OR does so with significant errors or omissions.                                                                                            ') where belongstodistrict = 'bmar' and title like '2.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not employ strategies designed to practice skills and processes and critically analyze information OR does so with significant errors or omissions.                                                                                    ') where belongstodistrict = 'bmar' and title like '2.2: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '2.3: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '2.4: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '2.5: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not monitor student engagement and apply re-engagement strategies as necessary OR does so with significant errors or omissions.                                                                                                        ') where belongstodistrict = 'bmar' and title like '2.6: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not identify important academic vocabulary specific to the lesson or does so in a manner that does not reflect the critical content.                                                                                                   ') where belongstodistrict = 'bmar' and title like '2.7: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '2.8: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '3.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not know or understand the intervention system or does not use the intervention system to address student needs.                                                                                                                       ') where belongstodistrict = 'bmar' and title like '3.2: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not demonstrate adequate knowledge of the subject and/or the standards for the subject.                                                                                                                                                ') where belongstodistrict = 'bmar' and title like '4.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '4.2: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '5.1: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '5.2: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '5.3: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not apply consequences for not following rules and procedures.                                                                                                                                                                         ') where belongstodistrict = 'bmar' and title like '5.4: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not acknowledge adherence to rules and procedures.                                                                                                                                                                                     ') where belongstodistrict = 'bmar' and title like '5.5: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.                                                                                                                            ') where belongstodistrict = 'bmar' and title like '5.6: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not design instruction with clear alignment to learning targets (daily) and/or learning goals (longer term).                                                                                                                           ') where belongstodistrict = 'bmar' and title like '6.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher does not examine multiple data points with the intent of modifying instruction and assessment or does so with significant errors or omissions.                                                                                              ') where belongstodistrict = 'bmar' and title like '6.2: %'
update seRubricRow set pl1descriptor = rtrim ('When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '6.3: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '7.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '7.2: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '8.1: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes little or no attempt to follow established norms or collective commitments. The teacher’s behavior may be obstructing the functioning of the team/group.                                                                              ') where belongstodistrict = 'bmar' and title like '8.2: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '8.3: %'
update seRubricRow set pl1descriptor = rtrim ('The teacher makes no attempt to perform this activity, or the teacher attempts to perform this activity but does not actually complete or follow through with these attempts.                                                                           ') where belongstodistrict = 'bmar' and title like '8.4: %'

update seRubricRow set pl2descriptor = rtrim ('The teacher provides a  stated learning target (daily) and/or learning goal (longer term) but the learning goal is not accompanied by a scale or rubric that describes levels of performance.                                                                                                    ') where belongstodistrict = 'bmar' and title like '1.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher provides students with recognition of their current status but not their knowledge gain relative to the learning goal.                                                                                                                                                               ') where belongstodistrict = 'bmar' and title like '1.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher minimally uses students’ interests and background during interactions with students.                                                                                                                                                                                                 ') where belongstodistrict = 'bmar' and title like '1.3: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher minimally uses verbal and nonverbal behaviors that indicate value and respect for students, with particular attention to those typically underserved.                                                                                                                                ') where belongstodistrict = 'bmar' and title like '1.4: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher employs strategies designed to preview and introduce new knowledge in digestible chunks BUT does not monitor the extent to which strategies have their desired effect.                                                                                                               ') where belongstodistrict = 'bmar' and title like '2.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher employs strategies designed to practice skills and processes and critically analyze information BUT does not monitor the extent to which strategies have their desired effect.                                                                                                       ') where belongstodistrict = 'bmar' and title like '2.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher organizes students and acts as a guide and resource provider but students primarily engage in low level tasks.                                                                                                                                                                       ') where belongstodistrict = 'bmar' and title like '2.3: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher asks questions of all students with the same frequency and depth but does not monitor the quality of participation.                                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '2.4: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher is not consistent in probing all students’ incorrect answers.                                                                                                                                                                                                                        ') where belongstodistrict = 'bmar' and title like '2.5: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher monitors student engagement and applies re-engagement strategies as necessary BUT does not monitor the extent to which strategies have their desired effect.                                                                                                                         ') where belongstodistrict = 'bmar' and title like '2.6: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher identifies important academic vocabulary specific to the lesson and makes students aware of the meaning of these terms BUT does not monitor the extent to which students have internalized the meaning of these terms using their own background knowledge.                          ') where belongstodistrict = 'bmar' and title like '2.7: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher identifies specific strategies and behaviors on which to improve but does not select the strategies and behaviors that are most useful for his or her development.                                                                                                                   ') where belongstodistrict = 'bmar' and title like '2.8: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher organizes lessons within a unit so that students move from surface to deeper understanding of content, but does not require students to apply the content in authentic ways.                                                                                                         ') where belongstodistrict = 'bmar' and title like '3.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher identifies interventions that meet the needs of specific sub-populations (e.g., ELL, special education, and students who come from environments that offer little support for learning), but does not ensure that all identified students are adequately served by the interventions.') where belongstodistrict = 'bmar' and title like '3.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher demonstrates an acceptable but incomplete knowledge of the subject and/or the standards for the subject.                                                                                                                                                                             ') where belongstodistrict = 'bmar' and title like '4.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher identifies the available materials that can enhance student understanding but does not clearly identify or describe the manner in which they will be used.                                                                                                                           ') where belongstodistrict = 'bmar' and title like '4.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher organizes the physical layout of the classroom to ensure safety, facilitate movement, and focus on learning but the classroom layout addresses only minimal aspects of these issues.                                                                                                 ') where belongstodistrict = 'bmar' and title like '5.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher establishes and reviews expectations regarding rules and procedures.                                                                                                                                                                                                                 ') where belongstodistrict = 'bmar' and title like '5.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher demonstrates awareness of classroom environment.                                                                                                                                                                                                                                     ') where belongstodistrict = 'bmar' and title like '5.3: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher applies consequences for not following rules and procedures but does not do so in a consistent and fair manner.                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '5.4: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher acknowledges adherence to rules and procedures but does not do so a consistent and fair manner.                                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '5.5: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher behaves in an objective and controlled manner.                                                                                                                                                                                                                                       ') where belongstodistrict = 'bmar' and title like '5.6: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher designs instruction with assessments aligned to learning target (daily) and/or learning goal (longer term) but does not adapt those assessments to meet student learning needs.                                                                                                      ') where belongstodistrict = 'bmar' and title like '6.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher examines a few data points and makes minimal adjustments to instruction and assessment based on the information.                                                                                                                                                                     ') where belongstodistrict = 'bmar' and title like '6.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher facilitates tracking of student progress using a formative approach to assessment but does not monitor the extent to which this process enhances student learning.                                                                                                                   ') where belongstodistrict = 'bmar' and title like '6.3: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher attempts to communicate and collaborate with parents/guardians and school/community regarding courses, programs and school events relevant to the students’, but does not necessarily do so in a timely or clear manner.                                                             ') where belongstodistrict = 'bmar' and title like '7.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher communicates individual students’ progress to parents/guardians, but does not necessarily do so in a timely or clear manner.                                                                                                                                                         ') where belongstodistrict = 'bmar' and title like '7.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher seeks help and mentorship from colleagues regarding specific classroom strategies and/or mentors other teachers, but does not necessarily do so in a manner that enhances pedagogical skill.                                                                                         ') where belongstodistrict = 'bmar' and title like '8.1: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher attempts to follow established norms or commitments but does not comply with all norms and collective commitments.                                                                                                                                                                   ') where belongstodistrict = 'bmar' and title like '8.2: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher is aware of the district and school initiatives, but does not participate at a level consistent with his or her talents and availability.                                                                                                                                            ') where belongstodistrict = 'bmar' and title like '8.3: %'
update seRubricRow set pl2descriptor = rtrim ('The teacher develops a written professional growth and development plan but does not articulate clear goals and timelines. The teacher charts his or her progress on the professional growth and development plan using established goals and timelines but does not make adaptations as needed. ') where belongstodistrict = 'bmar' and title like '8.4: %'


update seRubricRow set pl3descriptor = rtrim ('The teacher provides a clearly stated learning target (daily) and/or learning goal (longer term). The learning goal is accompanied by a scale or rubric that describes levels of performance. Additionally, the teacher monitors students’ understanding of the learning target/goal and the levels of performance.                                                                          ') where belongstodistrict = 'bmar' and title like '1.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher provides students with recognition of their current status and their knowledge gain relative to the learning goal and monitors the extent to which students are motivated to enhance their status.                                                                                                                                                                               ') where belongstodistrict = 'bmar' and title like '1.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher uses students’ interests and background during interactions with students and monitors the sense of community in the classroom.                                                                                                                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '1.3: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher uses verbal and nonverbal behaviors that indicate value and respect for students, with particular attention to those typically underserved, and monitors the quality of relationships in the classroom.                                                                                                                                                                          ') where belongstodistrict = 'bmar' and title like '1.4: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher employs strategies designed to preview and introduce new knowledge in digestible chunks AND monitors the extent to which strategies have their desired effect, which includes: elaborating on critical information and summarizing it in linguistic and nonlinguistic ways.                                                                                                      ') where belongstodistrict = 'bmar' and title like '2.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher employs strategies designed to practice skills and processes and critically analyze information AND monitors the extent to which strategies have their desired effect, which includes: developing fluency with skills and processes, determining similarities and differences between important information, and determining the validity and structure of important information.') where belongstodistrict = 'bmar' and title like '2.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher organizes students and acts as a guide and resource provider as students engage in cognitively complex tasks and monitors the level to which students apply and transfer the new knowledge.                                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '2.3: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher asks questions of all students with the same frequency and depth and monitors the quality of participation.                                                                                                                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '2.4: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher probes all students’ incorrect answers and monitors the level and quality of the responses.                                                                                                                                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '2.5: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher monitors student engagement and applies re-engagement strategies as necessary AND monitors the extent to which strategies have their desired effect, which includes: enhanced energy and engagement and enhanced student participation in questioning activities and activities designed to analyze and review information.                                                      ') where belongstodistrict = 'bmar' and title like '2.6: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher identifies important academic vocabulary specific to the lesson and makes students aware of the meaning of these terms. Additionally, the teacher monitors the extent to which students have internalized the meaning of these terms using their own background knowledge.                                                                                                       ') where belongstodistrict = 'bmar' and title like '2.7: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher determines how effective a lesson or unit was in terms of enhancing student achievement and identifies causes of success or failure.                                                                                                                                                                                                                                             ') where belongstodistrict = 'bmar' and title like '2.8: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher organizes content in such a way that each new piece of information clearly builds on the previous piece, and students move from understanding to applying the content through authentic tasks.                                                                                                                                                                                   ') where belongstodistrict = 'bmar' and title like '3.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher identifies and effectively employs interventions that meet the needs of specific sub-populations (e.g., ELL, special education, and students who come from environments that offer little support for learning).                                                                                                                                                                 ') where belongstodistrict = 'bmar' and title like '3.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher demonstrates a comprehensive knowledge of the subject and the standards for the subject.                                                                                                                                                                                                                                                                                         ') where belongstodistrict = 'bmar' and title like '4.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher identifies the available materials that can enhance student understanding and the manner in which they will be used.                                                                                                                                                                                                                                                             ') where belongstodistrict = 'bmar' and title like '4.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher organizes the physical layout of the classroom to ensure safety, facilitate movement, and focus on learning and monitors the extent to which these activities enhance student learning.                                                                                                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher establishes and reviews expectations regarding rules and procedures and monitors the extent to which students understand the rules and procedures.                                                                                                                                                                                                                               ') where belongstodistrict = 'bmar' and title like '5.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher demonstrates awareness of classroom environment and monitors the effect on students’ behavior.                                                                                                                                                                                                                                                                                   ') where belongstodistrict = 'bmar' and title like '5.3: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher applies consequences for not following rules and procedures in a consistent and fair manner and monitors the extent to which rules and procedures are followed.                                                                                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '5.4: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher acknowledges adherence to rules and procedures in a consistent and fair manner and monitors the extent to which new actions affect students’ behavior.                                                                                                                                                                                                                           ') where belongstodistrict = 'bmar' and title like '5.5: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher behaves in an objective and controlled manner and monitors the effect on the classroom climate.                                                                                                                                                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '5.6: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher designs instruction with assessments aligned to clearly stated learning target (daily) and/or learning goal (longer term). Those assessments are adapted to meet student learning needs.                                                                                                                                                                                         ') where belongstodistrict = 'bmar' and title like '6.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher examines multiple data points and makes changes to instruction and assessment based on the information. Additionally the teacher monitors the extent to which the changes result in enhanced student learning.                                                                                                                                                                   ') where belongstodistrict = 'bmar' and title like '6.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher facilitates tracking of student progress using a formative approach to assessment and monitors the extent to which this process enhances student learning.                                                                                                                                                                                                                       ') where belongstodistrict = 'bmar' and title like '6.3: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher communicates and collaborates with parents/guardians and school/community regarding courses, programs and school events relevant to the students’ in a timely and professional manner.                                                                                                                                                                                           ') where belongstodistrict = 'bmar' and title like '7.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher communicates individual students’ progress to parents/guardians in a timely and professional manner.                                                                                                                                                                                                                                                                             ') where belongstodistrict = 'bmar' and title like '7.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher seeks help and mentorship from colleagues regarding specific classroom strategies and/or mentors other teachers in such a manner as to enhance pedagogical skill.                                                                                                                                                                                                                ') where belongstodistrict = 'bmar' and title like '8.1: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher follows established norms and collective commitments, contributing to the overall effectiveness of the team.                                                                                                                                                                                                                                                                     ') where belongstodistrict = 'bmar' and title like '8.2: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher participates in district and school initiatives at a level consistent with his or her talents and availability.                                                                                                                                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '8.3: %'
update seRubricRow set pl3descriptor = rtrim ('The teacher develops a written professional growth and development plan with goals and timelines, charts his or her progress, and makes adaptations as needed.                                                                                                                                                                                                                               ') where belongstodistrict = 'bmar' and title like '8.4: %'


update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '1.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '1.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '1.3: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '1.4: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.3: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.4: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.5: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.6: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '2.7: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others identify areas of pedagogical strength and weakness.                                                                                                                                                                        ') where belongstodistrict = 'bmar' and title like '2.8: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others scaffold lessons and units that progress toward a deep understanding and transfer of content.                                                                                                                               ') where belongstodistrict = 'bmar' and title like '3.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others employ interventions that meet the needs of specific sub-populations (e.g., ELL, special education, and students who come from environments that offer little support for learning).                                        ') where belongstodistrict = 'bmar' and title like '3.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others understand the subject and/or the standards for the subject.                                                                                                                                                                ') where belongstodistrict = 'bmar' and title like '4.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others plan and prepare for the use of available materials, including technology.                                                                                                                                                  ') where belongstodistrict = 'bmar' and title like '4.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.3: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.4: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.5: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '5.6: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies designed to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                 ') where belongstodistrict = 'bmar' and title like '6.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies designed to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                 ') where belongstodistrict = 'bmar' and title like '6.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.                                                                                                          ') where belongstodistrict = 'bmar' and title like '6.3: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others communicate and collaborate with parents/guardians and school/community regarding courses, programs and school events relevant to the students’.                                                                            ') where belongstodistrict = 'bmar' and title like '7.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others communicate individual student progress to parents/guardians in a timely and professional manner.                                                                                                                           ') where belongstodistrict = 'bmar' and title like '7.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in mentoring others in such a way as to enhance their pedagogical skill.                                                                                                                                                                      ') where belongstodistrict = 'bmar' and title like '8.1: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher consistently models established norms and collective commitments. The teacher is a recognized leader in facilitating the team/group in resolving conflict for effective functioning.                                                                                 ') where belongstodistrict = 'bmar' and title like '8.2: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others be aware of and participate in district and school initiatives.                                                                                                                                                             ') where belongstodistrict = 'bmar' and title like '8.3: %'
update seRubricRow set pl4descriptor = rtrim ('The teacher is a recognized leader in helping others develop professional growth and development plans.                                                                                                                                                                          ') where belongstodistrict = 'bmar' and title like '8.4: %'  

                                                              
INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential. ')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals rely on limited source or low-quality data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BMAR', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 3.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BMAR', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.1 Establish Student Growth Goal(s)')
,rtrim('Does not establish student growth goals or establishes inappropriate goals for whole classroom.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals rely on limited sources of data or low quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for whole classroom.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
,rtrim('Establishes appropriate student growth goals for individual students in collaboration with students and parents, and for whole classroom that align to school goals. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.')
, 1, 'BMAR', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 6.2 Achievement of Student Growth Goal(s)')
,rtrim('Growth or achievement data from at least two points in time shows no evidence of growth for most students.')
,rtrim('Growth or achievement data from at least two points in time show some evidence of growth for some students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.')
,rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly students.')
, 1, 'BMAR', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.1 Establish Student Growth Goals, Implement and Monitor Growth')
,rtrim('Does not collaborate or reluctantly collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Does not consistently collaborate with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, measures, to monitor growth and achievement during the year.')
,rtrim('Consistently and actively collaborates with other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
,rtrim('Leads other grade-level, subject matter or instructional team members to establish goals, to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.')
, 1, 'BMAR', '')

INSERT seRubricRow (title,  PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, IsStateAligned, BelongsToDistrict, description) VALUES (
 rtrim('SG 8.2  Achievement of Student Growth Goal(s)')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time shows no evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show some evidence of growth for some students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show clear evidence of growth for most students in the grade-level, subject matter or instructional team.')
,rtrim('If relevant and appropriate data are available, growth and/or achievement data from at least two points in time show evidence of high growth for all or nearly all students in the grade-level, subject matter or instructional team. ')
, 1, 'BMAR', '')


--link up all the sg rows all at once
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (402, 1241	,3 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (402, 1242	,4 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (405, 1243	,4 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (405, 1244	,5 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (407, 1245	,4 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (407, 1246	,5 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (414, 1247	,6 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (414, 1248	,7 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (417, 1249	,7 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (417, 1250	,8 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (419, 1251	,5 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (419, 1252	,6 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (428, 1253	,3 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (428, 1254	,4 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (431, 1255	,9 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (431, 1256	,10)
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (433, 1257	,5 )
insert seRubricRowFrameworkNode (frameworkNodeID, rubricRowId, sequence) values (433, 1258	,6 )
*/
/******************end patches to 2291*********************/
/******************begin patches to 2304*********************/
--try something new!!! this patch for schema autogenerated by the redgate tools
--need to add column into prototypes databse for student growth alignment...
/*
Run this script on:

        SYDNEY.stateeval_proto    -  This database will be modified

to synchronize it with:

        (local).stateeval_proto

You are recommended to back up your database before running this script

Script created by SQL Compare version 10.0.0 from Red Gate Software Ltd at 8/12/2012 10:09:15 PM

*/
/*
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[SERubricRow]'
GO
ALTER TABLE [dbo].[SERubricRow] ADD
[IsStudentGrowthAligned] [bit] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFrameworkRows]'
GO
EXEC sp_refreshview N'[dbo].[vFrameworkRows]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFrameworkNodeRubricRow]'
GO
EXEC sp_refreshview N'[dbo].[vFrameworkNodeRubricRow]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
UPDATE dbo.SERubricRow SET IsStudentGrowthAligned = 0
UPDATE dbo.SERubricRow SET IsStudentGrowthAligned = 1 WHERE title LIKE 'sg %'
*/
/******************end patches to 2304*********************/

/******************Begin patches to 2308 (had to revert to this version********/
/*
--tracker id...  34386375


CREATE TABLE #rrId(rubricRowId BIGINT)
INSERT #rrID (rubricRowID)
SELECT rubricrowID FROM serubricrow WHERE title LIKE 'sg 8.2%'

DELETE dbo.SERubricRowFrameworkNode WHERE rubricrowID IN 
(SELECT rubricRowID FROM #rrid)

DELETE dbo.SERubricRow WHERE rubricRowID IN 
(SELECT rubricRowID FROM #rrid)
*/
/***************
/******************begin patches to 2334*********************/
--tracker id ... 34462741 ... danielson pl1 = pl4
update serubricrow set pl1descriptor = rtrim('<p>The classroom culture is characterized by a lack of teacher or student commitment to learning and/or little or no investment of student energy into the task at hand. Hard work is not expected or valued.  </p> Medium or low expectations for student achievement are the norm, with high expectations for learning reserved for only one or two students.                            ') where title like '2b: Establ%'
update serubricrow set pl1descriptor = rtrim('<p>The instructional purpose of the lesson is unclear to students, and the directions and procedures are confusing.</p><p> The teacher’s explanation of the content contains major errors. </p><p> The teacher’s spoken or written language contains errors of grammar or syntax.</p> The teacher’s vocabulary is inappropriate, vague, or used incorrectly, leaving students confused.    ') where title like '3a: Commun%'
update serubricrow set pl1descriptor = rtrim('<p>The learning tasks and activities, materials, resources, instructional groups and technology are poorly aligned with the instructional outcomes or require only rote responses. </p><p>The pace of the lesson is too slow or too rushed. </p>Few students are intellectually engaged or interested.                                                                                     ') where title like '3c: Engagi%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s questions are of low cognitive challenge, require single correct responses, and are asked in rapid succession. </p><p>Interaction between teacher and students is predominantly recitation style, with the teacher mediating all questions and answers.</p> A few students dominate the discussion.                                                                           ') where title like '3b: Using %'
update serubricrow set pl1descriptor = rtrim('<p>Teacher does not know whether a lesson was effective or achieved its instructional outcomes, or he/she profoundly misjudges the success of a lesson. </p>Teacher has no suggestions for how a lesson could be improved.                                                                                                                                                                 ') where title like '4a: Reflec%'
update serubricrow set pl1descriptor = rtrim('Teacher demonstrates little or no understanding of how students learn and little knowledge of students’ backgrounds, cultures, skills, language proficiency, interests, and special needs and does not seek such understanding.                                                                                                                                                            ') where title like '1b: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher adheres to the instruction plan in spite of evidence of poor student understanding or lack of interest.</p> Teacher ignores student questions; when students experience difficulty, the teacher blames the students or their home environment.                                                                                                                                  ') where title like '3e: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>In planning and practice, teacher makes content errors or does not correct errors made by students.</p> <p>Teacher’s plans and practice display little understanding of prerequisite relationships important to student’s learning of the content.</p> Teacher displays little or no understanding of the range of pedagogical approaches suitable to student’s learning of the content.') where title like '1a: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>Outcomes represent low expectations for students and lack of rigor, and not all of them reflect important learning in the discipline.</p><p>Outcomes are stated as activities rather than as student learning. </p>Outcomes reflect only one type of learning and only one discipline or strand and are suitable for only some students.                                                ') where title like '1c: Settin%'
update serubricrow set pl1descriptor = rtrim('Teacher is unaware of school or district resources for classroom use, for the expansion of his or her own knowledge, or for students.                                                                                                                                                                                                                                                      ') where title like '1d: Demons%'
update serubricrow set pl1descriptor = rtrim('<p>The series of learning experiences is poorly aligned with the instructional outcomes and does not represent a coherent structure.</p> The activities are not designed to engage students in active intellectual activity and have unrealistic time allocations. Instructional groups do not support the instructional outcomes and offer no variety.                                    ') where title like '1e: Design%'
update serubricrow set pl1descriptor = rtrim('<p>Patterns of classroom interactions, both between the teacher and students and among students, are mostly negative, inappropriate, or insensitive to students’ ages, cultural backgrounds, and developmental levels. Interactions are characterized by sarcasm, put-downs, or conflict. </p>Teacher does not deal with disrespectful behavior.                                           ') where title like '2a: Creati%'
update serubricrow set pl1descriptor = rtrim('<p>Much instructional time is lost through inefficient classroom routines and procedures. </p><p>There is little or no evidence that the teacher is managing instructional groups, transitions, and/or the handling of materials and supplies effectively. </p>There is little evidence that students know or follow established routines.                                                 ') where title like '2c: Managi%'
update serubricrow set pl1descriptor = rtrim('<p>There appear to be no established standards of conduct and little or no teacher monitoring of student behavior.</p><p> Students challenge the standards of conduct. </p>Response to students’ misbehavior is repressive or disrespectful of student dignity.                                                                                                                            ') where title like '2d: Managi%'
update serubricrow set pl1descriptor = rtrim('<p>The physical environment is unsafe, or many students don’t have access to learning resources. </p>There is poor coordination between the lesson activities and the arrangement of furniture and resources, including computer technology.                                                                                                                                               ') where title like '2e: Organi%'
update serubricrow set pl1descriptor = rtrim('<p>Assessment procedures are not congruent with instructional outcomes; the proposed approach contains no criteria or standards.</p> Teacher has no plan to incorporate formative assessment in the lesson or unit nor any plan to use assessment results in designing future instruction.                                                                                                 ') where title like '1f: Design%'
update serubricrow set pl1descriptor = rtrim('<p>There is little or no assessment or monitoring of student learning; feedback is absent or of poor quality.</p> Students do not appear to be aware of the assessment criteria and do not engage in self-assessment.                                                                                                                                                                      ') where title like '3d: Using %'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s system for maintaining information on student completion of assignments and student progress in learning is nonexistent or in disarray. </p>Teacher’s records for noninstructional activities are in disarray, resulting in errors and confusion.                                                                                                                             ') where title like '4b: Mainta%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher communication with families— about the instructional program, about individual students—is sporadic or culturally inappropriate.</p> Teacher makes no attempt to engage families in the instructional program.                                                                                                                                                                  ') where title like '4c: Commun%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher’s relationships with colleagues are negative or self-serving.</p><p> Teacher avoids participation in a professional culture of inquiry, resisting opportunities to become involved. </p>Teacher avoids becoming involved in school events or school and district projects.                                                                                                      ') where title like '4d: Partic%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher engages in no professional development activities to enhance knowledge or skill.</p><p> Teacher resists feedback on teaching performance from either supervisors or more experienced colleagues. </p>Teacher makes no effort to share knowledge with others or to assume professional responsibilities.                                                                         ') where title like '4e: Growin%'
update serubricrow set pl1descriptor = rtrim('<p>Teacher displays dishonesty in interactions with colleagues, students, and the public.</p><p> Teacher is not alert to students’ needs and contributes to school practices that result in some students’ being ill served by the school.</p> Teacher makes decisions and recommendations based on self-serving interests. Teacher does not comply with school and district regulations.  ') where title like '4f: Showin%'

/******************end patches to 2334*********************/
/******************begin patches to 2340*********************/

--tracker id...  34386375


CREATE TABLE #rrId(rubricRowId BIGINT)
INSERT #rrID (rubricRowID)
SELECT rubricrowID FROM serubricrow WHERE title LIKE 'sg 8.2%'

DELETE dbo.SERubricRowFrameworkNode WHERE rubricrowID IN 
(SELECT rubricRowID FROM #rrid)

DELETE dbo.SERubricRow WHERE rubricRowID IN 
(SELECT rubricRowID FROM #rrid)



--bug34529771_SyncFrameworkText_From_8_17_xlsx

update seframeworknode set title = rtrim ('Creating a school culture that promotes the ongoing improvement of learning and teaching for students and staff.                                                 ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C1' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Providing for school safety.                                                                                                                                     ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C2' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Leading development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements.') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C3' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district learning goals.                             ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C4' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Monitoring, assisting and evaluating effective instruction and assessment practices.                                                                             ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C5' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Managing both staff and fiscal resources to support student achievement and legal responsibilities.                                                              ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C6' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Partnering with the school community to promote student learning.                                                                                                ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C7' and districtCode = 'bprin'
update seframeworknode set title = rtrim ('Demonstrating commitment to closing the achievement gap.                                                                                                         ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C8' and districtCode = 'bprin'


update seRubricRow set pl4Descriptor = rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.') where title like'sg 3.2%'
update seRubricRow set pl4Descriptor = rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.') where title like'sg 6.2%'

*/
/******************end patches to 2340*********************/
/******************begin patches to 2372*******************/
/*
UPDATE dbo.SERubricRow SET IsStudentGrowthAligned=1 
WHERE BelongsToDistrict = 'bprin' and
(title LIKE '3.4%'
OR title LIKE '5.2%'
OR title LIKE '8.3%')
*/
/******************end patches to 2372*******************/
/******************begin patches to 2378*******************/

/*
update seRubricRow set title = rtrim ('2a: Creating an Environment of Respect and Rapport') where BelongsToDistrict= 'bdan' and title = '2a: Creating an Environment of Respect and Rapport'
update seRubricRow set title = rtrim ('2b: Establishing a Culture for Learning           ') where BelongsToDistrict= 'bdan' and title = '2b: Establishing a Culture for Learning'
update seRubricRow set title = rtrim ('2c: Managing Classroom Procedures                 ') where BelongsToDistrict= 'bdan' and title = '2c: Managing Classroom Procedures'
update seRubricRow set title = rtrim ('2e: Organizing Physical Space                     ') where BelongsToDistrict= 'bdan' and title = '2e: Organizing Physical Space'
update seRubricRow set title = rtrim ('3c: Engaging Students in Learning                 ') where BelongsToDistrict= 'bdan' and title = '3c: Engaging Students in Learning'
update seRubricRow set title = rtrim ('3e: Demonstrating Flexibility and Responsiveness  ') where BelongsToDistrict= 'bdan' and title = '3e: Demonstrating Flexibility and Responsiveness'

update seFrameworkNode set shortname ='A'   where frameworkId = 37 and  shortname = 'a' 
update seFrameworkNode set shortname ='CEC' where frameworkId = 37 and  shortname = 'cec'
update seFrameworkNode set shortname ='CP'  where frameworkId = 37 and  shortname = 'cp' 
update seFrameworkNode set shortname ='P'   where frameworkId = 37 and  shortname = 'p'  
update seFrameworkNode set shortname ='PCC' where frameworkId = 37 and  shortname = 'pcc'
update seFrameworkNode set shortname ='SE'  where frameworkId = 37 and  shortname = 'se' 
*/
/******************end patches to 2378*******************/
/******************begin patches to 2393*******************/
--proposed marzano ifw view
/*DECLARE @fwid bigint

INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('MAR, IFW View',  'BMAR' ,2013, 2, 3, 1, NULL, 0, 1)

SELECT @fwid =SCOPE_IDENTITY()



insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 1: Routine                         '), rtrim('D1-R'), '', 1, 1)
insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 1: Content                         '), rtrim('D1-C'), '', 2, 1)
insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 1: Enacted on the Spot             '), rtrim('D1-E'), '', 3, 1)
insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 2: Planning and Preparing          '), rtrim('D2  '), '', 4, 1)
insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 3: Reflecting on Teaching          '), rtrim('D3  '), '', 5, 1)
insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode) values(@fwid, rtrim('Domain 4: Collegiality and Professionalism'), rtrim('D4  '), '', 6, 1)

INSERT seRubricRowFrameworkNode (frameworkNodeID, sequence, rubricrowID)
SELECT 
--fn.title, rowtitle, rr.title, marshort, fn.Sequence AS nseq, 
fn.FrameworkNodeID, ml.marSeq AS rseq, rr.RubricRowID
FROM seframeworknode fn
JOIN stateeval_prepro.dbo.marlatest ml on fn.shortname = ml.marshort
JOIN seRubricrow rr ON rr.title = ml.Rowtitle
WHERE FrameworkID=@fwid ORDER BY marshort, rseq

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@fwid,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@fwid,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@fwid,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@fwid,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')
*/                                                                                     


/******************end patches to 2393*******************/
/******************begin patches to 2421*******************/
/*
UPDATE dbo.seRubricRow SET title = REPLACE(title, 'Low Expectancy Students', 'Typicall Undeserved Students')
WHERE BelongsToDistrict = 'bmar' AND (title like '1.4%' OR title like '2.4%' OR title LIKE '2.5%')
*/
/******************end patches to 2421*******************/

/******************begin patches to 2427*******************/
/*

UPDATE dbo.seRubricRow SET title = REPLACE(title, 'Typicall Und', 'Typically Und')
WHERE BelongsToDistrict = 'bmar' AND (title like '1.4%' OR title like '2.4%' OR title LIKE '2.5%')

*/
/******************end patches to 2427*******************/

/******************begin patches to 2449*******************/
--bug 35410405
/*
UPDATE seFrameworkNode SET title = 'Using multiple student data elements to modify instruction and improve student learning.'
 WHERE title = 'Using multiple student data elements to modify instruction and improve student learning'


UPDATE seFrameworkNode SET title = 'Providing clear and intentional focus on subject matter content and curriculum.'
 WHERE title = 'Providing clear and intentional focus on subject matter content and curriculum'
*/
/******************begin patches to 2449*******************/

/******************begin patches to version ??? we are confused here!!!*******************/
/* first have to run schema change; look at se db updates, bug 41776257*/
/*
update seRubricRow set title='1.1: Providing Clear Learning Goals and Scales (Rubrics)'                                                 ,TitleTooltip='The teacher communicates high expectations for learning by developing, aligning, and communicating clear daily learning targets and/or longer-term learning goals (grade-level standards) with rubrics for the goals.'                  where belongsToDistrict ='bmar' and title like '1.1: Providing Clear Learning Goals and Scales (Rubrics)%'                                             
update seRubricRow set title='1.2: Celebrating Success'                                                                                 ,TitleTooltip='The teacher celebrates student success relative to the learning targets and/or the learning goals.'                                                                                                                                     where belongsToDistrict ='bmar' and title like '1.2: Celebrating Success%'                                                                             
update seRubricRow set title='1.3: Understanding Students’ Interests and Backgrounds'                                                   ,TitleTooltip='The teacher builds positive relationships with students by understanding students’ interests and background.'                                                                                                                           where belongsToDistrict ='bmar' and title like '1.3: Understanding Students’ Interests and Backgrounds%'                                               
update seRubricRow set title='1.4: Demonstrating Value and Respect for Typically Underserved Students'                                  ,TitleTooltip='The teacher demonstrates value and respect for all, including typically underserved students.'                                                                                                                                          where belongsToDistrict ='bmar' and title like '1.4: Demonstrating Value and Respect for Typically Underserved Students%'                              
update seRubricRow set title='2.1: Interacting with New Knowledge'                                                                      ,TitleTooltip='The teacher helps students effectively interact with new knowledge. (Development scales with which to set teacher growth goals are available for specific elements of this component—see Appendix)'                                     where belongsToDistrict ='bmar' and title like '2.1: Interacting with New Knowledge%'                                                                  
update seRubricRow set title='2.2: Organizing Students to Practice and Deepen Knowledge'                                                ,TitleTooltip='The teacher helps students to practice and deepen their understanding of new knowledge. (Development scales with which to set teacher growth goals are available for specific elements of this component—see Appendix)'                 where belongsToDistrict ='bmar' and title like '2.2: Organizing Students to Practice and Deepen Knowledge%'                                            
update seRubricRow set title='2.3: Organizing Students for Cognitively Complex Tasks'                                                   ,TitleTooltip='The teacher provides resources and guidance and organizes students to engage in cognitively complex tasks involving application and transfer of new knowledge.'                                                                         where belongsToDistrict ='bmar' and title like '2.3: Organizing Students for Cognitively Complex Tasks%'                                               
update seRubricRow set title='2.4: Asking Questions of Typically Underserved Students'                                                  ,TitleTooltip='The teacher asks questions of typically underserved students with the same frequency and depth as other students.'                                                                                                                      where belongsToDistrict ='bmar' and title like '2.4: Asking Questions of Typically Underserved Students%'                                              
update seRubricRow set title='2.5: Probing Incorrect Answers with Typically Underserved Students'                                       ,TitleTooltip='The teacher probes typically underserved students’ incorrect answers in the same manner as other students’ incorrect answers'                                                                                                           where belongsToDistrict ='bmar' and title like '2.5: Probing Incorrect Answers with Typically Underserved Students%'                                   
update seRubricRow set title='2.6: Noticing When Students Are Not Engaged'                                                              ,TitleTooltip='The teacher uses various methods to engage students. (Development scales with which to set teacher growth goals are available for specific elements of this component—see Appendix)'                                                    where belongsToDistrict ='bmar' and title like '2.6: Noticing When Students Are Not Engaged%'                                                          
update seRubricRow set title='2.7: Using and Applying Academic Vocabulary'                                                              ,TitleTooltip='The teacher identifies appropriate academic vocabulary aligned to the learning targets and uses various strategies for student acquisition.'                                                                                            where belongsToDistrict ='bmar' and title like '2.7: Using and Applying Academic Vocabulary%'                                                          
update seRubricRow set title='2.8: Evaluating Effectiveness of Individual Lessons and Units'                                            ,TitleTooltip='The teacher reflects on and evaluates the effectiveness of instructional performance to identify areas of pedagogical strength and weakness.'                                                                                           where belongsToDistrict ='bmar' and title like '2.8: Evaluating Effectiveness of Individual Lessons and Units%'                                        
update seRubricRow set title='3.1: Effective Scaffolding of Information Within a Lesson'                                                ,TitleTooltip='The teacher plans and prepares for effective scaffolding of information within lessons and units that progresses toward a deep understanding and transfer of content.'                                                                  where belongsToDistrict ='bmar' and title like '3.1: Effective Scaffolding of Information Within a Lesson%'                                            
update seRubricRow set title='3.2: Planning and Preparing for the Needs of All Students'                                                ,TitleTooltip='The teacher uses data to plan and provide interventions that meet individual student learning needs, including ELL, special education, and students who come from home environments that offer little support for schooling.'           where belongsToDistrict ='bmar' and title like '3.2: Planning and Preparing for the Needs of All Students%'                                            
update seRubricRow set title='4.1: Attention to Established Content Standards'                                                          ,TitleTooltip='The teacher demonstrates a comprehensive understanding of the subject taught and the standards for the subject.'                                                                                                                        where belongsToDistrict ='bmar' and title like '4.1: Attention to Established Content Standards%'                                                      
update seRubricRow set title='4.2: Use of Available Resources and Technology'                                                           ,TitleTooltip='The teacher plans and prepares for the use of available materials, including technology.'                                                                                                                                               where belongsToDistrict ='bmar' and title like '4.2: Use of Available Resources and Technology%'                                                       
update seRubricRow set title='5.1: Organizing the Physical Layout of the Classroom'                                                     ,TitleTooltip='The teacher organizes a safe physical layout of the classroom to facilitate movement and focus on learning.'                                                                                                                            where belongsToDistrict ='bmar' and title like '5.1: Organizing the Physical Layout of the Classroom%'                                                 
update seRubricRow set title='5.2: Reviewing Expectations to Rules and Procedures'                                                      ,TitleTooltip='The teacher reviews expectations regarding rules and procedures to ensure their effective execution.'                                                                                                                                   where belongsToDistrict ='bmar' and title like '5.2: Reviewing Expectations to Rules and Procedures%'                                                  
update seRubricRow set title='5.3: Demonstrating “Withiness”'                                                                           ,TitleTooltip='The teacher demonstrates awareness of the classroom environment at all times (withitness).'                                                                                                                                             where belongsToDistrict ='bmar' and title like '5.3: Demonstrating “Withiness”%'                                                                       
update seRubricRow set title='5.4: Applying Consequences for Lack of Adherence to Rules and Procedures'                                 ,TitleTooltip='The teacher applies consequences for lack of adherence to rules and procedures.'                                                                                                                                                        where belongsToDistrict ='bmar' and title like '5.4: Applying Consequences for Lack of Adherence to Rules and Procedures%'                             
update seRubricRow set title='5.5: Acknowledging Adherence to Rules and Procedures'                                                     ,TitleTooltip='The teacher acknowledges adherence to rules and procedures.'                                                                                                                                                                            where belongsToDistrict ='bmar' and title like '5.5: Acknowledging Adherence to Rules and Procedures%'                                                 
update seRubricRow set title='5.6: Displaying Objectivity and Control'                                                                  ,TitleTooltip='The teacher builds positive relationships with students by displaying objectivity and control.'                                                                                                                                         where belongsToDistrict ='bmar' and title like '5.6: Displaying Objectivity and Control%'                                                              
update seRubricRow set title='6.1: Designing Instruction Aligned to Assessment'                                                         ,TitleTooltip='The teacher designs instruction aligned to assessments that impact student learning'                                                                                                                                                    where belongsToDistrict ='bmar' and title like '6.1: Designing Instruction Aligned to Assessment%'                                                     
update seRubricRow set title='6.2: Using Multiple Data Elements'                                                                        ,TitleTooltip='The teacher uses multiple data elements to modify instruction and assessments.'                                                                                                                                                         where belongsToDistrict ='bmar' and title like '6.2: Using Multiple Data Elements%'                                                                    
update seRubricRow set title='6.3: Tracking Student Progress'                                                                           ,TitleTooltip='The teacher provides opportunities for students to self-reflect and track progress toward learning goals.'                                                                                                                              where belongsToDistrict ='bmar' and title like '6.3: Tracking Student Progress%'                                                                       
update seRubricRow set title='7.1: Promoting Positive Interactions about Students and Parents – Courses, Programs and School Events'    ,TitleTooltip='The teacher actively communicates and collaborates with parents/guardians and school/community regarding courses, programs, and school events.'                                                                                         where belongsToDistrict ='bmar' and title like '7.1: Promoting Positive Interactions about Students and Parents – Courses, Programs and School Events%'
update seRubricRow set title='7.2: Promoting Positive Interactions about Students and Parents – Timeliness and Professionalism'         ,TitleTooltip='The teacher communicates individual student progress to parents/guardians in a timely and professional manner.'                                                                                                                         where belongsToDistrict ='bmar' and title like '7.2: Promoting Positive Interactions about Students and Parents – Timeliness and Professionalism%'     
update seRubricRow set title='8.1: Seeking Mentorship for Areas of Need or Interest'                                                    ,TitleTooltip='The teacher collaborates with colleagues about student learning and instructional practices by seeking mentorship for areas of need or interest, and/or by mentoring other teachers through the sharing of ideas and strategies.'       where belongsToDistrict ='bmar' and title like '8.1: Seeking Mentorship for Areas of Need or Interest%'                                                
update seRubricRow set title='8.2: Promoting Positive Interactions with Colleagues'                                                     ,TitleTooltip='The teacher displays dependability through active participation.'                                                                                                                                                                       where belongsToDistrict ='bmar' and title like '8.2: Promoting Positive Interactions with Colleagues%' 
update seRubricRow set title='8.3: Participating in District and School Initiatives'                                                    ,TitleTooltip='The teacher participates in district and school initiatives.'                                                                                                                                                                           where belongsToDistrict ='bmar' and title like '8.3: Participating in District and School Initiatives%'                                                
update seRubricRow set title='8.4: Monitoring Progress Relative to the Professional Growth and Development Plan'                        ,TitleTooltip='The teacher pursues professional development based on his/her written growth and development plan and monitors progress relative to that plan.'                                                                                         where belongsToDistrict ='bmar' and title like '8.4: Monitoring Progress Relative to the Professional Growth and Development Plan%'                    
*/
/******************end patches to 41776261*******************/


/* begin patches to *just before* version 2987... and on through 2988 ****/
/*
--Insert MarPrin
--select * from SEFramework where Name like '%thur%'
DECLARE @marstate BIGINT
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Mar, Prin StateView', 'BMARPR',2013, 3, 5, 1, NULL, 0, 1)
SELECT @marState = SCOPE_IDENTITY()

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT DISTINCT @marState, NULL, critTitle, critShortName,'', critNum, 1 
FROM stateeval_prepro.dbo.marprin
ORDER BY critNum

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor, Description)
SELECT CONVERT(VARCHAR(1), critnum) + CONVERT(VARCHAR(1), sequence)+title, 1, 'mrprn',pl1, pl2, pl3, pl4 , ''
FROM StateEval_PrePro.dbo.MarPrin
ORDER BY  CONVERT(VARCHAR(1), critnum) + CONVERT(VARCHAR(1), sequence)+title


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence  )      
SELECT fn.FrameworkNodeID, rr.RubricRowID, CONVERT(INT, substring(rr.title, 2, 1))
FROM seFrameworkNode fn
JOIN seRubricRow rr ON SUBSTRING(rr.title,1,1) = fn.sequence
WHERE fn.frameworkID = @marState AND rr.BelongsToDistrict='mrprn'


insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)
SELECT @marstate,  performanceLevelID, shortname, fullname, description FROM dbo.SEFrameworkPerformanceLevel
WHERE frameworkId = 39 ORDER BY PerformanceLevelID

UPDATE seRubricRow SET title = SUBSTRING(title,3, 400) WHERE belongstodistrict='mrprn'
*/
/* end patches to *just before* version 2987... and on through just before 2988 ****/

/* begin patches version 2989... principal rr-fn was confused, so have to relink ****/

/*

declare @seq1  bigint, @fn1  bigint, @rr1  bigint
declare @seq2  bigint, @fn2  bigint, @rr2  bigint
declare @seq3  bigint, @fn3  bigint, @rr3  bigint
declare @seq4  bigint, @fn4  bigint, @rr4  bigint
declare @seq5  bigint, @fn5  bigint, @rr5  bigint
declare @seq6  bigint, @fn6  bigint, @rr6  bigint
declare @seq7  bigint, @fn7  bigint, @rr7  bigint
declare @seq8  bigint, @fn8  bigint, @rr8  bigint
declare @seq9  bigint,               @rr9  bigint
declare @seq10 bigint,               @rr10 bigint
declare @seq11 bigint,               @rr11 bigint
declare @seq12 bigint,               @rr12 bigint
declare @seq13 bigint,               @rr13 bigint
declare @seq14 bigint,               @rr14 bigint
declare @seq15 bigint,               @rr15 bigint
declare @seq16 bigint,               @rr16 bigint
declare @seq17 bigint,               @rr17 bigint
declare @seq18 bigint,               @rr18 bigint
declare @seq19 bigint,               @rr19 bigint
declare @seq20 bigint,               @rr20 bigint
declare @seq21 bigint,               @rr21 bigint
declare @seq22 bigint,               @rr22 bigint
declare @seq23 bigint,               @rr23 bigint
declare @seq24 bigint,               @rr24 bigint

--get rid of trailing white space
update seframeworknode set shortname = 'C1' where frameworkid = 42 and shortname like 'c1%'
update seframeworknode set shortname = 'C2' where frameworkid = 42 and shortname like 'c2%'
update seframeworknode set shortname = 'C3' where frameworkid = 42 and shortname like 'c3%'
update seframeworknode set shortname = 'C4' where frameworkid = 42 and shortname like 'c4%'
update seframeworknode set shortname = 'C5' where frameworkid = 42 and shortname like 'c5%'
update seframeworknode set shortname = 'C6' where frameworkid = 42 and shortname like 'c6%'
update seframeworknode set shortname = 'C7' where frameworkid = 42 and shortname like 'c7%'
update seframeworknode set shortname = 'C8' where frameworkid = 42 and shortname like 'c8%'





select @seq1  = 1, @rr1  = rubricRowID from seRubricRow where title like 'II (1): The%'
select @seq2  = 2, @rr2  = rubricRowID from seRubricRow where title like 'IV (2): The%'
select @seq3  = 3, @rr3  = rubricRowID from seRubricRow where title like 'IV (4): The%'
select @seq4  = 4, @rr4  = rubricRowID from seRubricRow where title like 'V (1): The %'
select @seq5  = 5, @rr5  = rubricRowID from seRubricRow where title like 'V (2): The %'
select @seq6  = 6, @rr6  = rubricRowID from seRubricRow where title like 'V (6): The %'
select @seq7  = 1, @rr7  = rubricRowID from seRubricRow where title like 'V (3): The %'
select @seq8  = 2, @rr8  = rubricRowID from seRubricRow where title like 'V (4): The %'
select @seq9  = 1, @rr9  = rubricRowID from seRubricRow where title like 'I (3): The %'
select @seq10 = 2, @rr10 = rubricRowID from seRubricRow where title like 'I (4): The %'
select @seq11 = 1, @rr11 = rubricRowID from seRubricRow where title like 'III (1): Th%'
select @seq12 = 2, @rr12 = rubricRowID from seRubricRow where title like 'III (2): Th%'
select @seq13 = 3, @rr13 = rubricRowID from seRubricRow where title like 'III (3): Th%'
select @seq14 = 4, @rr14 = rubricRowID from seRubricRow where title like 'IV (3): The%'
select @seq15 = 1, @rr15 = rubricRowID from seRubricRow where title like 'II (2): The%'
select @seq16 = 2, @rr16 = rubricRowID from seRubricRow where title like 'II (3): The%'
select @seq17 = 3, @rr17 = rubricRowID from seRubricRow where title like 'II (4): The%'
select @seq18 = 4, @rr18 = rubricRowID from seRubricRow where title like 'IV (1): The%'
select @seq19 = 1, @rr19 = rubricRowID from seRubricRow where title like 'II (5): The%'
select @seq20 = 2, @rr20 = rubricRowID from seRubricRow where title like 'V (5): The %'
select @seq21 = 1, @rr21 = rubricRowID from seRubricRow where title like 'IV (5): The%'
select @seq22 = 1, @rr22 = rubricRowID from seRubricRow where title like 'I (1): The %'
select @seq23 = 2, @rr23 = rubricRowID from seRubricRow where title like 'I (2): The %'
select @seq24 = 3, @rr24 = rubricRowID from seRubricRow where title like 'I (5): The %'

select @fn1  =frameworkNodeID from seFrameworkNode where shortname = 'C1' and FrameworkId = 42
select @fn2  =frameworkNodeID from seFrameworkNode where shortname = 'C2' and FrameworkId = 42
select @fn3  =frameworkNodeID from seFrameworkNode where shortname = 'C3' and FrameworkId = 42
select @fn4  =frameworkNodeID from seFrameworkNode where shortname = 'C4' and FrameworkId = 42
select @fn5  =frameworkNodeID from seFrameworkNode where shortname = 'C5' and FrameworkId = 42
select @fn6  =frameworkNodeID from seFrameworkNode where shortname = 'C6' and FrameworkId = 42
select @fn7  =frameworkNodeID from seFrameworkNode where shortname = 'C7' and FrameworkId = 42
select @fn8  =frameworkNodeID from seFrameworkNode where shortname = 'C8' and FrameworkId = 42

delete seRubricRowFrameworkNode where frameworkNodeId in  
(@fn1 ,@fn2 ,@fn3 ,@fn4 ,@fn5 ,@fn6,@fn7,@fn8)


insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr1   , @seq1 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr2   , @seq2 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr3   , @seq3 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr4   , @seq4 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr5   , @seq5 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn1 , @rr6   , @seq6 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn2 , @rr7   , @seq7 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn2 , @rr8   , @seq8 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn3 , @rr9   , @seq9 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn3 , @rr10  , @seq10)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn4 , @rr11  , @seq11)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn4 , @rr12  , @seq12)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn4 , @rr13  , @seq13)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn4 , @rr14  , @seq14)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn5 , @rr15  , @seq15)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn5 , @rr16  , @seq16)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn5 , @rr17  , @seq17)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn5 , @rr18  , @seq18)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn6 , @rr19  , @seq19)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn6 , @rr20  , @seq20)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn7 , @rr21  , @seq21)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn8 , @rr22  , @seq22)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn8 , @rr23  , @seq23)
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn8 , @rr24  , @seq24)

/* end patches version 2989... principal rr-fn was confused, so have to relink ****/


*/
/* begin patches version 3011... ****/

/*
update SERubricRow set Title='SG 3.4 Assists staff to use data to guide, modify and improve classroom teaching and learning' where Title='3.4 Assists staff to use data to guide, modify and improve classroom teaching and learning'
update SERubricRow set Title='SG 5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness' where Title='5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness'
update SERubricRow set Title='SG 8.3 Provides evidence of growth in student learning' where Title='8.3 Provides evidence of growth in student learning'
*/
/* end patches version 3011... ****/

/**************** begin patch to version 3027...  hack in MarPrincipal IFW View after the fact for north mason... *******************/


/*
DECLARE @MarPrIfw bigint
INSERT seFramework 
(Name, description,DistrictCode, SchoolYear, FrameworkTypeID,IFWTypeID, IsProtoTYpe, HasBeenModified, HasBeenApproved) values
('Mar, Prin IFW View', '', 'BMARPR', 2013, 4, 2, 1, 0, 1)
SELECT @marPrIFW = SCOPE_IDENTITY()

DECLARE @d1 bigint insert SeFrameworkNode(frameworkID, title, shortname, description, sequence, isLeafNode) values (@MarPrIFW, 'Domain I: A Data-Driven Focus on Student Achievement', 'I',  '', 1,1)  select @d1 = scope_identity()
DECLARE @d2 bigint insert SeFrameworkNode(frameworkID, title, shortname, description, sequence, isLeafNode) values (@MarPrIFW, 'Domain II: Continuous Improvement of Instruction'    , 'II', '', 2,1)  select @d2 = scope_identity()
DECLARE @d3 bigint insert SeFrameworkNode(frameworkID, title, shortname, description, sequence, isLeafNode) values (@MarPrIFW, 'Domain III: A Guaranteed and Viable Curriculum'      , 'III','', 3,1)  select @d3 = scope_identity()
DECLARE @d4 bigint insert SeFrameworkNode(frameworkID, title, shortname, description, sequence, isLeafNode) values (@MarPrIFW, 'Domain IV: Cooperation and Collaboration'            , 'IV', '', 4,1)  select @d4 = scope_identity()
DECLARE @d5 bigint insert SeFrameworkNode(frameworkID, title, shortname, description, sequence, isLeafNode) values (@MarPrIFW, 'Domain V: School Climate'                            , 'V',  '', 5,1)  select @d5 = scope_identity()


INSERT dbo.SERubricRowFrameworkNode( FrameworkNodeID , RubricRowID , Sequence) SELECT @d1, rubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 4, 1)) FROM dbo.vFrameworkRows WHERE frameworkid = 42 AND rowtitle LIKE 'i %'ORDER BY rowtitle
INSERT dbo.SERubricRowFrameworkNode( FrameworkNodeID , RubricRowID , Sequence) SELECT @d2, rubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 5, 1)) FROM dbo.vFrameworkRows WHERE frameworkid = 42 AND rowtitle LIKE 'iI %'ORDER BY rowtitle
INSERT dbo.SERubricRowFrameworkNode( FrameworkNodeID , RubricRowID , Sequence) SELECT @d3, rubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 6, 1)) FROM dbo.vFrameworkRows WHERE frameworkid = 42 AND rowtitle LIKE 'iII %'ORDER BY rowtitle
INSERT dbo.SERubricRowFrameworkNode( FrameworkNodeID , RubricRowID , Sequence) SELECT @d4, rubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 5, 1)) FROM dbo.vFrameworkRows WHERE frameworkid = 42 AND rowtitle LIKE 'iv %'ORDER BY rowtitle
INSERT dbo.SERubricRowFrameworkNode( FrameworkNodeID , RubricRowID , Sequence) SELECT @d5, rubricRowID, CONVERT(INT, SUBSTRING(rowtitle, 4, 1)) FROM dbo.vFrameworkRows WHERE frameworkid = 42 AND rowtitle LIKE 'v %'ORDER BY rowtitle

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)
SELECT @marPrIFw, PerformanceLevelID, Shortname, FullName, Description 
FROM dbo.SEFrameworkPerformanceLevel WHERE frameworkid = 42

*/
/*******end patch to version 3027 ******/

/*******begin patch to version 3040... now they want the student growth rubrics in the marpr IFW ******/
/*
INSERT seRubricRow (title, description, PL1Descriptor,PL2Descriptor, PL3Descriptor,PL4Descriptor ,isStateAligned, BelongsToDistrict, IsStudentGrowthAligned)
SELECT title, description, PL1Descriptor,PL2Descriptor, PL3Descriptor,PL4Descriptor, isStateAligned, 'mrprn', IsStudentGrowthAligned
FROM serubricrow WHERE title LIKE 'sg%' AND BelongsToDistrict = 'bprin'

DECLARE @fn3 BIGINT, @fn5 BIGINT, @fn8 BIGINT, @rr3 BIGINT, @rr5 BIGINT, @rr8 bigint

select @fn3  =frameworkNodeID from seFrameworkNode where shortname = 'C3' and FrameworkId = 42
select @fn5  =frameworkNodeID from seFrameworkNode where shortname = 'C5' and FrameworkId = 42
select @fn8  =frameworkNodeID from seFrameworkNode where shortname = 'C8' and FrameworkId = 42

SELECT @rr3 = rubricrowid   FROM serubricrow WHERE BelongsToDistrict = 'mrprn' AND title LIKE 'sg 3%'
SELECT @rr5 = rubricrowid   FROM serubricrow WHERE BelongsToDistrict = 'mrprn' AND title LIKE 'sg 5%'
SELECT @rr8 = rubricrowid   FROM serubricrow WHERE BelongsToDistrict = 'mrprn' AND title LIKE 'sg 8%'
                                
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn3 , @rr3   , 6 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn5 , @rr5   , 6 )
insert seRubricRowFrameworkNode(frameworkNodeID, rubricRowID, sequence) values (@fn8 , @rr8   , 6 )
*/
/************ end patch to version 3040  *********************************/

/************ end patch to version 3042  *********************************/
/* --anne needs a shortname on the rubric row to enable row-by-row hi lighting
ALTER TABLE seRubricRow ADD Shortname VARCHAR(50) NULL
*/
/*
--now hydrate same...

CREATE TABLE #RR(NodeShortName VARCHAR(20), RubricRowID BIGINT, Title VARCHAR(MAX), DerivedFromName VARCHAR(200))
TRUNCATE TABLE #rr
INSERT INTO #RR(NodeShortName, RubricRowID, Title, DerivedFromName)
SELECT DISTINCT n.ShortName, rr.RubricRowID, rr.Title, f.name
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode n ON rrfn.FrameworkNodeID=n.FrameworkNodeID
  JOIN seframework f ON n.FrameworkID=f.FrameworkID
 WHERE f.Name IN ('Mar, StateView', 'DAN, StateView', 'CEL, StateView', 'Prin, StateView', 'Mar, Prin StateView', 'Wenatchee PR', 'Wenatchee      PS')
 -- WHERE f.DerivedFromFrameworkName IN ('Mar, Prin, StateView')
 
  UPDATE dbo.SERubricRow 
     SET ShortName=
     CASE 
     WHEN rr.DerivedFromName = 'Mar, StateView' OR 
		  rr.DerivedFromName = 'Prin, StateView' THEN
		CASE 
	 WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		ELSE SUBSTRING(rr.Title, 1, 3)
		END
     WHEN rr.DerivedFromName IN( 'Wenatchee PR', 'Wenatchee      PS') THEN
		CASE 
		WHEN rr.Title LIKE '6.1A%' OR rr.Title LIKE '6.1B%' THEN SUBSTRING(rr.Title, 1, 4)
		ELSE SUBSTRING(rr.Title, 1, 3)
		END
     WHEN rr.DerivedFromName = 'DAN, StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		ELSE SUBSTRING(rr.Title, 1, 2)
		END
      WHEN rr.DerivedFromName = 'Mar, Prin StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		-- case order is important
		WHEN rr.Title LIKE ('IV%') THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE ('III%') THEN SUBSTRING(rr.Title, 1, 7)
		WHEN rr.Title LIKE ('II%') THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE ('I%') THEN SUBSTRING(rr.Title, 1, 5)
		WHEN rr.Title LIKE ('V%') THEN SUBSTRING(rr.Title, 1, 5)
	END
    WHEN rr.DerivedFromName = 'CEL, StateView' THEN
		CASE 
		WHEN rr.Title LIKE 'SG%' THEN SUBSTRING(rr.Title, 1, 6)
		WHEN rr.Title LIKE 'CE%' THEN SUBSTRING(rr.Title, 1, 4)
		WHEN rr.Title LIKE 'SE%' THEN SUBSTRING(rr.Title, 1, 3)
		WHEN rr.Title LIKE 'CP%' THEN SUBSTRING(rr.Title, 1, 3)
		WHEN rr.Title LIKE 'PCC%' THEN SUBSTRING(rr.Title, 1, 4)
		ELSE SUBSTRING(rr.Title, 1, 2)
		END	 ELSE '|' + rr.DerivedFromName + '|'
	 END
    FROM #RR rr
    WHERE SERubricRow.RubricRowID=rr.RubricRowID
    
    
    --check...
    --select * from vframeworkRows fr
	--	join seframework f on f.frameworkID = fr.frameworkID
	--	 where rrshortname is null and f.schoolyear = 2013
	*/
/************ end patch to version 3042  *********************************/
/************ begin patch to version 3159  *********************************/
/*
Run this script on:

        (local).stateeval_Proto_baseline    -  This database will be modified

to synchronize it with:

        (local).stateeval_proto

You are recommended to back up your database before running this script

Script created by SQL Compare version 10.0.0 from Red Gate Software Ltd at 5/1/2013 9:22:58 AM

*/
/*
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[SEFramework]'
GO
ALTER TABLE [dbo].[SEFramework] ADD
[StickyID] [uniqueidentifier] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFramework]'
GO
EXEC sp_refreshview N'[dbo].[vFramework]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[SEFrameworkNode]'
GO
ALTER TABLE [dbo].[SEFrameworkNode] ADD
[StickyID] [uniqueidentifier] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFrameworkNode]'
GO
EXEC sp_refreshview N'[dbo].[vFrameworkNode]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [dbo].[SERubricRow]'
GO
ALTER TABLE [dbo].[SERubricRow] ADD
[StickyID] [uniqueidentifier] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFrameworkRows]'
GO
EXEC sp_refreshview N'[dbo].[vFrameworkRows]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [dbo].[vFrameworkNodeRubricRow]'
GO
EXEC sp_refreshview N'[dbo].[vFrameworkNodeRubricRow]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
-- now hydrate...
UPDATE seFramework SET stickyId = NEWID()
UPDATE seFrameworkNode SET stickyId = NEWID()
UPDATE seRubricRow SET stickyId = NEWID()
*/
/************ end patch to version 3159  *********************************/

/*
new 2014 frameworks...


/*
0) refresh the xferid fields
a) insert the framework record for the frameworks, and then change the dates to 2014
b) insert the frameworknode records
c) insert the rubric row records
d) select xferids of all the linkd fn/rr for 2013 frameworks into temp table
e) remove xferids for all rr, fn for !2014 frameworks
f) link up fn/rr according to xfer id mapping
*/

INSERT  seframework
        ( name ,
          districtcode ,
          schoolyear ,
          frameworktypeID ,
          ifwtypeid ,
          isPrototype ,
          derivedfromframeworkID ,
          HasBeenModified ,
          HasBeenApproved ,
          xferid,
          StickyID
        )
        SELECT  name ,
                districtcode ,
                2014 ,
                frameworktypeid ,
                ifwtypeid ,
                isprototype ,
                derivedfromframeworkid ,
                hasbeenmodified ,
                hasbeenapproved ,
                xferid,
                StickyID
        FROM    seframework
        WHERE   schoolyear = 2013

UPDATE  serubricrow
SET     XferID = NEWID()
UPDATE  seframeworknode
SET     xferid = NEWID()

CREATE TABLE #t
    (
      rrGuid UNIQUEIDENTIFIER ,
      fnGuid UNIQUEIDENTIFIER ,
      rubricRowID BIGINT ,
      frameworkNodeID BIGINT ,
      sequence INT
    )
INSERT  #t
        ( rubricRowID ,
          frameworkNodeID ,
          rrGuid ,
          fnGUid ,
          sequence
        )
        SELECT  rrfn.rubricRowID ,
                rrfn.frameworkNodeid ,
                rr.xferID ,
                fn.xferid ,
                rrfn.Sequence
        FROM    dbo.SERubricRowFrameworkNode rrfn
                JOIN seRubricRow rr ON rr.RubricRowID = rrfn.RubricRowID
                JOIN seFrameworkNode fn ON fn.FrameworkNodeid = rrfn.FrameworkNodeID
                JOIN seFramework fw ON fw.FrameworkID = fn.FrameworkID
        WHERE   fw.SchoolYear = 2013

DECLARE @maxRR BIGINT, @maxFn BIGINT
SELECT @maxRR = MAX(rubricrowid) FROM dbo.SERubricRow
SELECT @maxFN = MAX(frameworkNodeID) FROM dbo.SEFrameworkNode

INSERT  dbo.SERubricRow
        ( Title ,
          Description ,
          PL1Descriptor ,
          PL2Descriptor ,
          PL3Descriptor ,
          PL4Descriptor ,
          ev1 ,
          ev2 ,
          ev3 ,
          ev4 ,
          XferID ,
          IsStateAligned ,
          BelongsToDistrict ,
          IsStudentGrowthAligned ,
          TitleToolTip ,
          Shortname,
          StickyID
        )
        SELECT  Title ,
                rr.Description ,
                PL1Descriptor ,
                PL2Descriptor ,
                PL3Descriptor ,
                PL4Descriptor ,
                ev1 ,
                ev2 ,
                ev3 ,
                ev4 ,
                rr.XferID ,
                IsStateAligned ,
                rr.BelongsToDistrict ,
                rr.IsStudentGrowthAligned ,
                TitleToolTip ,
                rr.Shortname,
                rr.StickyID
        FROM    dbo.SERubricRow rr
                JOIN dbo.vFrameworkRows fr ON rr.RubricRowID = fr.RubricRowID
                JOIN dbo.SEFramework fw ON fw.frameworkid = fr.frameworkId
        WHERE   fw.schoolyear = 2013
        
       
INSERT  dbo.SEFrameworkNode
        ( FrameworkID ,
          ParentNodeID ,
          Title ,
          ShortName ,
          Description ,
          Sequence ,
          IsLeafNode ,
          XferID ,
          StickyID
        )
        SELECT  fn.FrameworkID + 10 ,
                ParentNodeID ,
                Title ,
                fn.ShortName ,
                fn.Description ,
                fn.Sequence ,
                IsLeafNode ,
                fn.XferID ,
                fn.StickyID
        FROM    dbo.SEFrameworkNode fn             
                JOIN dbo.SEFramework fw ON fw.frameworkid = fn.frameworkId
        WHERE   fw.schoolyear = 2013

UPDATE  serubricrow
SET     xferid = NULL
WHERE   rubricrowid <= @maxRR
UPDATE  seFrameworkNode
SET     xferid = NULL
WHERE   FrameworkNodeID <= @maxFN

UPDATE  #t
SET     rubricRowID = rr.rubricRowID
FROM    #t t
        JOIN seRubricRow rr ON rr.XferID = t.rrGuid
        
UPDATE  #t
SET     frameworkNodeID = fn.FrameworkNodeID
FROM    #t t
        JOIN dbo.SEFrameworkNode fn ON fn.XferID = t.fnGuid

INSERT  dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
        )
        SELECT  frameworkNodeID ,
                rubricRowID ,
                sequence
        FROM    #t
        
        
INSERT dbo.SEFrameworkPerformanceLevel
        ( FrameworkID ,
          PerformanceLevelID ,
          Shortname ,
          FullName ,
          Description
        )
        
        SELECT
        fw.FrameworkID  + 10,
          fpl.PerformanceLevelID ,
          fpl.Shortname ,
          fpl.FullName ,
          fpl.Description
          FROM dbo.SEFrameworkPerformanceLevel fpl
          JOIN dbo.SEFramework fw ON fw.frameworkID = fpl.FrameworkID
          WHERE fw.SchoolYear = 2013



*/

/* begin patch to version 3490 */

/*
UPDATE serubricrow 
SET title = '5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness'
   ,shortname='5.2'
 WHERE title = 'SG 5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness' 
 AND rubricrowid = 1509
UPDATE serubricrow SET BelongsToDistrict = 'BPRIN' WHERE title LIKE 'SG%' AND BelongsToDistrict IS null
*/

/* end patch to version 3490 */

/* begin patch of version... 3627*/

/*
UPDATE  seRubricRow
SET     title = rSource.title ,
        description = rSource.Description ,
        PL1Descriptor = rSource.PL1Descriptor ,
        PL2Descriptor = rSource.PL2Descriptor ,
        PL3Descriptor = rSource.PL3Descriptor ,
        PL4Descriptor = rSource.PL4Descriptor ,
        ShortName = rSource.shortName ,
        StickyID = NEWID()
FROM    seRubricRow rDest ,
        ( SELECT    *
          FROM      seRubricRow
        ) AS rSource
WHERE   rDest.RubricRowId = 1584
        AND rSource.RubricRowid = 1587
        
UPDATE  seRubricRow
SET     title = rSource.title ,
        description = rSource.Description ,
        PL1Descriptor = rSource.PL1Descriptor ,
        PL2Descriptor = rSource.PL2Descriptor ,
        PL3Descriptor = rSource.PL3Descriptor ,
        PL4Descriptor = rSource.PL4Descriptor ,
        ShortName = rSource.shortName ,
        StickyID = NEWID()
FROM    seRubricRow rDest ,
        ( SELECT    *
          FROM      seRubricRow
        ) AS rSource
WHERE   rDest.RubricRowId = 1585
        AND rSource.RubricRowid = 1588
        
UPDATE  seRubricRow
SET     title = rSource.title ,
        description = rSource.Description ,
        PL1Descriptor = rSource.PL1Descriptor ,
        PL2Descriptor = rSource.PL2Descriptor ,
        PL3Descriptor = rSource.PL3Descriptor ,
        PL4Descriptor = rSource.PL4Descriptor ,
        ShortName = rSource.shortName
        
FROM    seRubricRow rDest ,
        ( SELECT    *
          FROM      seRubricRow
        ) AS rSource
WHERE   rDest.RubricRowId = 1586
        AND rSource.RubricRowid = 1520
*/
/* end patch of version... 3627*/

/* begin patch of version... 3660*/

/*
UPDATE dbo.SERubricRow
SET shortname = REPLACE(shortname, '.5', ''),
title = REPLACE (title, '.5', '') 
WHERE belongstodistrict = 'mrprn' AND shortname LIKE 'sg%'
AND rubricrowid IN (1584, 1585, 1586)

UPDATE dbo.SERubricRow
SET shortname = REPLACE(shortname, '.3', ''),
title = REPLACE (title, '.3', '') 
WHERE belongstodistrict = 'mrprn' AND shortname LIKE 'sg%'
AND rubricrowid IN (1584, 1585, 1586)
*/
/* end patch of version... 3660*/
/* begin patch 3767 */
/*
INSERT  dbo.SEFramework
        ( Name ,
          Description ,
          DistrictCode ,
          SchoolYear ,
          FrameworkTypeID ,
          IFWTypeID ,
          IsPrototype ,
          DerivedFromFrameworkId ,
          HasBeenModified ,
          HasBeenApproved ,
          XferID ,
          StickyID
        )
        SELECT  Name ,
                Description ,
                DistrictCode ,
                2015 ,
                FrameworkTypeID ,
                IFWTypeID ,
                IsPrototype ,
                DerivedFromFrameworkId ,
                HasBeenModified ,
                HasBeenApproved ,
                XferId ,
                StickyID
        FROM    seframework
        WHERE   schoolyear = 2014
        ORDER BY frameworkID


INSERT  dbo.SEFrameworkPerformanceLevel
        ( FrameworkID ,
          PerformanceLevelID ,
          Shortname ,
          FullName ,
          Description
        )
        SELECT  FrameworkID + 10 ,
                PerformanceLevelID ,
                Shortname ,
                FullName ,
                Description
        FROM    dbo.SEFrameworkPerformanceLevel
        WHERE   frameworkid > 43
        ORDER BY SEFrameworkPerformanceLevelID



INSERT  dbo.SEFrameworkNode
        ( FrameworkID ,
          ParentNodeID ,
          Title ,
          ShortName ,
          Description ,
          Sequence ,
          IsLeafNode ,
          XferID ,
          StickyID
        )
        SELECT  FrameworkID + 10 ,
                ParentNodeID ,
                Title ,
                ShortName ,
                Description ,
                Sequence ,
                IsLeafNode ,
                XferId ,
                StickyID
        FROM    seFrameworkNode
        WHERE   FrameworkId BETWEEN 44 AND 53
        ORDER BY FrameworkNodeID

INSERT  dbo.SERubricRow
        ( Title ,
          Description ,
          PL1Descriptor ,
          PL2Descriptor ,
          PL3Descriptor ,
          PL4Descriptor ,
          ev1 ,
          ev2 ,
          ev3 ,
          ev4 ,
          XferID ,
          IsStateAligned ,
          BelongsToDistrict ,
          IsStudentGrowthAligned ,
          TitleToolTip ,
          Shortname ,
          StickyID
        )
        SELECT DISTINCT
                Title ,
                Description ,
                PL1Descriptor ,
                PL2Descriptor ,
                PL3Descriptor ,
                PL4Descriptor ,
                ev1 ,
                ev2 ,
                ev3 ,
                ev4 ,
                XferID ,
                IsStateAligned ,
                BelongsToDistrict ,
                IsStudentGrowthAligned ,
                TitleToolTip ,
                Shortname ,
                StickyID
        FROM    seRubricRow rr
                JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.RubricRowID = rr.RubricRowID
        WHERE   rr.rubricrowid IN (
                SELECT  rubricrowid
                FROM    dbo.SERubricRowFrameworknode
                WHERE   frameworknodeid BETWEEN 469 AND 537 )  


CREATE TABLE #xLink
    (
      fnX UNIQUEIDENTIFIER ,
      rrX UNIQUEIDENTIFIER ,
      seq INT ,
      fnId BIGINT ,
      rrid BIGINT ,
      fwId BIGINT
    )
INSERT  #xlink
        ( fnX ,
          rrX ,
          seq ,
          fwid
        )
        SELECT  fn.XferID ,
                rr.xferid ,
                rrfn.Sequence ,
                fw.frameworkid
        FROM    seRubricRow rr
                JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID = rrfn.RubricRowID
                JOIN dbo.SEFrameworkNode fn ON fn.FrameworkNodeID = rrfn.frameworkNodeID
                JOIN dbo.SEFramework fw ON fw.FrameworkID = fn.FrameworkID
        WHERE   fw.SchoolYear = 2014
        ORDER BY fw.frameworkid ,
                fn.frameworkNodeid ,
                rrfn.sequence

UPDATE  #xlink
SET     fnId = fn.frameworkNodeid
FROM    seFrameworknode fn
        JOIN #xlink x ON x.fnX = fn.XferID
WHERE   FrameworkID > 53

UPDATE  #xlink
SET     rrid = rr.rubricRowId
FROM    seRubricRow rr
        JOIN #xlink x ON x.rrX = rr.XferID
WHERE   RubricRowID > 1588
	
INSERT  dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
	    )
        SELECT  fnId ,
                rrId ,
                seq
        FROM    #xlink
*/
/* end patch 3767 */

/*I'm patching a little differently; this file is getting just too big....
  at 4898, we needed a patch to repair the formatting of the danielson 2016
  framework.  this is in the patch in updates called.... "FixParagraphFOrmatting.sql"
  The patch is there, rather than here.
  
*/