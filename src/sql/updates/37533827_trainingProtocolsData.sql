
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 37533827
, @title = 'Training Protocols Data'
, @comment = ''
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

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

-- Highly Effective Teaching Strategies Framework
-- select * from seframeworkviewtype

DECLARE @SchoolYear SMALLINT
DECLARE @SEFrameworkSetID BIGINT
SELECT @SchoolYear = 2016
-- TODO: create a frameworkset in proto
DECLARE @FID BIGINT
DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
INSERT dbo.SEFramework(Name, EvaluationTypeID, Description, DistrictCode, SchoolYear, FrameworkTypeID, IFWTypeID, IsPrototype, HasBeenMOdified, HasBeenApproved, DerivedFromFrameworkID, DerivedFromFrameworkAuthor, LoadDateTime)
VALUES ('Highly Leverage Practices Framework', 2, '', '', @SchoolYear, @FT, 1, 0,0,0, 0, '', @theDate)
SELECT @FID = SCOPE_IDENTITY()

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Making content explicit through explanation, modeling, representations, and examples', 'H1', 
'Making content explicit is essential to providing all students with access to fundamental ideas and practices in a given subject. Effective efforts to do this attend both to the integrity of the subject and to students’ likely interpretations of it. They include strategically choosing and using representations and examples to build understanding and remediate misconceptions, using language carefully, highlighting core ideas while sidelining potentially distracting ones, and making one’s own thinking visible while modeling and demonstrating.',
1, 1, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Leading a whole-class discussion', 'H2', 
'In a whole-class discussion, the teacher and all of the students work on specific content together, using one another’s ideas as resources. The purposes of a discussion are to build collective knowledge and capability in relation to specific instructional goals and to allow students to practice listening, speaking, and interpreting. In instructionally productive discussions, the teacher and a wide range of students contribute orally, listen actively, and respond to and learn from others’ contributions.',
1, 2, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Eliciting and interpreting individual students’ thinking', 'H3', 
'Teachers pose questions or tasks that provoke or allow students to share their thinking about specific academic content in order to evaluate student understanding, guide instructional decisions, and surface ideas that will benefit other students. To do this effectively, a teacher draws out a student’s thinking through carefully-chosen questions and tasks and considers and checks alternative interpretations of the student’s ideas and methods.',
1, 3, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Establishing norms and routines for classroom discourse central to the subject-matter domain', 'H4', 
'Each discipline has norms and routines that reflect the ways in which people in the field construct and share knowledge. These norms and routines vary across subjects but often include establishing hypotheses, providing evidence for claims, and showing one’s thinking in detail. Teaching students what they are, why they are important, and how to use them is crucial to building understanding and capability in a given subject. Teachers may use explicit explanation, modeling, and repeated practice to do this.',
1, 4, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Recognizing particular common patterns of student thinking in a subject-matter domain', 'H5', 
'Although there are important individual and cultural differences among students, there are also common patterns in the ways in which students think about and develop understanding and skill in relation to particular topics and problems. Teachers who are familiar with common patterns of student thinking and development and who are fluent in anticipating or identifying them are able to work more effectively and efficiently as they plan and implement instruction and evaluate student learning.',
1, 5, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Identifying and implementing an instructional response to common patterns of student thinking', 'H6', 
'Specific instructional strategies are known to be effective in response to particular common patterns of student thinking. Teachers who are familiar with them can choose among them appropriately and use them to support, extend, or begin to change student thinking.'
,1, 6, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Teaching a lesson or segment of instruction', 'H7', 
'During a lesson or segment of instruction, the teacher sequences instructional opportunities toward specific learning goals and represents academic content in ways that connect to students’ prior knowledge and extends their learning. In a skillfully enacted lesson, the teacher fosters student engagement, provides access to new material and opportunities for student practice, adapts instruction in response to what students do or say, and assesses what students know and can do as a result of instruction.',
1, 7, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Implementing organizational routines, procedures, and strategies to support a learning environment', 'H8', 
'Teachers implement routine ways of carrying out classroom tasks in order to maximize the time available for learning and minimize disruptions and distractions. They organize time, space, materials, and students strategically and deliberately teach students how to complete tasks such as lining up at the door, passing out papers, and asking to participate in class discussion. This can include demonstrating and rehearsing routines and maintaining them consistently.'
,1, 8, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Setting up and managing small group work', 'H9', 
'Teachers use small group work when instructional goals call for in-depth interaction among students and in order to teach students to work collaboratively. To use groups effectively, teachers choose tasks that require and foster collaborative work, issue clear directions that permit groups to work semi-independently, and implement mechanisms for holding students accountable for both collective and individual learning. They use their own time strategically, deliberately choosing which groups to work with, when, and on what.'
,1, 9, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Engaging in strategic relationship-building conversations with students', 'H10', 
'Teachers increase the likelihood that students will engage and persist in school when they establish positive, individual relationships with them. Brief, one-on-one conversations with students are a fundamental way of doing this, as they help teachers learn about students and demonstrate care and interest. They are most effective when teachers are strategic about when to have them and what to talk about and use what they learn to address academic and social needs.'
,1, 10, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Setting long- and short-term learning goals for students referenced to external benchmarks', 'H11', 
'Clear goals referenced to external standards help teachers ensure that all students learn expected content. Explicit goals help teachers to maintain coherent, purposeful, and equitable instruction over time. Setting effective goals involves analysis of student knowledge and skills in relation to established standards and careful efforts to establish and sequence interim benchmarks that will help ensure steady progress toward larger goals.'
,1, 11, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Appraising, choosing, and modifying tasks and texts for a specific learning goal', 'H12', 
'Teachers appraise and modify curriculum materials to determine their appropriateness for helping particular students work toward specific learning goals. This involves considering students’ needs and assessing what questions and ideas particular materials will raise and the ways in which they are likely to challenge students. Teachers choose and modify material accordingly, sometimes deciding to use parts of a text or activity and not others, for example, or to combine material from more than one source.'
,1, 12, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Designing a sequence of lessons toward a specific learning goal', 'H13', 
'Carefully-sequenced lessons help students develop deep understanding of content and sophisticated skills and practices. Teachers design and sequence lessons with an eye toward providing opportunities for student inquiry and discovery and include opportunities for students to practice and master foundational concepts and skills before moving on to more advanced ones. Effectively-sequenced lessons maintain a coherent focus while keeping students engaged; they also help students achieve appreciation of what they have learned.'
,1, 13, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Selecting and using particular methods to check understanding and monitor student learning', 'H14', 
'Teachers use a variety of informal but deliberate methods to assess what students are learning during and between lessons. These frequent checks provide information about students’ current level of competence and help the teacher adjust instruction during a single lesson or from one lesson to the next. They may include, for example, simple questioning, short performance tasks, or journal or notebook entries.'
,1, 14, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Composing, selecting, interpreting, and using information from methods of summative assessment', 'H15', 
'Effective summative assessments provide teachers with rich information about what students have learned and where they are struggling in relation to specific learning goals. In composing and selecting assessments, teachers consider validity, fairness, and efficiency. Effective summative assessments provide both students and teachers with useful information and help teachers evaluate and design further instruction. Teachers analyze the results of assessments carefully, looking for patterns that will guide efforts to assist specific students and inform future instruction.'
,1, 15, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Providing oral and written feedback to students on their work', 'H16', 
'Effective feedback helps focus students’ attention on specific qualities of their work; it highlights areas needing improvement; and delineates ways to improve. Good feedback is specific, not overwhelming in scope, and focused on the academic task, and supports students’ perceptions of their own capability. Giving skillful feedback requires the teacher to make strategic choices about the frequency, method, and content of feedback and to communicate in ways that are understandable by students.'
,1, 16, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Communicating about a student with a parent or guardian', 'H17', 
'Regular communication between teachers and parents/guardians supports student learning. Teachers communicate with parents to provide information about students’ academic progress, behavior, or development; to seek information and help; and to request parental involvement in school. These communications may take place in person, in writing, or over the phone. Productive communications are attentive to considerations of language and culture and designed to support parents and guardians in fostering their child’s success in and out of school.'
,1, 17, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Analyzing instruction for the purpose of improving it', 'H18', 
'Learning to teach is an ongoing process that requires regular analysis of instruction and its effectiveness. Teachers study their own teaching and that of their colleagues in order to improve their understanding of the complex interactions between teachers, students, and content and of the impact of particular instructional approaches.  Analyzing instruction may take place individually or collectively and involves identifying salient features of the instruction and making reasoned hypotheses for how to improve.'
,1, 18, 1)

INSERT dbo.SEFrameworkNode(FrameworkID, Title, ShortName, Description, IsStateFramework, Sequence, IsLeafNode)
VALUES(@FID, 'Communicating with other professionals', 'H19', 
'Teachers routinely communicate with fellow teachers, administrators, and other professionals in order to plan teaching, discuss student needs, secure special services for students, and manage school policies. They do this orally, in meetings and presentations, and in writing, in letters, emails, newsletters, and other documents. Skillful communication is succinct, respectful, and focused on specific professional topics. It uses clear, accessible language, generally in standard English, and is attentive to its specific audience.'
,1, 19, 1)

-- Labels

INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Subject Area')
INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Grade Level')
INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Strategy Area')

-- Subject Areas
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Reading', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Math', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Writing', 1)

-- Grade Levels
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Primary', 2)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Secondary', 2)

-- Strategy Area
DECLARE @StrategyLabelID BIGINT
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Content', 3)
SELECT @StrategyLabelID = SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Instructional', 3)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Assessment', 3)
	
DECLARE @ProtocolID BIGINT
DECLARE @FrameworkName VARCHAR(MAX)
SELECT @FrameworkName = name from seframework where derivedfromframeworkname ='Dan, StateView'

----------------------------------------
 -- #1 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
VALUES(1, 0, 'Primary: Constructing Meaning Through Reading', '5:10', 
		'TODO: Overview',
		'',
		'Video96.pdf'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
			
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Reading', 'Primary')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=@SchoolYear
   and fn.ShortName IN ('C2', 'C4', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=@SchoolYear
   and fn.ShortName IN ('H7')
		
----------------------------------------
 -- #2 --
 ----------------------------------------

INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
VALUES(1, 0, 'Secondary: Whole Class Math Discourse', 'Segment 1: 8:55–12:15 (3:20 min); Segment 2: 12:15–13:25 (1:10 min)<br/>Total Time: 4:30 min',
		'TODO: Overview', 
		'',
		 'Video217.pdf'
		)	
SELECT @ProtocolID=SCOPE_IDENTITY()

INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary')
 
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=@SchoolYear
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=@SchoolYear
   and fn.ShortName IN ('H2', 'H3', 'H4')
 
 ----------------------------------------
 -- #3 --
 ----------------------------------------
 
 INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
VALUES(1, 0, 'Facilitating Interactions—Small Groups', '4:00',
		'TODO: Overview', 
		'',
		 'Video74.pdf'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=@SchoolYear
   and fn.ShortName='C5'
   
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=@SchoolYear
   and fn.ShortName='H8'

 ----------------------------------------
 -- #4 --
 ----------------------------------------
			
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
VALUES(1, 0, 'Secondary: Teaching a Lesson', '3:50',
		'TODO: Overview', 
		'',
		 'Video214.pdf'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()

INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Secondary')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=@SchoolYear
   and fn.ShortName IN ('C2', 'C4', 'C5')
   
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=@SchoolYear
   and fn.ShortName='H7'


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


