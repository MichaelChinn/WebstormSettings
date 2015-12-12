
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime , @NextVersion bigint
SELECT  @ahora = GETDATE()
SELECT @sql_error= 0,@tran_count = @@TRANCOUNT  FROM dbo.updateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 56560816
, @title = '56560816_2014BPrinUpdates'
, @comment = 'this must be done along with companion insert patch, as well as proto change'
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog ( bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

DECLARE @RubricRowIDS TABLE(RubricRowID bigint)

INSERT INTO @RubricRowIDS
select serr.RubricRowID from SERubricRow as serr
inner join SERubricRowFrameworkNode serrfn on serr.RubricRowID = serrfn.RubricRowID
inner join SEFrameworkNode sefn on sefn.FrameworkNodeID = serrfn.FrameworkNodeID
inner join SEFramework sef on sef.FrameworkID = sefn.FrameworkID
where sef.SchoolYear = '2014'
and sef.DerivedFromFrameworkID = 49

UPDATE [dbo].[SERubricRow] 
SET [Title] = '1.1 Develops and sustains focus on a shared mission and clear vision for improvement of learning and teaching'
      ,[PL1Descriptor] = 'Does not communicate mission, vision, and core values; tolerates behaviors and school activities in opposition to a culture of ongoing improvement'
      ,[PL2Descriptor] = 'Vision and mission are developing; connections between school activities, behaviors and the vision are made explicit; vision and mission are shared and supported by stakeholders'
      ,[PL3Descriptor] = 'Communicates a vision of ongoing improvement in teaching and learning such that staff and students perceive and agree upon what the school is working to achieve; encourages and supports behaviors and school activities that explicitly align with vision; shares enthusiasm and optimism that the vision will be realized; regularly communicates a strong commitment to the mission and vision of the school and holds stakeholders accountable for implementation'
      ,[PL4Descriptor] = 'Is proficient AND provides leadership and support such that shared vision and goals are at the forefront of attention for students and staff and at the center of their work; communicates mission, vision, and core values to community stakeholders such that the wider community knows, understands and supports the vision of the changing world in the 21st Century that schools are preparing children to enter and succeed'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '1.1'
 WHERE [Shortname] = '1.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '1.2 Engages in essential conversations for ongoing improvement'
      ,[PL1Descriptor] = 'Avoids conversations; does not make time for conversations; is not available to staff, students, other stakeholders, does not communicate high expectations and high standards for staff and students regarding ongoing improvement'
      ,[PL2Descriptor] = 'Communication moderately reflects issues with members of the school community; reinforces two-way communication with staff and students; barriers to improvement are identified and addressed; conversations are mostly data-driven for the purposes of assessing improvement with infrequent high expectations for students'
      ,[PL3Descriptor] = 'Assumes responsibility for accurate communication and productive flow of ideas among staff, students and stakeholders: provides leadership such that the essential conversations take place and in ways that maintain trust, dignity, and ensure accountability of participants; creates and sustains productive two-way communication that include staff members and students; regularly communicates high expectations and standards for staff and students regarding ongoing improvement'
      ,[PL4Descriptor] = 'Is proficient AND establishes and promotes successful systems and methods for communication that extend beyond the school community; creates a productive feedback loop among stakeholders that keeps the dialogue ongoing and purposeful; methods are recognized and adopted for purposes beyond school; staff report confidence in their ability to engage in essential conversations for ongoing improvement; consistently communicates high expectations and standards for staff and students regarding ongoing improvement'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '1.2'
 WHERE [Shortname] = '1.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '1.3 Facilitates collaborative processes leading toward continuous improvement'
      ,[PL1Descriptor] = 'Does not actively support or facilitate collaboration among staff; tolerates behaviors that impede collaboration among staff; fosters a climate of competition and supports unhealthy interactions among staff'
      ,[PL2Descriptor] = 'Demonstrates some understanding of the value of collaboration and what it takes to support it (i.e. building trust); facilitates collaboration among staff for certain purposes; emerging consensus-building and negotiation skills'
      ,[PL3Descriptor] = 'Actively models, supports, and facilitates collaborative processes among staff utilizing diversity of skills, perspectives and knowledge in the group; assumes responsibility for monitoring group dynamics and for promoting an open and constructive atmosphere for group discussions; creates opportunities for staff to initiate collaborative processes across grade levels and subject areas that support ongoing improvement of teaching and learning'
      ,[PL4Descriptor] = 'Is proficient AND successfully creates systems that build the capacity of stakeholders to collaborate across grade levels and subject areas; is recognized by school community and other stakeholders for leadership that results in a high degree of meaningful collaboration'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '1.3'
 WHERE [Shortname] = '1.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '1.4 Creates opportunities for shared leadership'
      ,[PL1Descriptor] = 'Offers no model or opportunity for shared leadership (ie. delegation, internship, etc.); makes decisions unilaterally'
      ,[PL2Descriptor] = 'Offers opportunities for staff and students to be in leadership roles; engages processes for shared decision-making; uses strategies to develop the capacity for shared leadership (ie. delegation, internship, etc.)'
      ,[PL3Descriptor] = 'Provides continual opportunity and invitation for staff to develop leadership qualities; consistently engages processes that support high participation in decision-making; assesses, analyzes and anticipates emerging trends and initiatives in order to adapt shared leadership opportunities'
      ,[PL4Descriptor] = 'Is proficient AND proactively cultivates leadership qualities in others; builds a sense of efficacy and empowerment among staff and students that results in increased capacity to accomplish substantial outcomes; involves staff in leadership roles that foster career development; expands opportunities for community stakeholders to engage in shared leadership'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '1.4'
 WHERE [Shortname] = '1.4'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '2.1 Provides for Physical Safety'
      ,[PL1Descriptor] = 'Neglects to consider the physical safety of students and staff; does not maintain and/or implement a current school safety plan; plan in place is insufficient to ensure physical safety of students and staff; major safety and health concerns'
      ,[PL2Descriptor] = 'Maintains and implements a school safety plan monitored on a regular basis; minor safety and sanitary concerns in school plant or equipment; problems might be identified but are not always resolved in a timely manner: an emergency operations plan is reviewed by appropriate external officials and posted in classrooms, meeting areas and office settings'
      ,[PL3Descriptor] = 'Implements a school safety plan that is based upon open communication systems and is effective and responsive to new threats and changing circumstances; problems are identified and principal is persistent in resolving them; proactively monitors and adjusts the plan in consultation with staff, students, and outside experts/consultants; staff proficiency in safety procedures are measured and monitored by group assessments followed by group reflection'
      ,[PL4Descriptor] = 'Is proficient AND serves as a resource for others in leadership roles beyond school who are developing and implementing comprehensive physical safety systems to include prevention, intervention, crisis response and recovery'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '2.1'
 WHERE [Shortname] = '2.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '2.2 Provides for social, emotional and intellectual safety'
      ,[PL1Descriptor] = 'Neglects the social, emotional or intellectual safety of students and staff; does not have an anti-bullying policy or behavior plan in place that promotes emotional safety; does not model an appreciation for diversity of ideas and opinions'
      ,[PL2Descriptor] = 'Strives to provide appropriate emotional support to staff and students; policies clearly define acceptable behavior; demonstrates acceptance for diversity of ideas and opinions; anti-bullying prevention program in place.'
      ,[PL3Descriptor] = 'Assumes responsibility for creating practices which maximize the social, emotional and intellectual safety of all staff and students; supports the development, implementation, and monitoring of plans, systems, curricula, and programs that provide resources to support social, emotional and intellectual safety; reinforces protective factors that reduce risk for all students and staff'
      ,[PL4Descriptor] = 'Is proficient AND makes emotional and intellectual safety a top priority for staff and students; ensures a school culture in which students and staff are acknowledged and connected; advocates for students to be a part of and responsible for their school community; ensures that school community members are trained and empowered to improve and sustain a culture of emotional safety; cultivates intellectual safety of students and staff by advocating for diversity of ideas, respecting perspectives that arise, promoting an open exchange of ideas; involves school community in active intellectual inquiry'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '2.2'
 WHERE [Shortname] = '2.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '3.1 Recognizes and seeks out multiple data sources'
      ,[PL1Descriptor] = 'Does not recognize multiple sources or quality of data or has a limited understanding of the power and meaning of data'
      ,[PL2Descriptor] = 'Seeks multiple sources of data to guide decision making; emerging knowledge of what constitutes valid and reliable sources of data and data integrity'
      ,[PL3Descriptor] = 'Systematically collects valid and reliable data from at least three sources to be used in problem solving and decision making; builds capacity of staff to recognize information as data by providing examples of using data throughout the building and in staff meetings; systematically gathers data on grades, attendance, behavior and other variables to inform efforts'
      ,[PL4Descriptor] = 'Is proficient AND explores and uses a wide variety of monitoring and data collection strategies; responds to an identified need for timely data by putting new data collection processes in place to collect reliable and valid data'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '3.1'
 WHERE [Shortname] = '3.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '3.2 Analyzes and interprets multiple data sources to inform school-level improvement efforts'
      ,[PL1Descriptor] = 'Reviews and shares limited school-level data only as required; interpretation of data may be incorrect or incomplete; misuses data'
      ,[PL2Descriptor] = 'Uses numerous data analysis methods and eager to broaden knowledge of data analysis and interpretation; uses school-level data to inform improvement across eight criteria'
      ,[PL3Descriptor] = 'Analysis includes multiple years of data, including state, district, school and formal and informal classroom assessments; interprets available data to make informed decisions about strengths and areas of need; provides teacher teams with previous year’s data and asks them to assess students’ current needs'
      ,[PL4Descriptor] = 'Is proficient AND consistently leads in data interpretation, analysis, and communication; links multiple years of student data to teachers and builds capacity of staff to understand and use their data for improved teaching and learning; practices a high standard for data reliability, validity and fairness and keeps these concepts in the forefront of conversations with staff'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '3.2'
 WHERE [Shortname] = '3.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '3.3 Implements data driven plan for improved teaching and learning'
      ,[PL1Descriptor] = 'Plan is limited, not data driven and/or not aligned with the needs of the school; little stakeholder involvement and commitment'
      ,[PL2Descriptor] = 'Plan is monitored, evaluated and revised resulting in data driven changes; works to build stakeholder involvement and commitment; models data-driven conversations in support of plan'
      ,[PL3Descriptor] = 'Provides leadership such that plan is clearly articulated and includes action steps and progress monitoring strategies, and strategies in the plan are directly aligned with the data analysis process and are research based; leads ongoing review of progress and results to make timely adjustments to the plan; data insights are regularly the subject of faculty meetings and PD sessions'
      ,[PL4Descriptor] = 'Is proficient AND creates a school culture of using data for decisions and continuous improvement in aspects of school life; orchestrates high-quality, low-stakes action planning meetings after each round of assessments; data driven plan specifically documents examples of decisions made on the basis of data analysis and results are documented to inform future decisions; provides assistance or coaching to other school administrators to improve their data driven plan and analysis'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '3.3'
 WHERE [Shortname] = '3.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '3.4 Assists staff to use data to guide, modify and improve classroom teaching and student learning'
      ,[PL1Descriptor] = 'Does not assist staff to use data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction, and to determine whether re-teaching, practice or moving forward is appropriate'
      ,[PL2Descriptor] = 'Occasionally assists staff to use multiple types of data to reflect on teaching to determine whether re-teaching, practice or moving forward is appropriate; strategies result in incomplete relationship between the actions of teachers and the impact on student achievement'
      ,[PL3Descriptor] = 'Regularly assists staff to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction (highly achieving as well as non-proficient) and to determine whether re-teaching, practice or moving forward with instruction is appropriate at both the group and individual level; strategies result in clear relationship between the actions of teachers and the impact on student achievement'
      ,[PL4Descriptor] = 'Is proficient AND demonstrates leadership by routinely and consistently leading teachers to use multiple types of data to reflect on effectiveness of lessons, guide lesson and assessment development, differentiate instruction, and to determine whether re-teaching, practice or moving forward with instruction is appropriate at both the group and individual level'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '3.4'
 WHERE [Shortname] = 'SG 3.4'
 AND [RubricRowID] in (select * from @RubricRowIDS)

UPDATE [dbo].[SERubricRow] 
SET [Title] = '4.1 Assists staff in aligning curricula to state and local district learning goals'
      ,[PL1Descriptor] = 'Has incomplete or insufficient knowledge of state and local district learning goals across grade levels and content areas; has insufficient knowledge to evaluate curricula; does not effectively assist staff to align curricula to state and district learning goals'
      ,[PL2Descriptor] = 'Has emerging knowledge and understanding of state and local district learning goals across grade levels and content areas to facilitate some alignment activities with staff'
      ,[PL3Descriptor] = 'Systematically focuses staff on alignment of their lessons to approved learning targets; establishes a system that uses feedback from the assessments to make adjustments to curricula'
      ,[PL4Descriptor] = 'Is proficient AND provides leadership and support such that teachers have fully aligned curriculum materials and training on how to use them; staff takes ownership of the alignment processes of goals to curricula; staff understand alignment of curricula to state and local district learning goals as foundational to the improvement of teaching and learning'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '4.1'
 WHERE [Shortname] = '4.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '4.2 Assists staff in aligning best instructional practices to state and district learning goals'
      ,[PL1Descriptor] = 'Has incomplete or insufficient knowledge of best instructional practices across grade levels and content areas; does not effectively assist staff to align instructional practices to state and district learning goals'
      ,[PL2Descriptor] = 'Has sufficient knowledge and understanding of best instructional practices across grade levels and content areas to facilitate some alignment activities with staff; emerging knowledge of culturally-relevant teaching & learning methodologies'
      ,[PL3Descriptor] = 'Has deep knowledge of best instructional practices for diverse populations and how to align these with curricula; systematically focuses staff on alignment; establishes a system for ongoing alignment that involves staff; continually supports, monitors alignment and makes adjustments; has teacher teams cooperatively plan aligned units, reviews them and then gives teachers feedback; reads and shares research that fosters an ongoing, school-wide discussion on best practices for non-proficient to above-proficient students'
      ,[PL4Descriptor] = 'Is proficient AND provides leadership and support such that staff understand alignment of best instructional practice to state and district learning goals as foundational to the improvement of teaching and learning; teachers design high quality, aligned units to discuss with their teams; ensures that staff is current on professional literature regarding curriculum alignment'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '4.2'
 WHERE [Shortname] = '4.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '4.3 Assists staff in aligning assessment practices to best instructional practices'
      ,[PL1Descriptor] = 'Has incomplete or insufficient knowledge of assessment in terms of reliability, validity and fairness; does not effectively assist staff to align assessments to instructional practices'
      ,[PL2Descriptor] = 'Has emerging knowledge and understanding of assessment in terms of reliability, validity and fairness; facilitates the implementation of certain aspects of a balanced (diagnostic, formative and summative) assessment system; facilitates the alignment of assessment to best instructional practices in some grade levels'
      ,[PL3Descriptor] = 'Has deep knowledge of assessment; every course has a document (syllabus, course outline or learning objectives) that identifies the learning outcomes in language accessible to students and parents; student work created in response to teachers’ assessments of the learning outcomes accurately reflect the state standards and district learning goals/targets; continually provides support to systematically focus staff on alignment of assessment to instruction using best practices; establishes a system for ongoing alignment of formative and summative assessment that involves staff members'
      ,[PL4Descriptor] = 'Is proficient AND provides leadership and support such that staff takes ownership of the alignment processes of assessment to instructional practices; staff understand the alignment of assessment to teaching as foundational to the improvement of teaching and learning'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '4.3'
 WHERE [Shortname] = '4.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '5.1 Monitors instruction and assessment practices'
      ,[PL1Descriptor] = 'Does not adequately monitor instruction and assessment practices of staff; untimely and irregular evaluations; provides insufficient feedback to staff regarding instruction and assessment practices'
      ,[PL2Descriptor] = 'Monitors instruction and assessment to meet the minimum frequency and procedural requirements'
      ,[PL3Descriptor] = 'Develops and uses observable systems and routines for regularly monitoring instruction and assessment; uses data consistently to provide staff meaningful, personal feedback that is effective for improving instruction and assessment practices'
      ,[PL4Descriptor] = 'Is proficient AND consistently demonstrates leadership in the practice of monitoring effective instruction and assessment practices; develops exemplary systems and routines for effective observation of staff; shares systems and routines with colleagues and stakeholders; regularly monitors, reflects on and develops or adjusts systems as needed to improve assessment practices'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '5.1'
 WHERE [Shortname] = '5.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = 'SG 5.2 Assists staff in developing required student growth plan and identifying valid, reliable sources of evidence of effectiveness'
      ,[PL1Descriptor] = 'Does not meet with faculty members to develop, review and modify student growth plans; student growth plans do not meet minimum requirements; does not assist staff in the identification of performance indicators or performance indicators are not sufficient'
      ,[PL2Descriptor] = 'Meets minimum teachers’ contract requirements to develop, review and modify student growth plans (individual or group plans) based on identified areas of need; assists identification of performance indicators to monitor and benchmark progress'
      ,[PL3Descriptor] = 'Meets with faculty members regularly to develop, review and modify student growth plans (individual or group plans); assists identification of performance indicators to benchmark progress; research-based planning and performance-linked goal setting strategies are used, allowing timely feedback to make mid-course corrections and improve teacher practice'
      ,[PL4Descriptor] = 'Is proficient AND consistently demonstrates leadership in the practice of developing comprehensive student growth plans; regularly meets with faculty members to reflect on student growth plans and progress'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = 'SG 5.2'
 WHERE [Shortname] = 'SG 5.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '5.3 Assists staff in implementing effective instruction and assessment practices'
      ,[PL1Descriptor] = 'Does not fully support staff in their efforts to improve teaching and assessment; does not have knowledge or understanding of best instruction and assessment practices; does not make assisting staff in improved teaching and assessment a priority'
      ,[PL2Descriptor] = 'Facilitates staff in the implementation of effective instruction and assessment practices; emerging knowledge of applied learning theories to create a personalized and motivated learning environment'
      ,[PL3Descriptor] = 'Facilitates and supports staff in the implementation of effective instruction and assessment practices; has deep and thorough knowledge and understanding of best practices in instruction and assessment; devotes time and effort to the improvement of instruction and assessment; assists staff to use the most effective and appropriate technologies to support teaching and learning'
      ,[PL4Descriptor] = 'Is proficient AND serves as a driving force to build capacity for staff to initiate and implement improved instruction and assessment practices; encourages staff to conduct action research; seeks ways to extend influence of knowledge and contribute to the application of effective instruction and assessment practices'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '5.3'
 WHERE [Shortname] = '5.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '5.4 Evaluates staff in effective instruction and assessment practices'
      ,[PL1Descriptor] = 'Evaluations lack strong evidence yielding potentially unreliable staff evaluations; makes claims about staff performance that lack evidence; does not establish systems or routines that support improved instruction and assessment practices; little to no understanding of student diversity and its meaning in instruction and assessment'
      ,[PL2Descriptor] = 'Regularly and systematically evaluates all staff yielding valid and reliable results; recommendations lead staff to some improvement in instruction and assessment practices; developing understanding of student diversity (culture, ability, etc.) and its meaning in instruction and assessment'
      ,[PL3Descriptor] = 'Evaluates staff reliably and validly; provides data evidence to support claims; recommendations are effective and lead to consistently improved instruction and assessment practices; demonstrating knowledge of student diversity (culture, ability, etc.) and its meaning in instruction and assessment'
      ,[PL4Descriptor] = 'Is proficient AND consistently demonstrates leadership in the practice of thoroughly, reliably and validly evaluating staff in such a way that continuous improvement in instruction and assessment becomes the professional standard; provides detailed, formative assessment with exemplary feedback that leads to improvement; builds capacity in staff to accurately and validly assess self and others, promoting a culture of continual improvement due to ongoing evaluation of effective instruction and assessment practices'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '5.4'
 WHERE [Shortname] = '5.4'
 AND [RubricRowID] in (select * from @RubricRowIDS)

UPDATE [dbo].[SERubricRow] 
SET [Title] = '6.1 Managing human resources (assignment, hiring)'
      ,[PL1Descriptor] = 'Does not adequately address issues in hiring and placement of staff for the benefit of students in classrooms; does not put student needs at the forefront of human resource decisions; does not make an effort to ensure quality personnel in each position'
      ,[PL2Descriptor] = 'Places the needs of students at the center of some human resource decisions with moderate effect; possesses some skills and knowledge required to recruit and hire highly qualified individuals in school positions'
      ,[PL3Descriptor] = 'Places students’ needs at the center of human resource decisions and decisions regarding hiring and placement of staff; conducts a rigorous hiring process when choosing staff; focuses energy on ensuring productivity through staff placement'
      ,[PL4Descriptor] = 'Is proficient AND optimizes the school''s human resources and assets of staff members to maximize opportunities for student growth; is distinguished in management of human resources and is called upon to share those successful processes outside of school; efforts produce a positive work environment that attracts outstanding talent; continuously searches for staff with outstanding potential as educators and provides the best placement of both new and existing staff to fully benefits from their strengths in meeting the needs of a diverse student population'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '6.1'
 WHERE [Shortname] = '6.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '6.2 Managing human resources (ongoing professional development)'
      ,[PL1Descriptor] = 'Staff receive inadequate opportunities for professional development to meet students’ and staffs’ needs; professional development offered is not of sufficient quality to be effective'
      ,[PL2Descriptor] = 'Professional development plan somewhat aligns to organization’s vision and plan; PD is partly effective in leading to minor improvements in staff practice; little or no documentation of effectiveness of past professional development offerings and teacher outcomes'
      ,[PL3Descriptor] = 'Professional development plan has three to four areas of emphasis, job embedded, ongoing and linked to the organization’s vision and plan; systematic evaluation of the effectiveness of past PD offerings and outcomes; creates and supports informal professional development (ie. professional learning communities); offers PD that meets teachers’ needs and has elements of high-quality PD (sufficient duration, content, etc.)'
      ,[PL4Descriptor] = 'Is proficient AND has adopted research-based strategies for evaluating the effectiveness of PD documenting growth in teacher knowledge to student outcomes; can identify specific PD offerings of prior years that were systematically reviewed and either eliminated or modified to support organizational goals'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '6.2'
 WHERE [Shortname] = '6.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '6.3 Managing fiscal resources'
      ,[PL1Descriptor] = 'Does not make fiscal decisions that maximize resources in support of improved teaching and learning; provides little or no evidence of lists of milestones or deadlines in managing time or fiscal resources; does not work with teachers to establish goals for student achievement linked to individual teacher professional development'
      ,[PL2Descriptor] = 'Fiscal decisions occasionally support some aspects of improved teaching and learning; projects are managed using milestones and deadlines but not updated frequently; does not always meet project deadlines and impact not frequently documented'
      ,[PL3Descriptor] = 'Engages others in dialogue on budget decisions based on data, School Improvement Plan, and district priorities that support learning; makes fiscal decisions that maximize resources and supports improved teaching and learning; uses defined process to track expenditures; frequently monitors data, documents and evaluates results; uses findings to improve fiscal decisions; documented history reveals ability to manage complex projects and meet deadlines within budget; regularly works with teachers to establish goals for student achievement linked to individual teachers professional development'
      ,[PL4Descriptor] = 'Is proficient AND demonstrates leadership in the design and successful enactment of uniquely creative approaches that regularly save time and money; results indicate that strategically redirected resources have positive impact in achieving priorities; guides decision-making such that efficacy grows among stakeholders for arriving at fiscal decisions for improvement of teaching and learning; augments resources by writing successful state and/or federal grants; seeks numerous external funding sources; consistently works with teachers to establish goals for student achievement linked to individual teachers professional development'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '6.3'
 WHERE [Shortname] = '6.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '6.4 Fulfilling legal responsibilities'
      ,[PL1Descriptor] = 'Fails to demonstrate adequate knowledge of legal responsibilities; exhibits behaviors and policies that conflict with the law; tolerates behavior from self or staff that conflicts with the law'
      ,[PL2Descriptor] = 'Demonstrates basic knowledge and understanding of legal responsibilities; makes resource management decisions consistent with that knowledge; does not entertain behaviors and policies that conflict with the law'
      ,[PL3Descriptor] = 'Demonstrates a deep and thorough knowledge and understanding of the law and its intent; makes resource management decisions consistent with that knowledge ; operates with deep and thorough knowledge and understanding of district policies and collective bargaining agreements; consistently holds self and staff to legal standards'
      ,[PL4Descriptor] = 'Is proficient AND consistently demonstrates leadership for developing systems that communicate and support staff in upholding legal responsibilities; creates a culture of shared legal responsibility among students and staff; involves stakeholders in the creation of a school culture that thrives upon and benefits from addressing legal responsibilities'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '6.4'
 WHERE [Shortname] = '6.4'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '7.1 Communicates with community to promote learning'
      ,[PL1Descriptor] = 'Communication is sparse and opportunities for community involvement are not fully realized or made available; not visible in community or perceived as community advocate'
      ,[PL2Descriptor] = 'Communication with the community is regular, yet is mainly informational rather than two-way; channels of communication are not accessible to all families; practices some discretion when dealing with personal information about students and staff.'
      ,[PL3Descriptor] = 'Builds effective communication systems between home, community and school that are interactive and regularly used by students, school staff and families and other stakeholders; uses multiple communication channels appropriate for cultural and language differences that exist in the community; practices a healthy discretion with personal information of students and staff'
      ,[PL4Descriptor] = 'Is proficient AND moves beyond typical communication practices to proactively develop relationships with parents/guardians and community through such things as home visits, innovative technology, visiting community groups, etc.; establishes a feedback loop that is invitational, transparent, effective and trusted by members of the community including open forums, focus groups or surveys; employs successful models of school, family, business, community, government and higher education partnerships to promote learning ; use of exemplary education marketing skills to establish partnerships to mobilize wealth of community resources'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '7.1'
 WHERE [Shortname] = '7.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '7.2 Partners with families and school community'
      ,[PL1Descriptor] = 'Demonstrates little effort to engage families or the community in school activities; fails to share the vision of improved teaching and learning beyond school; does not identify and utilize community resources in support of improved student learning'
      ,[PL2Descriptor] = 'Encourages and supports involvement of community and families in some school activities; shares the vision for improving teaching and learning with some families and communities; identifies and utilizes some community talent and resources in support of improved teaching and learning; limited family participation in some school decision-making processes and engagement activities'
      ,[PL3Descriptor] = 'Encourages and supports consistent and ongoing community and family engagement for stakeholders in school activities; consistently implements effective plans for engaging community outside of school to participate in school decision making to improve teaching and learning; community resources are identified and utilized in support of improved teaching and learning; actively monitors community involvement and adjusts, creating new opportunities for families and community to be a part of the vision of improving teaching and learning'
      ,[PL4Descriptor] = 'Is proficient AND consistently demonstrates leadership in the area of effectively engaging families and the greater community in support of students, staff and the vision of improved teaching and learning; is recognized outside of school for developing and implementing programs that partner with school, family and greater community, or programs are held as a model for other schools to adopt and follow; builds capacity in the community for initiating new and beneficial forms of community involvement in school; to the extent possible, facilitates access of community services to students in the school'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '7.2'
 WHERE [Shortname] = '7.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '8.1 Identifies barriers to achievement and knows how to close resulting gaps'
      ,[PL1Descriptor] = 'Is unaware of achievement gaps that exist in school population and how the school and teachers have played a role in perpetuating gaps; attributes gaps to factors outside of the school''s locus of control; opportunities to learn and resources are not distributed equitably among students'
      ,[PL2Descriptor] = 'Demonstrates emerging awareness of specific school-wide achievement gaps and issues of equity access; recognizes responsibility and has some expectations for teachers and school to impact these gaps; creates new opportunities to learn'
      ,[PL3Descriptor] = 'Identifies learning gaps early; demonstrates complete knowledge and understanding of the existence of gaps; accepts responsibility for impacting these gaps; identifies and addresses barriers to closing gaps'
      ,[PL4Descriptor] = 'Is proficient AND focuses attention of school community on the goal of closing gaps; systematically challenges the status quo by leading change, based on data, resulting in beneficial outcomes; builds capacity among community to support the effort to close gaps'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '8.1'
 WHERE [Shortname] = '8.1'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = '8.2 Demonstrates a commitment to close the achievement gap'
      ,[PL1Descriptor] = 'Does not acknowledge the responsibility of school to close gaps; does not consider subpopulations when constructing school learning goals and targets; does not have a plan to close gaps'
      ,[PL2Descriptor] = 'Achievement data is accessible and shared with a portion of the school community; attempts to target efforts towards closing achievement gaps; uses culturally-relevant methodologies to close gaps; demonstrates emerging progress in closing gaps'
      ,[PL3Descriptor] = 'Achievement data is accessible to all members of the school community including non-English speaking parents; constructs plan with specific strategies to impact gaps; communicates, monitors and adjust efforts to effectively make progress toward reducing gaps; models and builds the capacity of school personnel to be culturally competent and to implement socially just practices; demonstrates improvement in closing identified gaps'
      ,[PL4Descriptor] = 'Is proficient AND successfully keeps the work of closing gaps at the forefront of intention for staff and community members; assumes responsibility for closing gaps; builds capacity in staff members and others to advance learning for students; has deep knowledge and understanding of the nature of gaps that exist at the level of group and at the level of individual students who are not reaching full learning potential'
      ,[IsStudentGrowthAligned] = '0'
      ,[Shortname] = '8.2'
 WHERE [Shortname] = '8.2'
 AND [RubricRowID] in (select * from @RubricRowIDS)
UPDATE [dbo].[SERubricRow] 
SET [Title] = 'SG 8.3 Provides evidence of growth in student learning'
      ,[PL1Descriptor] = 'Achievement data from multiple sources or data points show no evidence of student growth toward the district’s learning goals; there are growing achievement gaps between student subgroups'
      ,[PL2Descriptor] = 'Achievement data from multiple sources or data points shows minimum evidence of student growth toward the district’s learning goals for identified subgroups of students'
      ,[PL3Descriptor] = 'Achievement data from multiple sources or data points show evidence of improving student growth toward the district’s learning goals; the average achievement of the student population improved as does the achievement of each subgroup of students identified as needing improvement'
      ,[PL4Descriptor] = 'Achievement data from multiple sources or data points show evidence of consistent growth toward the district’s learning goals; there is consistent record of improved student achievement, on multiple indicators, with identified subgroups of students'
      ,[IsStudentGrowthAligned] = '1'
      ,[Shortname] = 'SG 8.3'
 WHERE [Shortname] = 'SG 8.3'
 AND [RubricRowID] in (select * from @RubricRowIDS)



/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END

GO
