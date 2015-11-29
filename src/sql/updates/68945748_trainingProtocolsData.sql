
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

select @bugFixed = 68945748
, @title = 'Training Protocols Data'
, @comment = ''


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
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

-- Fix up first four
-- Switch reading to English/Language Arts

DELETE dbo.SETrainingProtocolLabelAssignment WHERE TrainingProtocolID=1

INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT 1,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'National Board')
 
UPDATE SETrainingProtocolLabel SET Sequence=1 WHERE Name='Primary'
UPDATE SETrainingProtocolLabel SET Sequence=2 WHERE Name='Intermediate'
UPDATE SETrainingProtocolLabel SET Sequence=3 WHERE Name='Secondary'
 
DELETE dbo.SETrainingProtocolLabel WHERE Name IN ('Reading', 'Writing')
 
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT 2,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('National Board')
 
 INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT 3,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('National Board')
 
 INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT 4,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('National Board')

-- Subject Areas
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('English language learners', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Health', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Pre-K/K class', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Music', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Special Education', 1)

DECLARE @ProtocolID BIGINT
DECLARE @FrameworkName VARCHAR(MAX)
SELECT @FrameworkName = name from seframework where derivedfromframeworkname ='Dan, StateView'

----------------------------------------
 -- #1 --
 -- Video 42 --
 -- Title - Eliciting and Interpreting Individual Students’ Thinking
 -- Summary – The purpose of this protocol is to focus on teacher questioning strategies that provoke or allow students to share their thinking about specific academic content in order to evaluate student understanding, guide instructional decisions, and surface ideas that will benefit other students.  
 -- Content Area – English language learners
 -- Grade-level - elementary
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Eliciting and Interpreting Individual Students’ Thinking',
		'',
		'The purpose of this protocol is to focus on teacher questioning strategies that provoke or allow students to share their thinking about specific academic content in order to evaluate student understanding, guide instructional decisions, and surface ideas that will benefit other students.',
		'Video42.pdf',
		'3:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-575d75ef-aeab-407f-ab9e-47ca09eba66e/42 ElicitingandInterpretingIndividualStudentsThinking_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.8641814.jpg?sv=2012-02-12&sr=c&si=f96e9d23-2776-40e4-b5ae-42a7b6fe8e8b&sig=2XzC8U7WGgHhFfV4HpQsFA%2BjsQHOrnWL%2FVEIWmJcN8E%3D&se=2029-06-13T08:32:26Z',
		'https://evalwashington.blob.core.windows.net/asset-21643671-75a1-474e-970a-3354c7c83d2e/42%20ElicitingandInterpretingIndividualStudentsThinking_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-05-13T16%3A57%3A09Z&se=2016-05-12T16%3A57%3A09Z&sr=c&si=447c8605-9407-46c0-be61-40bbeec36bb5&sig=W%2BZmShoxMQhnK13BV0pVLf4cnGiykG2YD13eZCZg2KY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English language learners', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')


----------------------------------------
 -- #2 --
 -- Video 259 --
 -- Title – Coherence and Student Conversation, Thinking and Learning
 -- Summary - The purpose is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content Area – math
 -- Grade-level – middle level
 -- Strategy Area: Content, Instructional
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'259 protocol nn.doc',
		'Time segment: 4:15 - 6:04 and 12:49 - 14:54',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-458d9d9d-3d87-48e9-bfb5-bbad593f521d/259 CoherenceandStudentConversationThinkingandLearning_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3401070.jpg?sv=2012-02-12&sr=c&si=740bb40c-95fb-4ad3-9129-315c7e4a38f9&sig=MJJ5h17FJBkmkTQ5SXp%2BNFiPdV9UmBPpt9nge6cVy2o%3D&se=2029-06-13T08:21:29Z',
		'https://evalwashington.blob.core.windows.net/asset-e178b841-b6ff-4a5f-a41b-f685a5c3180d/259%20CoherenceandStudentConversationThinkingandLearning_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-05-13T17%3A04%3A34Z&se=2016-05-12T17%3A04%3A34Z&sr=c&si=febbeb82-97f2-441f-83f7-210d88ac7855&sig=Ak%2Fczy8uOIewVbK4NEjcsPFryr1WI0S0xak%2FFsSkMaM%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1','C2','C3','C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #3 --
 -- Video 163 --
 -- Title - Classroom Management: Organizational Routines, Procedures and Strategies
 -- Summary – This protocol focuses on strategies that help identify ways that organizational routines, procedures, and strategies maximize time available for learning and minimize disruptions and distractions.
 -- Content Area – health
 -- Grade-level – middle level
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Classroom Management: Organizational Routines, Procedures and Strategies',
		'',
		'This protocol focuses on strategies that help identify ways that organizational routines, procedures, and strategies maximize time available for learning and minimize disruptions and distractions.',
		'Video163.pdf',
		'3:53-5:53 and 8:10-10:25',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-7c504a1c-51c4-45e3-86ba-19be5256b42b/163 ClassroomManagement-OrganizationalRoutinesProceduresandStrategies_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.5581424.jpg?sv=2012-02-12&sr=c&si=da260484-6d30-4732-9f4e-0b9653c5e365&sig=hQ8x%2B%2FWs35XIiiKW2wJSMZ54sIx72n%2FmzK0tHN3INh8%3D&se=2029-06-13T07:33:40Z',
		'https://evalwashington.blob.core.windows.net/asset-2387c646-e43b-4f7f-b8b3-2d126b986afd/163%20ClassroomManagement-OrganizationalRoutinesProceduresandStrategies_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=65a5576a-5337-403c-bb7f-f79c4b778a77&sig=QMgRiGOEAUh1xNq%2Fe1CiYnoKFvVrNC4BihnDVMJD91A%3D&st=2014-06-17T08%3A54%3A14Z&se=2016-06-16T08%3A54%3A14Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1','C2','C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H8')


----------------------------------------
 -- #4 --
 -- Video 34 --
 -- Title - Primary Social Studies: Facilitating Small Groups
 -- Summary - The purpose of this activity is to improve the practice of teaching a lesson or segment of instruction and implementing organizational routines and strategies to support a learning environment.
 -- Content Area – pre-K/K class
 -- Grade-level - elementary
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Primary Social Studies: Facilitating Small Groups',
		'',
		'The purpose of this activity is to improve the practice of teaching a lesson or segment of instruction and implementing organizational routines and strategies to support a learning environment.',
		'Video34.pdf',
		'1:30-4:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-1a4b8b07-ea16-48fc-bdc6-c1d68cd779cd/34 PrimarySocialStudies-FacilitatingSmallGroups_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.5011701.jpg?sv=2012-02-12&sr=c&si=1eca1af9-203a-49be-b31f-b6d65552e917&sig=7YYqoWD4oxPTjRgqkSPSqSaI38SYqa7NPdgb6FqGayo%3D&se=2029-06-13T08:28:31Z',
		'https://evalwashington.blob.core.windows.net/asset-557fe7ac-d1d3-4c53-ab31-8dd36705cf9c/34%20PrimarySocialStudies-FacilitatingSmallGroups_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-05-13T16%3A57%3A22Z&se=2016-05-12T16%3A57%3A22Z&sr=c&si=519c36fe-f510-42eb-b0e6-a6c84fe85753&sig=vzoA06x%2BmQNn6xHVquqIU9KJOjPJ%2FSYgvBj%2BaGe8%2Fyk%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Pre-K/K class', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2','C4','C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7', 'H8')


----------------------------------------
 -- #5 --
 -- Video 79 --
 -- Title - Making Content Explicit through Explanations, Modeling, Representations and Examples
 -- Summary - The purpose of the activity is to improve practice in making content explicit through strategically choosing and using representations and examples to build understanding, using language carefully, highlighting core ideas and making one's own thinking visible while modeling and demonstrating.
 -- Content Area – music
 -- Grade-level - elementary
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Making Content Explicit through Explanations, Modeling, Representations and Examples',
		'',
		'The purpose of the activity is to improve practice in making content explicit through strategically choosing and using representations and examples to build understanding, using language carefully, highlighting core ideas and making one''s own thinking visible while modeling and demonstrating.',
		'Video79.pdf',
		'0:07-4:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-d0e85c7f-40bc-4f24-8382-d5a87625339d/79 MakingContentExplicitthroughExplanationsModelingRepresentationsandExamples_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3308190.jpg?sv=2012-02-12&sr=c&si=d128fe26-52f9-40f1-883d-62a2655d737e&sig=lFf6ot7Ye5qhk1KwwYNpTfVYH%2BF55v4ED8xO4p8oiN4%3D&se=2029-06-13T08:35:47Z',
		'https://evalwashington.blob.core.windows.net/asset-6b0fff05-20ce-4da5-8b73-2c2337ba4b53/79%20MakingContentExplicitthroughExplanationsModelingRepresentationsandExamples_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-05-13T16%3A57%3A01Z&se=2016-05-12T16%3A57%3A01Z&sr=c&si=8ab5bde6-5a88-412f-a07f-7936ac7b8271&sig=G%2FK%2B8gaT3wGEWzXdo6UYYT0u3akGT21iKH2YHibO8x0%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1')


----------------------------------------
 -- #6 --
 -- Video 175 --
 -- Title - Facilitating Organizational Routines, Procedures, Strategies
 -- Summary - The purpose of this protocol is to observe the relationship between classroom organization and the impact it has on student learning. 
 -- Content Area – art
 -- Grade-level - elementary
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Facilitating Organizational Routines, Procedures, Strategies',
		'',
		'The purpose of this protocol is to observe the relationship between classroom organization and the impact it has on student learning.',
		'Video175.pdf',
		'Freeze Frame: 0:43 and segment: 4:45 – 9:45',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-3530ef30-696a-430a-9e56-c8e1b0dd4320/175 FacilitatingOrganizationalRoutinesProceduresStrategies_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0011791.jpg?sv=2012-02-12&sr=c&si=58cbf6bd-a984-4a53-a037-5d63bb1f0e13&sig=em%2F7kpSSNHZVOCTqfuc%2F%2Fg0evfZvDeUa2WOmuMIs%2BX8%3D&se=2029-06-13T08:18:03Z',
		'https://evalwashington.blob.core.windows.net/asset-45e9d211-2a82-47fd-91f1-a8b64d47cb1e/175%20FacilitatingOrganizationalRoutinesProceduresStrategies_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-05-13T17%3A08%3A24Z&se=2016-05-12T17%3A08%3A24Z&sr=c&si=2099cf8c-c01c-49ff-8142-075dacb6324c&sig=bELypdtXDP94yGYgo2nWko3SE7VJjcoEBoRcUBqPqz0%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H8')


----------------------------------------
 -- #7 --
 -- Video 18 --
 -- Title – Enhancing Social Development
 -- Summary – The purpose of this protocol is to focus making content explicit through explanation, modeling, representations and examples. 
 -- Content Area – special education
 -- Grade-level - elementary
  ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Enhancing Social Development',
		'',
		'The purpose of this protocol is to focus making content explicit through explanation, modeling, representations and examples.',
		'18 protocol nn.docx',
		'3:47',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-6ca476ad-66c3-4197-a703-061a733fd47c/18 Enhancing Social Development_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2709115.jpg?sv=2012-02-12&sr=c&si=337fbf3a-1f32-467e-8923-3d15a512ed06&sig=XqRDfFisoqcYAW8VEO1FViPXcZvx2nFMfMmbws3q5Lo%3D&se=2029-06-17T08:31:48Z',
		'https://evalwashington.blob.core.windows.net/asset-381e5cb9-7622-4eda-b054-3c49810d306f/18%20Enhancing%20Social%20Development_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=6078c9e4-e8ee-4deb-9064-eda758d7ff7b&sig=W%2BESHS%2Frq70DRF9Glk%2BC4tdpv6rfJZT2R2whAYEQgXo%3D&st=2014-06-21T08%3A23%3A41Z&se=2016-06-20T08%3A23%3A41Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Special Education', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1')


----------------------------------------
 -- #8 --
 -- Video 134 --
 -- Title – Instructional Analysis: Small Group Mathematical Collaborations
 -- Summary - The purpose of this activity is to use a video clip to improve practice around the high-leverage strategies of setting up and managing small group work. 
 -- Content Area – mathematics
 -- Grade-level – Secondary
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Instructional Analysis: Small Group Mathematical Collaborations',
		'',
		'The purpose of this activity is to use a video clip to improve practice around the high-leverage strategies of setting up and managing small group work.',
		'34 protocol nn.docx',
		'1:30-4:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-a6a9b7d5-b1f0-481a-a2a3-5f6b533f4cc2/134 Instructional Analysis- Small-Group Math Collaboration_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4504017.jpg?sv=2012-02-12&sr=c&si=d279fe5f-f710-4dca-8feb-eac31449c56f&sig=0cKBnam4H2l4pBSIBgEBxcZU%2Bo9EgBM0lINorFu7K0U%3D&se=2029-06-17T08:34:46Z',
		'https://evalwashington.blob.core.windows.net/asset-74d752fe-b68e-4101-a634-bd9e7f0e4949/134%20Instructional%20Analysis-%20Small-Group%20Math%20Collaboration_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=89416a7f-0a39-4561-be98-b9155326dcd7&sig=wnGc%2FxT%2FQW1li6Kkt9HRoSQnr0lWuNf0jWceL94TxA8%3D&st=2014-06-21T08%3A23%3A40Z&se=2016-06-20T08%3A23%3A40Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C4', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7', 'H8')


----------------------------------------
 -- #9 --
 -- Video 292 --
 -- Title – Eliciting and Interpreting Individual Student Thinking
 -- Summary – This protocol focuses on eliciting and interpreting individual student thinking, avoiding judgment and evaluative language.
 -- Content Area – mathematics
 -- Grade-level – middle level
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Eliciting and Interpreting Individual Student Thinking',
		'',
		'This protocol focuses on eliciting and interpreting individual student thinking, avoiding judgment and evaluative language.',
		'292 protocol nn.doc',
		'0:41-2:47',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-29b3ab99-0db7-4b43-966a-3acef94611c9/292 Instruction Analysis- Small-Group Math Collaboration_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.2610757.jpg?sv=2012-02-12&sr=c&si=8b853e06-599e-4f6a-b3a6-4ed6292546cd&sig=kp2hFk%2BYOWMn0lnT5oDo5sSgmKWa6RtBgnLYgkAmDYQ%3D&se=2029-06-17T08:37:08Z',
		'https://evalwashington.blob.core.windows.net/asset-0bc3f3b3-411e-4fdb-927b-8be8f9d42b47/292%20Instruction%20Analysis-%20Small-Group%20Math%20Collaboration_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=ff12a8a4-834d-4d46-b83a-ca5e9029e197&sig=jIXHOW9SskYaMjeudu5yTwsm1vypxQoZqTTk9jT0bO0%3D&st=2014-06-21T08%3A23%3A32Z&se=2016-06-20T08%3A23%3A32Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')


-- UPDATE VideoPoster, VideoSrc to following
-- Video96.pdf
-- Video217.pdf
-- Video74.pdf
-- Video214.pdf

UPDATE	dbo.SETrainingProtocol 
SET		VideoPoster = 'https://evalwashington.blob.core.windows.net/asset-88d87378-83ba-467a-aea8-49cc801cb90d/96 Constructing Meaning Through Reading_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.1012571.jpg?sv=2012-02-12&sr=c&si=ed2cd0f4-462b-428f-8535-238fdd35c2e8&sig=BpTGWVwIaP4VDAvnNGjYwQleyo10PrzK85wvLrkWcnM%3D&se=2029-06-17T14:38:15Z',
		VideoSrc = 'https://evalwashington.blob.core.windows.net/asset-fb50ba6a-ebec-4fa2-b30c-ac003b258209/96%20Constructing%20Meaning%20Through%20Reading_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=79dd8d23-4474-4a1d-ae5c-ed24f59312c7&sig=et5pOxL8m8hyWo7qkhrwJOOukUNYKzFB80%2B21pc61s4%3D&st=2014-06-21T14%3A24%3A56Z&se=2016-06-20T14%3A24%3A56Z'
WHERE	[DocName] = 'Video96.pdf'


UPDATE	dbo.SETrainingProtocol 
SET		VideoPoster = 'https://evalwashington.blob.core.windows.net/asset-d51e9873-0483-443d-8426-5182b4d972c9/217 Instructional Analysis-Whole Class Math Discourse_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.6958367.jpg?sv=2012-02-12&sr=c&si=deb59340-9210-4d10-9e3c-e55fcdb14e77&sig=iu4%2F4jsJz7BNxrLcAk0McAQqdsKMHYyYkFrFfkQGH1M%3D&se=2029-06-17T14:35:53Z',
		VideoSrc = 'https://evalwashington.blob.core.windows.net/asset-22154d79-decc-40ee-90ba-0f3c813dece3/217%20Instructional%20Analysis-Whole%20Class%20Math%20Discourse_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=960e59b7-b403-4c1a-a8d4-6d56456be0d4&sig=AEOzppmrmmeJXy3tF9R%2BflplMGCoPtYs09LeE2w3hk8%3D&st=2014-06-21T14%3A25%3A00Z&se=2016-06-20T14%3A25%3A00Z'
WHERE	[DocName] = 'Video217.pdf'


UPDATE	dbo.SETrainingProtocol 
SET		VideoPoster = 'https://evalwashington.blob.core.windows.net/asset-b86d6b18-91b2-4672-b968-18b9be6ca4df/74 Facilitating Interactions-Small Groups_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4009433.jpg?sv=2012-02-12&sr=c&si=b87b7d15-80b3-4340-8308-ab6ed76a4651&sig=PjfJnxRPVlCUBiYdNX6pIXbQ9m%2BuJvUwXJuNpO%2BpVb4%3D&se=2029-06-17T14:33:07Z',
		VideoSrc = 'https://evalwashington.blob.core.windows.net/asset-a333e364-0ced-49c5-b57f-d8102e7896c7/74%20Facilitating%20Interactions-Small%20Groups_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=076935b8-ec96-4dbe-bbd9-993950622c19&sig=J%2Fp6UcTlcN1Gu3UeaTKhLI3x470Y0NK0C472gacc2Hc%3D&st=2014-06-21T14%3A25%3A04Z&se=2016-06-20T14%3A25%3A04Z'
WHERE	[DocName] = 'Video74.pdf'


UPDATE	dbo.SETrainingProtocol 
SET		VideoPoster = 'https://evalwashington.blob.core.windows.net/asset-6a4a3cb8-33c0-432e-b54c-c3bd613f8e39/214 Fostering Health Literacy_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3008653.jpg?sv=2012-02-12&sr=c&si=014428a5-8183-4faa-9f48-95a604647931&sig=4EYOOchpK9RkhLK99pH1amjks4A16hxuqvvqnXolxM0%3D&se=2029-06-17T14:40:31Z',
		VideoSrc = 'https://evalwashington.blob.core.windows.net/asset-9a601b09-316e-47f1-86e6-a072e5c440b3/214%20Fostering%20Health%20Literacy_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=1b17091e-6633-4c1b-b573-acbb59a23924&sig=JTwvUZuohDQ6ifNJUDLIXh8CCCb%2F5B6FT0Q76zx01rw%3D&st=2014-06-21T14%3A24%3A49Z&se=2016-06-20T14%3A24%3A49Z'
WHERE	[DocName] = 'Video214.pdf'


----------------------------------------
 -- #10 --
 -- Video 51 --
 -- Title – Elementary English Language Arts: Small-Group 
 -- Summary - The purpose of this activity is to use a video clip to improve practice around the high-leverage strategy of identifying and implementing an instructional response to common patterns of student thinking.
 -- Content Area – special education
 -- Grade-level – elementary
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Elementary English Language Arts: Small-Group',
		'',
		'The purpose of this activity is to use a video clip to improve practice around the high-leverage strategy of identifying and implementing an instructional response to common patterns of student thinking.',
		'51 protocol nn.docx',
		'3:30 – 7:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-a7860bce-c362-4ad9-afb2-304193a4bbda/51-Fostering Communications Development_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4188226.jpg?sv=2012-02-12&sr=c&si=87e09908-4205-411c-9866-43d198bc4747&sig=naUmzp1tZ0FB3Hhcyr8IrJF99MM8H3m2B%2B6PQXTtkk8%3D&se=2029-06-19T05:37:00Z',
		'https://evalwashington.blob.core.windows.net/asset-8911a5cf-00af-49a6-bfd2-b47475dd34a6/51-Fostering%20Communications%20Development_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=e53d8669-54aa-4d30-b6b0-11d39b6f5122&sig=VgBOzbRprBOtCzvPalyucU5ocG6FzUBD6TmUIUFUxR8%3D&st=2014-06-21T17%3A18%3A58Z&se=2016-06-20T17%3A18%3A58Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Special Education', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C3', 'C4', 'C6')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H5', 'H8')

----------------------------------------
 -- #11 --
 -- Video 376 --
 -- Title – Engaging in Relationship-Building Conversations With Students
 -- Summary – The purpose of this protocol is to focus on the practice of engaging students in relationship-building conversations.  
 -- Content Area – special education
 -- Grade-level – secondary 
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Engaging in Relationship-Building Conversations With Students',
		'',
		'The purpose of this protocol is to focus on the practice of engaging students in relationship-building conversations.',
		'376 protocol nn.docx',
		'7:54-10:04',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-7a079fef-3e24-40ce-a2dd-5fe37b5295c8/376 - Fostering Communications Development-SD_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.3012462.jpg?sv=2012-02-12&sr=c&si=9b4148a4-3825-4604-ae65-a3f0856dd8e7&sig=s7AvT573Qi6C3EX5NMoIUBeU2h1ebnSI7tOSW6gIAfA%3D&se=2029-06-19T05:38:38Z',
		'https://evalwashington.blob.core.windows.net/asset-0fb9fa2e-2fbc-4ded-9ab1-4dccabd7815c/376%20-%20Fostering%20Communications%20Development-SD_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=913d594a-212a-4b25-b15c-b925b61bf180&sig=MJtILnKYSBtwt4nonaseEMaRVIMWE0jPeg%2BjI%2FaTnug%3D&st=2014-06-21T17%3A26%3A22Z&se=2016-06-20T17%3A26%3A22Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Special Education', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C3', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H10')

----------------------------------------
 -- #12 --
 -- Video 17 --
 -- Title – CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary – The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content Area – math
 -- Grade-level – middle level 
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'17 protocol nn.doc',
		'Segments: 5:00 – 6:00 and 8:30 – 9:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-235b0bb2-8e8f-41b6-b871-a12640bbeb2d/Middle Math 17_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.1712145.jpg?sv=2012-02-12&sr=c&si=bb73e4ca-650c-45d3-8880-e6d171fa7a97&sig=aE2wklv9Mq9xjkq1ew8U%2Be%2BszEQwHzXUBMD8FIN0%2F8I%3D&se=2029-06-20T05:13:51Z',
		'https://evalwashington.blob.core.windows.net/asset-0bc9e723-3437-41a2-a7ed-16bef6479661/Middle%20Math%2017_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=c285c96d-3a59-4321-95e0-8deb84ef558a&sig=eFY0DN78KLDwoXHUgBYewcqCg1p%2F4loFI5NY6K%2F4Ubk%3D&st=2014-06-24T05%3A13%3A34Z&se=2016-06-23T05%3A13%3A34Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #13 --
 -- Video 235 --
 -- Title – CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary - The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content Area – math
 -- Grade-level – middle level
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'235 protocol nn.doc',
		'Segment: 4:16 – 9:30 and 9:58 – 11:04',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-a656e7cc-6a3c-49f9-a6af-14c02da0c032/Middle Math 235_H264_4500kbps_AAC_und_ch2_128kbps_00.00.04.1463873.jpg?sv=2012-02-12&sr=c&si=0e1ece8e-2ba3-4730-a2c2-2865387b4cbe&sig=yRqRUF5Kp6VFa7JE37HBKyHFtbZ6smmOAxB2W8uYWew%3D&se=2029-06-20T05:12:26Z',
		'https://evalwashington.blob.core.windows.net/asset-8b9ca6d9-a8f2-4169-b8c2-02b832c90d02/Middle%20Math%20235_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=a6bf3b76-4b37-4abb-aa36-3f95bedfd372&sig=OwBn2jghqCJ%2F9FJuacuF7YQHf%2BA0UYv5R3%2FFOsquw5E%3D&st=2014-06-24T05%3A13%3A42Z&se=2016-06-23T05%3A13%3A42Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #14 --
 -- Video 238 --
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: middle level
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'238 protocol nn.doc',
		'Segment: 0:00 – 2:00 and 3:00 – 8:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-57377b28-d8d6-4d8f-974c-506773ebeaa8/Middle Math 238_H264_4500kbps_AAC_und_ch2_128kbps_00.00.04.1858612.jpg?sv=2012-02-12&sr=c&si=e5e191d7-5471-4964-9188-5250b75c1053&sig=YY8ymH4bc76P31BWGFrMgN90XhNJr09tag51CmWwjfU%3D&se=2029-06-20T05:10:50Z',
		'https://evalwashington.blob.core.windows.net/asset-1a7b3960-d4ae-4daf-9a31-9c09ec112c06/Middle%20Math%20238_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=7457fc89-4197-4a1c-9358-818e869db6be&sig=UfpBAmiCbN82F4%2BFIr1b%2BlW2KsOD0DEb2%2FgQh%2FIjBIA%3D&st=2014-06-24T05%3A13%3A47Z&se=2016-06-23T05%3A13%3A47Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #15 --
 -- Video 263 --
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: middle level
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'263 protocol nn.doc',
		'Segment: 0:20 – 4:02',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-b216ff68-5b7a-46a9-9070-3d76f3ada46e/Middle Math 263_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2209886.jpg?sv=2012-02-12&sr=c&si=5c5ef6de-19b2-4c90-9046-bdc1993a3078&sig=aUj3Omtrz4GJhRWuS29bEWQRTCCanGZ5VwXR%2FcIGex4%3D&se=2029-06-19T06:59:10Z',
		'https://evalwashington.blob.core.windows.net/asset-2c93a5ea-7f5c-464a-812e-7a98c500fbb5/Middle%20Math%20263_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=c5b9b07c-a296-4cc7-9f6b-91d57fce3a78&sig=FShM1tE6ocYho93WXAXNTDYiqxUppS5KJfSQHyjuMFg%3D&st=2014-06-23T06%3A46%3A02Z&se=2016-06-22T06%3A46%3A02Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #16 --
 -- Video 271 --
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: middle level
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'271 protocol nn.doc',
		'Segment: 2:45 – 4:45',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-9d231e29-7c58-4ba8-b5c3-798832ff76c6/Middle Math 271_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.2009360.jpg?sv=2012-02-12&sr=c&si=35d6172a-d8dd-4530-9fe6-643872dfbc0b&sig=cOplqCOjEBPRudAz3HYsNvecTPbhvmivOOVkD%2FrYNxI%3D&se=2029-06-19T06:55:08Z',
		'https://evalwashington.blob.core.windows.net/asset-650e8db4-8afd-48e7-94b4-d390826a160c/Middle%20Math%20271_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=12e1b72d-ce52-4b36-8341-f6d3772c452a&sig=xSA97pUJFDEYtV8VZL0agOWcsTOxQdnaTEptV%2BXKQmw%3D&st=2014-06-23T06%3A45%3A53Z&se=2016-06-22T06%3A45%3A53Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #17 --
 -- Video 339: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: secondary 
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'271 protocol nn.doc',
		'Segments: 3:30 – 6:15',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-2335e823-1d1f-438e-83f2-32e2c004c908/High School Math 339_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.6504743.jpg?sv=2012-02-12&sr=c&si=3a9b41a9-6290-4c65-a9c8-4c0a0768a3cd&sig=rsMygZ0QHyyi3jP0tQmbtCEqwfBtQhERyRhVcmehtPo%3D&se=2029-06-19T07:40:32Z',
		'https://evalwashington.blob.core.windows.net/asset-5eed6f14-63ad-4b96-81bd-965e4a8fe36d/High%20School%20Math%20339_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=70fd4568-899e-4273-b782-8810919ce8f7&sig=IYpLIEj0v4iaGs7ZmUm8yuNMQNYQHLmPaeePPiGdBfM%3D&st=2014-06-23T06%3A46%3A17Z&se=2016-06-22T06%3A46%3A17Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #18 --
 -- Video 341: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: secondary 
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'341 protocol nn.doc',
		'Segments: 6:30 – 10:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-21fcfa24-6771-4732-ba61-65aa9cdfd846/High School Math 341_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4011755.jpg?sv=2012-02-12&sr=c&si=a33ece9e-9397-462d-8e03-226c1516ac0d&sig=F6Mz8gGTU88Arot%2BzhyFRhBJ85iJ2ClxAS%2BMvNkWFfQ%3D&se=2029-06-19T08:24:38Z',
		'https://evalwashington.blob.core.windows.net/asset-fef9b645-0546-41e9-b9b8-14c5277cbd75/High%20School%20Math%20341_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=26bc349b-73d0-4167-bd80-e5f6fbfc38d6&sig=PLWiq9B%2BLGNBrxCMgVNF2g8KT9%2FlFn2XammFa3ryDHI%3D&st=2014-06-23T06%3A46%3A11Z&se=2016-06-22T06%3A46%3A11Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #19 --
 -- Video 347: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: high school 
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'347 protocol nn.doc',
		'Segment: 6:46 – 11:46',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-dade5f5b-3f57-4448-86f1-467eea26bf3f/High School Math 347_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0011791.jpg?sv=2012-02-12&sr=c&si=16944d7a-d764-4e57-84e8-c36dd8500719&sig=a5mt1bGGw7KUgKkdN2DskI2nQ2wAIUf0noY5VB6n%2FMc%3D&se=2029-06-19T07:30:06Z',
		'https://evalwashington.blob.core.windows.net/asset-44c6929f-7439-44ed-92cf-89935d8aae17/High%20School%20Math%20347_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=c249ac67-c0b7-42af-bbd7-f26754ec0ba1&sig=tzXFxd0FOGA1Lzxuu%2BAAoSOY8R6%2BUY4Bunwbvx0dp7o%3D&st=2014-06-23T06%3A46%3A06Z&se=2016-06-22T06%3A46%3A06Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #20 --
 -- Video 352: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: high school 
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'352 protocol nn.doc',
		'Segment: 5:00 – 8:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-6c2732f1-4d1a-4046-afc8-f82d27049b39/High School Math 352_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.8011718.jpg?sv=2012-02-12&sr=c&si=1c4ab850-a703-45f2-8feb-8804a0ffabd3&sig=enoyd0XyGx3N8%2BDj%2B0GntZ6QMd9lwwRskg2mH0lkxcY%3D&se=2029-06-19T07:42:15Z',
		'https://evalwashington.blob.core.windows.net/asset-0242b680-9028-4072-88e2-374cba2a5fbe/High%20School%20Math%20352_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=8e98ebcf-6b22-4e61-9488-3dfdb9860885&sig=SZNISLmbklGmrU2OK6km7tYhLcEU4pVIif30ozwytqQ%3D&st=2014-06-23T06%3A46%3A18Z&se=2016-06-22T06%3A46%3A18Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #21 --
 -- Video 358: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: high school 
 -- Strategy Area: Content, Instructional
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'358 protocol nn.doc',
		'Segments: 0:15 – 3:40 and 7:00 – 9:50',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-dbac3ad3-f413-4f21-80ff-928e510dbdfd/High School Math 358_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.8456054.jpg?sv=2012-02-12&sr=c&si=b324f6fb-d172-4074-ac62-d4d6eab027d6&sig=fs21%2BZNjl8zXeWqETHHdzZfJv62Y5z1Qssq8JBdaZF0%3D&se=2029-06-19T07:44:02Z',
		'https://evalwashington.blob.core.windows.net/asset-9f2c042b-1e3f-447c-b42a-5c6e325a0dae/High%20School%20Math%20358_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=8d173050-43c9-46b7-90ef-392d2548eaea&sig=r0aA4QV4sMVWD4u2W5uIyH5diswD2o%2FPLb%2BD0CyGMCM%3D&st=2014-06-23T06%3A46%3A22Z&se=2016-06-22T06%3A46%3A22Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #22 --
 -- Video 360: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content area - math
 -- Grade Level: high school 
 -- Strategy Area: Content, Instructional
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'360 protocol nn.doc',
		'Segments: 2:10 – 8:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-19ac5621-4304-4b2e-ac5b-89b72f961c29/High School Math 360_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.5062131.jpg?sv=2012-02-12&sr=c&si=58a63d6e-27c7-4b3c-b3d6-8c61ddd856f4&sig=vyF1sM4DUUUNHMmWSRE68dFtqhzHdKS5SKjjZh75qDY%3D&se=2029-06-20T05:27:57Z',
		'https://evalwashington.blob.core.windows.net/asset-c22eac7e-7f15-4518-a87e-9737ed522642/High%20School%20Math%20360_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=f7433ad4-fb1b-4edf-bb86-bb9350910eda&sig=aJJ89iByGGG71QWdLg85PiuxDRycgKCEfk7tD4SWEww%3D&st=2014-06-24T05%3A24%3A12Z&se=2016-06-23T05%3A24%3A12Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')


----------------------------------------
 -- #23 --
 -- Video 48: 
 -- Title – CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary – The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content Area – math
 -- Grade-level – elementary 
 -- Strategy Area: Content, Instructional
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'48 protocol nn.doc',
		'Segments: 0:00 – 1:43 and 10:05 – 11:05',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-59f591af-95c8-4900-9679-c255cae6187b/48 - CCSS Coherence and Student Conversation Thinking and Learning_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.6302730.jpg?sv=2012-02-12&sr=c&si=c0eba12f-b061-4154-90b8-39a0772ba403&sig=ZFfVG8s85Tf559cnGzPcCLXfpONcty5vQTWjqYQMbpk%3D&se=2029-06-20T05:42:52Z',
		'https://evalwashington.blob.core.windows.net/asset-d404ae18-1e0c-407e-b907-991a5655dd11/48%20-%20CCSS%20Coherence%20and%20Student%20Conversation%20Thinking%20and%20Learning_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=e79e3a3b-0599-4fc6-b09d-f10ce2a3916a&sig=UPqnrWGpYGGWBVLhi1lWATsl28eycImhleKFY5ycroo%3D&st=2014-06-24T05%3A35%3A48Z&se=2016-06-23T05%3A35%3A48Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #24 --
 -- Video 53: 
 -- Title – CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary - The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.  
 -- Content Area – math
 -- Grade-level – elementary
 -- Strategy Area: Content, Instructional
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'53 protocol nn.doc',
		'Segments: 3:38 – 4:19, 5:23 – 6:38, and 9:38 – 10:36',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-9f8cc122-62df-4d61-9344-fea5f87a8848/53 - CCSS_Coherence and Student Conversation Thinking and Learning_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.6876263.jpg?sv=2012-02-12&sr=c&si=1753ce6e-f1d9-41e7-9cf8-1d0ecc2de4b1&sig=TIthApL1GTPQekgkkyefulc%2FnVwyLkCuTrOtXQHbX1w%3D&se=2029-06-20T05:41:37Z',
		'https://evalwashington.blob.core.windows.net/asset-f235495f-3ec3-4857-88b8-472dc4e1ae25/53%20-%20CCSS_Coherence%20and%20Student%20Conversation%20Thinking%20and%20Learning_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=a4cb93b0-aeaf-4c44-aa11-fff79de0bb5f&sig=e9REPrxCEaHRiNcH2PwrHGFHgZ3j4XsWARWz8ORjc%2FQ%3D&st=2014-06-24T05%3A35%3A54Z&se=2016-06-23T05%3A35%3A54Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

----------------------------------------
 -- #25 --
 -- Video 249: 
 -- Title - CCSS Math: Coherence and Student Conversation, Thinking and Learning
 -- Summary: The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning. 
 -- Content area - math 
 -- Grade Level: elementary
 -- Strategy Area: Content, Instructional
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'CCSS Math: Coherence and Student Conversation, Thinking and Learning',
		'',
		'The purpose behind the video observations is to help teachers identify the high leverage practices aligned with the Common Core State Standards in Mathematics (CCSS-M) that demonstrates the cause and effect relationships between highly effective teaching practices and student conversation, thinking and learning.',
		'249 protocol nn.doc',
		'Segments: 0:45 – 1:30, 3:15 – 5:45 and 6:15 – 8:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-e0f275c8-edb4-4357-ac23-7e94ef890617/Elementary Math 249_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.5447582.jpg?sv=2012-02-12&sr=c&si=0a27246c-1c86-4f40-b47d-be53444d907a&sig=qsSMPAasqr2gDL2lFNx%2Fg7y8%2BrbxKZySZqprNiejQzA%3D&se=2029-06-20T05:40:18Z',
		'https://evalwashington.blob.core.windows.net/asset-633a7eef-4ef6-4c12-91de-f6a99e94d8dc/Elementary%20Math%20249_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=bc1cc241-543d-4812-be00-459d05e88f80&sig=CytWUPPTfmKpDjxmz4vU75kHhLCO8Pk6%2B%2FwgX%2BUHIO8%3D&st=2014-06-24T05%3A36%3A04Z&se=2016-06-23T05%3A36%3A04Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H7')

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
