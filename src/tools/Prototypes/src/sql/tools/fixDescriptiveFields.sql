/*select f.name, fn.frameworkNodeID, dn.districtName, f.frameworkID 
, name, shortname, title, fn.description, fn.sequence 
from SEFrameworkNode fn
join SEFramework f on f.FrameworkID = fn.FrameworkID
left outer join  stateeval.dbo.vDistrictName dn on dn.districtCode = f.DistrictCode
--where  Name like '% _i' and fn.FrameworkID = 6
order by fn.Sequence

select f.name, f.FrameworkID, fn.ParentNodeID,fn.Title, fn.description, fn.sequence 
from SEFrameworkNode fn
join SEFramework f on f.FrameworkID = fn.FrameworkID
left outer join  stateeval.dbo.vDistrictName dn on dn.districtCode = f.DistrictCode
where  Name like '% ps' and fn.FrameworkID = 6
order by fn.parentNodeID, fn.Sequence, frameworkID

select MAX(len(description)) from SEFrameworkNode

select * from SEFramework  where  Name like '% ps'

*/

update seframeworkNode set Title = description 
where frameworkId in (1, 3, 9, 11, 13, 15, 16, 17, 18)

update SEFrameworkNode set Title = 'Communicating and collaborating with parents and school community'
where frameworknodeid=47


update seFrameworkNode set Title ='Centering instruction on high expectations for student achievement'                                                 where shortname ='c1' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Demonstrating effective teaching practices'                                                                         where shortname ='c2' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Recognizing individual student learning needs and developing strategies to address those needs'                     where shortname ='c3' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Providing clear and intentional focus on subject matter content and curriculum'                                     where shortname ='c4' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Fostering and managing a safe, positive learning environment'                                                       where shortname ='c5' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Using multiple student data elements to modify instruction and improve student learning'                            where shortname ='c6' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Communicating and collaborating with parents and school community'                                                  where shortname ='c7' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seFrameworkNode set Title ='Exhibiting collaborative and collegial practices focused on improving instructional practice and student learning'  where shortname ='c8' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)


update seframeworkNode set description = rtrim('  The certificated classroom teacher demonstrates the foundational expectation that all students can and will attain a high level of personal and academic achievement.                                                                                                                      ') where frameworkNodeID =  73
update seframeworkNode set description = rtrim('  The certificated classroom teacher''s instruction demonstrates the ability to create and implement focused (research based) lessons that measurably improved student learning, maximize efficiency and foster a high level of student engagement.                                          ') where frameworkNodeID =  74
update seframeworkNode set description = rtrim('  The certificated classroom teacher promotes the learning needs, interests, questions and concerns of students and utilizes these interests in planning learning activities. The certificated classroom teacher designs classroom activities which further the success of each student.     ') where frameworkNodeID =  75
update seframeworkNode set description = rtrim('  The certificated classroom teacher demonstrates fluency with standards and content in developing and communicating clear learning targets.                                                                                                                                                 ') where frameworkNodeID =  76
update seframeworkNode set description = rtrim('  The certificated classroom teacher fosters and manages relationships that support respect and rapport in the classroom.                                                                                                                                                                    ') where frameworkNodeID =  77
update seframeworkNode set description = rtrim('  The certificated classroom teacher analyzes the results of multiple data elements (i.e. formative, summative and other measures) to inform instruction and determine which strategies, materials and resources will improve student achievement.                                           ') where frameworkNodeID =  78
update seframeworkNode set description = rtrim('  The certificated classroom teacher proactively communicates to all educational stakeholders in an ethical and professional (timely, supportive, systematic, meaningful, respectful) manner.                                                                                                ') where frameworkNodeID =  79
update seframeworkNode set description = rtrim('  The certificated classroom teacher values and participates regularly in a wide range of collaborative and collegial work for the benefit of improving instructional practice and student learning.                                                                                         ') where frameworkNodeID =  80


update seframeworkNode set description = rtrim('  The teacher sets high expectations and challenges each student by asking questions of all students with the same frequency and depth and by probing incorrect answers of all students in the same manner.                                                                                                   ') where frameworkNodeID =  89
update seframeworkNode set description = rtrim('  The teacher helps students effectively interact with, practice and deepen their understanding of, generate and test hypotheses about new knowledge through various methods to engage students.                                                                                                              ') where frameworkNodeID =  90
update seframeworkNode set description = rtrim('  The teacher has knowledge to design instruction for individual student learning needs and provides interventions to meet those needs.                                                                                                                                                                       ') where frameworkNodeID =  91
update seframeworkNode set description = rtrim('  The teacher has a comprehensive understanding of the subject(s) and standards taught and skillfully uses the adopted curriculum while developing and communicating clear learning targets/goals to students.                                                                                                ') where frameworkNodeID =  92
update seframeworkNode set description = rtrim('  The teacher fosters and manages a safe, positive learning environment by managing physical space, creating clear and consistent expectations, monitoring and responding to student behavior, and building positive relationships.                                                                           ') where frameworkNodeID =  93
update seframeworkNode set description = rtrim('  The teacher uses multiple data elements to guide students in self-reflection and goal setting, to modify instruction, and to design and modify appropriate student assessments; also, the teacher can show that the students in his/her classroom have made growth and/or met course or grade-level standard') where frameworkNodeID =  94
update seframeworkNode set description = rtrim('  The teacher communicates and collaborates with the school/community and families in a timely and professional manner.                                                                                                                                                                                       ') where frameworkNodeID =  95
update seframeworkNode set description = rtrim('  The teacher collaborates with colleagues about student learning and instructional practices, displays dependability through active participation, and pursues professional development.                                                                                                                     ') where frameworkNodeID =  96

update seframeworkNode set description = '' where 
frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
and FrameworkNodeID not in 
( 73, 89, 77, 93,74, 90, 78, 94,75, 91, 79, 95,76, 92, 80, 96)

update seframeworkNode set description = RTRIM('PLANNING: The teacher sets high expectations through instructional planning and reflection aligned to content knowledge and standards. Instructional planning is demonstrated in the classroom through student engagement that leads to an impact on student learning.') + Description  where shortname ='c1' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('INSTRUCTION: The teacher uses research-based instructional practices to meet the needs of ALL students and bases those practices on a commitment to high standards and meeting the developmental needs of students.                                                   ') + Description  where shortname ='c2' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('REFLECTION: The teacher acquires and uses specific knowledge about students’ individual intellectual and social development and uses that knowledge to advance student learning.                                                                                      ') + Description  where shortname ='c3' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('CONTENT KNOWLEDGE: The teacher uses content area knowledge and appropriate pedagogy to design and deliver curricula, instruction and assessment to impact student learning.                                                                                           ') + Description  where shortname ='c4' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('CLASSROOM MANAGEMENT: The teacher fosters and manages a safe, culturally sensitive and inclusive learning environment that takes into account: physical, emotional and intellectual well-being                                                                        ') + Description  where shortname ='c5' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('ASSESSMENT: The teacher uses multiple data elements (both formative and summative) for planning, instruction and assessment to foster student achievement.                                                                                                            ') + Description  where shortname ='c6' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('PARENTS AND COMMUNITY: The teacher communicates and collaborates with students, parents and all educational stakeholders in an ethical and professional manner to promote student learning.                                                                           ') + Description  where shortname ='c7' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)
update seframeworkNode set description = RTRIM('PROFESSIONAL PRACTICE: The teacher participates collaboratively in the educational community to improve instruction, advance the knowledge and practice of teaching as a profession, and ultimately impact student learning.                                          ') + Description  where shortname ='c8' and frameworkID in (1, 3, 9, 11, 13, 15, 16, 17, 18)

--principal state
--select * from SEFrameworkNode where FrameworkID in (2, 8, 10, 12, 14, 19)
update SEFrameworkNode set Title = Description where FrameworkID in (2, 8, 10, 12, 14, 19)

update SEFrameworkNode set Title = SUBSTRING (description, 1,  charindex(':', description)-1)
  where FrameworkNodeID between 81 and 88

update SEFrameworkNode set Description = '  ' + SUBSTRING(description, charindex(':', description)+1, 2000) 
 where FrameworkNodeID between 81 and 88
 
update SEFrameworkNode set Description = '' 
where FrameworkID in (2, 8, 10, 12, 14, 19) 
and FrameworkNodeID not between 81 and 88
 
update seframeworkNode set description = rtrim('CULTURE:  Simply put, culture is the way things get done.  Principals influence the culture of a school in many ways.  Exemplary principals assure that all classroom cultures maximize learning; they also impact all non-classroom areas and non-class time, with teacher and student leaders, to establish healthy norms which support learning.') + description where shortname='c1' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('SAFETY: The principal is ultimately responsible for the safe operations of the school.  This includes both classroom and school-wide procedures.  Principals in Washington are required to have and monitor a school plan that would provide for the safest operations possible.                                                                   ') + description where shortname='c2' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('PLANNING:  Today’s principal leads using plans which are supported by evidence.  Whether it is student achievement data, discipline data, school climate perception data, or other measures of school success, using data in planning is crucial.  Data provides both the rationale and target for concerted action to move the school forward.    ') + description where shortname='c3' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('ALIGNMENT:  Principals monitor and assist teachers, not just in the “how” of teaching, but also the “what.” Aligning the curriculum, instruction and assessment within each class increases the likelihood that alignment from class to class happens, and students’ learning experiences are connected.                                           ') + description where shortname='c4' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('SUPERVISION:  Principals assist and support teacher professional development through the evaluation process.  They ensure that all students have teachers with strong instructional skills and dedication to the achievement of each student, by leading the hiring, evaluation and development of each teacher.                                   ') + description where shortname='c5' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('MANAGEMENT:  Principals make resource decisions to achieve learning, safety, community engagement and achievement gap goals.  These decisions include hiring and firing staff, maximizing financial resources, and organizing time, facilities and volunteers.                                                                                     ') + description where shortname='c6' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('COMMUNITY:  Principals link the school to the community and visa versa.  They assist teachers in connecting their students’ learning to parent and community support.                                                                                                                                                                              ') + description where shortname='c7' and frameworkID in (2, 8, 10, 12, 14, 19)
update seframeworkNode set description = rtrim('THE GAP:  Principals monitor gaps between various populations in the school.  They channel resources to reduce the gaps to ensure that all students have the maximum opportunity to achieve at high levels.                                                                                                                                        ') + description where shortname='c8' and frameworkID in (2, 8, 10, 12, 14, 19)

--instructional frameworks 

update SEFrameworkNode set Title = Description where FrameworkID in (4, 5, 7)

update SEFrameworkNode set Title = SUBSTRING (description, 1,  charindex(':', description)-1)
 where FrameworkID = 5

update SEFrameworkNode set Description = SUBSTRING(description, charindex(':', description)+1, 2000) 
 where FrameworkID = 5

