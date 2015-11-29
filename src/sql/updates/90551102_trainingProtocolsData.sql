
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

select @bugFixed = 90551102
, @title = '90551102 3rd set of Gates national board training protocols'
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

-- Subject Areas
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Social', 1)

-- Updates, new docs

/*
SELECT * FROM setrainingprotocol Where Title like '%Video 34%'

select distinct p.TrainingProtocolID, Title, p.* from setrainingprotocol p
  join SETrainingProtocolLabelAssignment a on a.TrainingProtocolID=p.TrainingProtocolID
  join setrainingprotocollabel l on l.TrainingProtocolLabelID=a.TrainingProtocolLabelID
  where p.docname<>''
    and Name<>'National Board'
 order by p.docname
*/

-- not sure how there are two
UPDATE SETrainingProtocol SET Retired=1 WHERE TrainingProtocolID=105

UPDATE SETrainingProtocol SET Title='Video 367: Engaging in Relationship-Building Conversations With Students' WHERE TrainingProtocolID=108
UPDATE SETrainingProtocol SET Title='Video 17: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=109
UPDATE SETrainingProtocol SET Title='Video 235: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=110
UPDATE SETrainingProtocol SET Title='Video 238: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=111
UPDATE SETrainingProtocol SET Title='Video 263: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=112
UPDATE SETrainingProtocol SET Title='Video 271: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=113
UPDATE SETrainingProtocol SET Title='Video 271: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=114
UPDATE SETrainingProtocol SET Title='Video 341: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=115
UPDATE SETrainingProtocol SET Title='Video 347: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=116
UPDATE SETrainingProtocol SET Title='Video 352: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=117
UPDATE SETrainingProtocol SET Title='Video 358: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=118
UPDATE SETrainingProtocol SET Title='Video 360: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=119
UPDATE SETrainingProtocol SET Title='Video 48: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=120
UPDATE SETrainingProtocol SET Title='Video 53: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=121
UPDATE SETrainingProtocol SET Title='Video 249: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=122
UPDATE SETrainingProtocol SET Title='Video 96: Constructing Meaning Through Reading' WHERE TrainingProtocolID=1
UPDATE SETrainingProtocol SET Title='Video 217: Whole Class Math Discourse' WHERE TrainingProtocolID=2
UPDATE SETrainingProtocol SET Title='Video 74: Facilitating Interactions—Small Groups' WHERE TrainingProtocolID=3
UPDATE SETrainingProtocol SET Title='Video 214: Teaching a Lesson' WHERE TrainingProtocolID=4
UPDATE SETrainingProtocol SET Title='Video 42: Eliciting and Interpreting Individual Students’ Thinking' WHERE TrainingProtocolID=98
UPDATE SETrainingProtocol SET Title='Video 259: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=99
UPDATE SETrainingProtocol SET Title='Video 163: Classroom Management' WHERE TrainingProtocolID=100
UPDATE SETrainingProtocol SET Title='Video 34: Faciliating Small Groups' WHERE TrainingProtocolID=101
UPDATE SETrainingProtocol SET Title='Video 79: Making Content Explicit Through Explanation Modeling, Representations and Examples' WHERE TrainingProtocolID=102
UPDATE SETrainingProtocol SET Title='Video 175: Facilitating Organizational Routines, Procedures, Strategies' WHERE TrainingProtocolID=103
UPDATE SETrainingProtocol SET Title='Video 18: Enhancing Social Development' WHERE TrainingProtocolID=104
UPDATE SETrainingProtocol SET Title='Video 34: Enhancing Social Development' WHERE TrainingProtocolID=105
UPDATE SETrainingProtocol SET Title='Video 292: Eliciting and Interpreting Individual Student Thinking' WHERE TrainingProtocolID=106
UPDATE SETrainingProtocol SET Title='Video 51: Small-Group' WHERE TrainingProtocolID=107
UPDATE SETrainingProtocol SET Title='Video 367: Small-Group' WHERE TrainingProtocolID=108

UPDATE SETrainingProtocol SET Description='Protocol focuses on the norms and routines about how people construct knowledge.' WHERE TrainingProtocolID=1
UPDATE SETrainingProtocol SET Description='Protocol focuses on teaching a lesson or segment of instruction.' WHERE TrainingProtocolID=4
UPDATE SETrainingProtocol SET Description='Protocol focuses on leading a whole class discussion, eliciting individual student thinking and establishing norms and routines for classroom discourse.' WHERE TrainingProtocolID=2
UPDATE SETrainingProtocol SET Description='Protocol focuses on implementing organizational routines, procedures, and strategies to support a learning environment.' WHERE TrainingProtocolID=3


UPDATE SETrainingProtocol SET DocName='FINAL video 34.pdf' WHERE TrainingProtocolID=105
UPDATE SETrainingProtocol SET DocName='FINAL video 17.pdf' WHERE TrainingProtocolID=109
UPDATE SETrainingProtocol SET DocName='FINAL video 18.pdf' WHERE TrainingProtocolID=104
UPDATE SETrainingProtocol SET DocName='FINAL video 34.pdf' WHERE TrainingProtocolID=101
UPDATE SETrainingProtocol SET DocName='FINAL video 42.pdf' WHERE TrainingProtocolID=98
UPDATE SETrainingProtocol SET DocName='FINAL video 48.pdf' WHERE TrainingProtocolID=120
UPDATE SETrainingProtocol SET DocName='FINAL video 51.pdf' WHERE TrainingProtocolID=107
UPDATE SETrainingProtocol SET DocName='FINAL video 53.pdf' WHERE TrainingProtocolID=121
UPDATE SETrainingProtocol SET DocName='FINAL video 74.pdf' WHERE TrainingProtocolID=3
UPDATE SETrainingProtocol SET DocName='FINAL video 79.pdf' WHERE TrainingProtocolID=102
UPDATE SETrainingProtocol SET DocName='FINAL video 96.pdf' WHERE TrainingProtocolID=1
UPDATE SETrainingProtocol SET DocName='FINAL video 163.pdf' WHERE TrainingProtocolID=100
UPDATE SETrainingProtocol SET DocName='FINAL video 175.pdf' WHERE TrainingProtocolID=103
UPDATE SETrainingProtocol SET DocName='FINAL video 214.pdf' WHERE TrainingProtocolID=4
UPDATE SETrainingProtocol SET DocName='FINAL video 217.pdf' WHERE TrainingProtocolID=2
UPDATE SETrainingProtocol SET DocName='FINAL video 235.pdf' WHERE TrainingProtocolID=110
UPDATE SETrainingProtocol SET DocName='FINAL video 238.pdf' WHERE TrainingProtocolID=111
UPDATE SETrainingProtocol SET DocName='FINAL video 249.pdf' WHERE TrainingProtocolID=122
UPDATE SETrainingProtocol SET DocName='FINAL video 259.pdf' WHERE TrainingProtocolID=99
UPDATE SETrainingProtocol SET DocName='FINAL video 263.pdf' WHERE TrainingProtocolID=112
UPDATE SETrainingProtocol SET DocName='FINAL video 271.pdf' WHERE TrainingProtocolID=113
UPDATE SETrainingProtocol SET DocName='FINAL video 271.pdf' WHERE TrainingProtocolID=114
UPDATE SETrainingProtocol SET DocName='FINAL video 292.pdf' WHERE TrainingProtocolID=106
UPDATE SETrainingProtocol SET DocName='FINAL video 341.pdf' WHERE TrainingProtocolID=115
UPDATE SETrainingProtocol SET DocName='FINAL video 347.pdf' WHERE TrainingProtocolID=116
UPDATE SETrainingProtocol SET DocName='FINAL video 352.pdf' WHERE TrainingProtocolID=117
UPDATE SETrainingProtocol SET DocName='FINAL video 358.pdf' WHERE TrainingProtocolID=118
UPDATE SETrainingProtocol SET DocName='FINAL video 360.pdf' WHERE TrainingProtocolID=119
UPDATE SETrainingProtocol SET DocName='FINAL video 367.pdf' WHERE TrainingProtocolID=108



DECLARE @ProtocolID BIGINT
DECLARE @FrameworkName VARCHAR(MAX)
SELECT @FrameworkName = name from seframework where derivedfromframeworkname ='Dan, StateView'

----------------------------------------
 -- Video 1 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 1: Classroom Management',
		'',
		'Protocol focuses on the norms and routines about how people construct knowledge.',
		'FINAL video 1.pdf',
		'0:00-3:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-f9ee-f1e4cc0ed7df/19_ENL_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.7504036.jpg?sv=2012-02-12&sr=c&si=af4f026f-5f88-444f-b125-14f9d43c37ea&sig=PL866t2zgtoY0FmHp2AhR%2BefIlqmjg32jhpbfEQyLWs%3D&se=2030-03-12T19:02:37Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-c061-f1e4cbbd46ad/19_ENL_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=7c03f33a-fe3e-4e8b-b83f-f06b924bdd4f&sig=T8CX0dE0iBwbYhzbEEWZKaoxuJ6FWz4flBMc8WXVs6A%3D&st=2015-04-26T19%3A52%3A58Z&se=2115-04-02T19%3A52%3A58Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H4')

----------------------------------------
 -- Video 2 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 2: Instructional Analysis Small-Group',
		'',
		'Protocol focuses establishing norms and routines and sets up and manages small group work.',
		'FINAL video 2.pdf',
		'7:00-12:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-f41c-f1e4cc0d9da6/2_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0081451.jpg?sv=2012-02-12&sr=c&si=d78324de-9653-4148-b4e2-1cdf3dcd36d5&sig=wd1zntfLTNcqeFdtaU5OeoHyl5wqaUZdegesk8STFFg%3D&se=2030-03-12T18:53:53Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-ed15-f1e4cbc822b7/2_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=8c2267cd-8e5e-424e-ae60-4869d20dc434&sig=xih5djvWdbD0WDoVamZWCyTOCNigO8EPgnSjQr%2FM4ZQ%3D&st=2015-04-26T23%3A12%3A38Z&se=2115-04-02T23%3A12%3A38Z'
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
   and fn.ShortName IN ('C3', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H4', 'H9')
   
----------------------------------------
 -- Video 6 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 6: Learning to Study, Interpret, and Evaluate Art',
		'',
		'Protocol focuses on leading a whole class discussion and teahcing a lesson or segment of instruction.',
		'FINAL video 6.pdf',
		'9:00-14:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-2ccb-f1e4cc0d19bf/6_Art_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0041977.jpg?sv=2012-02-12&sr=c&si=3d5a9fa3-6586-477b-9075-f9256637a85e&sig=OBKZxEYo3Xi%2B6UbC%2BliduKSL8DamFZIkBSJ25RThlGc%3D&se=2030-03-12T18:50:14Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-09b6-f1e4cbcccd50/6_Art_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=6e448a64-53c2-402d-b47b-c92f6a258cbd&sig=OwhICtONg313F6vEPuY%2FyilWOy9BNTwiWLKP%2FX4E2qI%3D&st=2015-04-26T22%3A44%3A27Z&se=2115-04-02T22%3A44%3A27Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4', 'C5', 'C6')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H7')
   
----------------------------------------
 -- Video 13 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 13: Fostering Health Literacy',
		'',
		'Protocol focuses on making content eplicit through explanation, modeling and representation and setting up and managing small group work.',
		'FINAL video 13.pdf',
		'7:53-13:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-63d8-f1e4cc103c1c/13_Health_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.3713052.jpg?sv=2012-02-12&sr=c&si=87d2556e-d9c2-40bf-93b0-0588e8fa6903&sig=zAYydDmk%2BnWfd0hAAKH0%2BtOVqV7Ew8L6CIJxYh7VE%2BI%3D&se=2030-03-12T19:12:18Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-e8cb-f1e4cbb29002/13_Health_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=cbf9e624-1d3d-4326-821e-88b1a501b6d8&sig=A3immvRrCouPI2bnUvjAb5FqziNziwiMgN0OPvkEGO8%3D&st=2015-04-26T22%3A45%3A19Z&se=2115-04-02T22%3A45%3A19Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1', 'H9')
   
----------------------------------------
 -- Video 14 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 14: Integration of Technology',
		'',
		'Protocol focuses on designing a sequence of lessons toward a specific learning goal.',
		'FINAL video 14.pdf',
		'11:05-14:37',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-e99f-f1e4cc0bf275/Library Media 14_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.1230004.jpg?sv=2012-02-12&sr=c&si=59e558b9-a5ff-4410-9cf6-e458826321fd&sig=V1S1OMk%2BvEbfEPZu07TyWLOAQJ4WJikE5qjIfECgb6Y%3D&se=2030-03-12T18:41:58Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-11c2-f1e4cbd43813/Library%20Media%2014_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=68d63770-4bdd-439f-8674-acf98078872f&sig=vqTlwuCIrxgrzx3sG6MseidL9o2grznFpyoLwEUSdhU%3D&st=2015-04-26T22%3A46%3A20Z&se=2115-04-02T22%3A46%3A20Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H13')


----------------------------------------
 -- Video 16 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 16: Instructional Analysis Small Group Math Collaboration',
		'',
		'Protocol focuses on eliciting and interpreting individual students'' thinking.',
		'FINAL video 16.pdf',
		'7:58-12:15',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-26af-f1e4cc0b7f9b/Math 16_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.5755573.jpg?sv=2012-02-12&sr=c&si=dfebee11-ab24-4a65-bcdd-ffe111a9c60b&sig=B%2FLz%2FBeogs%2BpRCeFDWHYDgEaZ7h0IRyw8vPy7915E0s%3D&se=2030-03-12T18:38:36Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-60c0-f1e4cbd81a8a/Math%2016_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=a2a750cd-0ca8-482b-a73e-4d27279ae4a0&sig=73YfZqbzsZ%2FbyPfa%2F7O1kMH6r%2BgmJNnjezUMp10%2F%2FwY%3D&st=2015-04-26T22%3A47%3A10Z&se=2115-04-02T22%3A47%3A10Z'
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
   and fn.ShortName IN ('C2', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')
   
----------------------------------------
 -- Video 20 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 20: Managing Small Group Work',
		'',
		'Protocol focuses on setting up and managing small group work.',
		'FINAL video 20.pdf',
		'0:42-1:42 and 1:45-6:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-49d5-f1e4cc0e834f/20_ELA_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.1395701.jpg?sv=2012-02-12&sr=c&si=4a32eba5-64f4-4d96-b8ec-eb28690b2ff6&sig=mHqTm29U%2BOmDQSFexfUU3dx8ZQFpNztktJ6dU4yJI0Y%3D&se=2030-03-12T19:00:21Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-7280-f1e4cbc0a331/20_ELA_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=fd21e9ea-0e88-40d0-b8b9-ab90c3b88fd3&sig=diSwSUzaaHo2AUqxc2ZI%2Fmv7BDWVxwBsWhL415oUWz4%3D&st=2015-04-26T22%3A48%3A03Z&se=2115-04-02T22%3A48%3A03Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C2', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H9')
   
----------------------------------------
 -- Video 21 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 21: Promoting Social Understanding',
		'',
		'Protocol focuses on setting up and managing small group work.',
		'FINAL video 21.pdf',
		'1:00-3:38 and 10:55-13:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-3aeb-f1e4cc0e1690/21A_Social Studies-History_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.8175093.jpg?sv=2012-02-12&sr=c&si=6c627a5d-a19d-4134-9ded-27aabf235eaa&sig=AWgIjKWSY6BDzmSf3KJDH8i3k5DdM05WP6aQ2F6fyjc%3D&se=2030-03-12T18:57:13Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-440a-f1e4cbc5185c/21A_Social%20Studies-History_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=49cadd79-9450-4be4-bbe7-bbfec3472009&sig=J%2B17PNGoo8WvaEXRu2EZTfy9dFBwSn2UwRVrHBAlTxc%3D&st=2015-04-26T20%3A01%3A57Z&se=2115-04-02T20%3A01%3A57Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H9')

----------------------------------------
 -- Video 21B --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 21B: Promoting Social Understanding',
		'',
		'Protocol focuses on eliciting and interpreting individual students’ thinking.',
		'FINAL video 21B.pdf',
		'0:15-3:38',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-5c02-f1e4cc0dec4b/21B_Social Studies-History_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.0317460.jpg?sv=2012-02-12&sr=c&si=de196f6f-b1a9-42ed-8a39-9d8380bae748&sig=51GURq%2FFlYHgEvRvKXyClM7EkyGAizcxaO%2FBvEi%2BbyA%3D&se=2030-03-12T18:56:04Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-5eb4-f1e4cbc66ea9/21B_Social%20Studies-History_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=774515c0-87fe-48d7-9796-7f1d673538d8&sig=n5igI4eWWVsHLKZldr25A9ZI1pGOTqjlQdhv6jSa79Q%3D&st=2015-04-26T19%3A59%3A49Z&se=2115-04-02T19%3A59%3A49Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')
   
----------------------------------------
 -- Video 26 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 26: Integrating Mathematics with Science',
		'',
		'Protocol focuses on teaching a segment of a lesson and setting up and managing small group work.',
		'FINAL video 26.pdf',
		'5:30-8:37',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-1ed0-f1e4cc0dc80c/26_Generalist Math_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.8731537.jpg?sv=2012-02-12&sr=c&si=37154e21-267f-4358-bb0e-74a0235719a1&sig=XGIlF%2F8BcCVH0lpl6fT0JhGYhj6Awc2XHK%2BEXpXTT8U%3D&se=2030-03-12T18:54:49Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-8e6f-f1e4cbc7519a/26_Generalist%20Math_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=5ab5b490-5927-432e-afff-a008df54e6e3&sig=5Y7%2F4Av9CXFUwiAlMVeIN1nOONFOyDJAwGgyphwCUok%3D&st=2015-04-26T22%3A49%3A09Z&se=2115-04-02T22%3A49%3A09Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Science', 'Primary', 'National Board')

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
   and fn.ShortName IN ('H7','H9')
   

----------------------------------------
 -- Video 30 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 30: Building a Classroom Community through Social Studies',
		'',
		'Protocol focuses on eliciting and interpreting individual students'' thinking.',
		'FINAL video 30.pdf',
		'8:35-13:35',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-c65a-f1e4cc0c4d04/Generalist30_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0148000.jpg?sv=2012-02-12&sr=c&si=6efa37f8-57ed-4023-a218-eeb8bc2dec94&sig=fWFWCJZDdCnNWO%2FRCqz4K5fHchjEXUk9AUOPwv38caE%3D&se=2030-03-12T18:44:20Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-7a04-f1e4cbd2422e/Generalist%2030_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=ab179f37-3b2c-43b9-8ce9-df4dccc6d43a&sig=0VJKg31XyxUcmf8LrcYIicSLUffRc9OXidc6LEeWdTE%3D&st=2015-04-26T22%3A49%3A48Z&se=2115-04-02T22%3A49%3A48Z'
						)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')
   
   
----------------------------------------
 -- Video 59 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 59: Fostering an Appreciation of Literature',
		'',
		'Protocol focuses on making content explicit through explanation, modeling, representation and eliciting and interpreting students'' thinking.',
		'FINAL video 59.pdf',
		'0:45-2:43 and 6:56-10:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-23df-f1e4cc0d4391/59_Library Media_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0146466.jpg?sv=2012-02-12&sr=c&si=66673f45-8433-489b-9449-e1553c805fd4&sig=LN6CFHvSP50oqAW0uuSuAbyS0Dctdr5TPN5x6yN%2BqNc%3D&se=2030-03-12T18:51:25Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-0e95-f1e4cbcb4901/59_Library%20Media_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=b64a1db5-8d2c-450c-b76e-31af67334c25&sig=VxaAUifICtJJyPiBB53dd4CnnQgr3kDz0KeFNf4421o%3D&st=2015-04-26T22%3A50%3A22Z&se=2115-04-02T22%3A50%3A22Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1','H3')
   
----------------------------------------
 -- Video 61 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 61: World Languages Other Than English - Build Communicative and Cultural Competence',
		'',
		'Protocol focuses on leading a whole group discussion.',
		'FINAL video 61.pdf',
		'0:00-1:00 and 10:00-13:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-848f-f1e4cc0b00c0/World Languages 61_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3900298.jpg?sv=2012-02-12&sr=c&si=2a9195d3-8da0-48dc-be5a-e4572df04035&sig=iazdZQK96gl9Yi4eB1Gj8sqedtn452nviaJQhCXJ%2FzQ%3D&se=2030-03-12T18:35:17Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-8115-f1e4cbdc0127/World%20Languages%2061_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=6d252df1-0d67-4076-a0f9-ca38766346a6&sig=Jj%2BzLEV%2BBj9PPMLs6fc98KmsnKxwK6GwmWexcz0zET4%3D&st=2015-04-26T22%3A51%3A23Z&se=2115-04-02T22%3A51%3A23Z'
						)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2')
   
   
 ----------------------------------------
 -- Video 75 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 75: Making Content Explicit Through Explanation Modeling, Representations and Examples',
		'',
		'Protocol focuses on making content explicit to providing all students with access to fundamental ideas and practices in any given subject.',
		'FINAL video 75.pdf',
		'2:00-5:23',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-1209-f1e4cc0cefe6/75_Physical Education_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.0345324.jpg?sv=2012-02-12&sr=c&si=0cf20c2e-8dca-4ada-b5a7-0f6367855ece&sig=ps7zyhp4%2BDJjlpfypBpVktrbnJ0QOfQ%2BQjwEuIv3On0%3D&se=2030-03-12T18:49:03Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-d9ff-f1e4cbcdf7ea/75_Physical%20Education_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=b812fd85-207d-4845-b9c6-1595d5d8234f&sig=jusRHegoUWxlRWe6eyDLpmGIrXaraXm%2FChd%2F7hzse8U%3D&st=2015-04-26T22%3A52%3A00Z&se=2115-04-02T22%3A52%3A00Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1')
   
----------------------------------------
 -- Video 77 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 77: Fostering Civic Competence',
		'',
		'Protocol focuses on leading whole-class discussion and eliciting individual student thinking.',
		'FINAL video 77.pdf',
		'6:00-11:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-3589-f1e4cc0cc5e1/77_Social Studies-History_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.9993215.jpg?sv=2012-02-12&sr=c&si=a8230c4a-a407-425a-ba3b-3f6c4e384657&sig=tcGT60dDBKwd664oiQRPgWfj0ug8Sef9toZqcnq%2BbD8%3D&se=2030-03-12T18:47:52Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-a610-f1e4cbcec2f2/77_Social%20Studies-History_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=d7b11f74-346a-40ba-becc-a9afa857f539&sig=%2Fco%2Bg2crn1gYkh1C2wblyzIhtvbB9GEoAk9cs9y%2Bzjk%3D&st=2015-04-26T22%3A52%3A31Z&se=2115-04-02T22%3A52%3A31Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H3')
   
----------------------------------------
 -- Video 87 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 87: Learning to Study, Interpret, and Evaluate',
		'',
		'Protocol focuses on leading a whole class discussion and eliciting and interpreting individual students'' thinking.',
		'FINAL video 87.pdf',
		'0:47-1:30 and 9:50-12:50',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-7bd4-f1e4cc0ca196/87_Art_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2200598.jpg?sv=2012-02-12&sr=c&si=56662edf-bfc6-4e0a-996a-8c57b322f590&sig=Uvr2lm%2FFnXfSdiXwiwsAsaeW9wawkimfHaDpwBM0auo%3D&se=2030-03-12T18:46:42Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-5f0a-f1e4cbd0580f/87_Art_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=ab9ac25b-aaa5-49a6-9c98-5178f2f1ff9f&sig=9wBgGe0FaWsZzI5NM%2BbAythnv4PCDCIu9%2FI7i2r3UGw%3D&st=2015-04-26T22%3A53%3A02Z&se=2115-04-02T22%3A53%3A02Z'
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
   and fn.ShortName IN ('C4', 'C5', 'C6')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H3')
   
   
----------------------------------------
 -- Video 94 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 94: Science Inquiry through Investigation',
		'',
		'Protocol focuses on leading a whole class discussion and eliciting and interpreting individual students'' thinking.',
		'FINAL video 94.pdf',
		'7:23-11:07',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-dd8e-f1e4cc0c713d/94_Science_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2453696.jpg?sv=2012-02-12&sr=c&si=52b96f9c-1275-4e16-add3-52b20a4ff711&sig=ms5InhHBFGuddEbXyxb29eJyuASDdMn5TUzxZXT23us%3D&se=2030-03-12T18:45:33Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-af3b-f1e4cbd1592b/94_Science_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=65aa2c2b-3eb3-4883-b851-6dd385afc8f9&sig=315MUfcvXQOv310znCN30uxi3fe%2B8gyr1gFIdgcdt24%3D&st=2015-04-26T22%3A53%3A32Z&se=2115-04-02T22%3A53%3A32Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Intermediate', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H3')
   
----------------------------------------
 -- Video 102 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 102: Instruction to Facilitate Student Learning',
		'',
		'Protocol focuses on engaging in strategic relationship-building conversations with students.',
		'FINAL video 102.pdf',
		'4:32-7:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-212e-f1e4cc0b30ee/Phys Ed 102_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.4844516.jpg?sv=2012-02-12&sr=c&si=8d5c5d9f-c6a5-4ab8-bf3e-31aea82cebcf&sig=Uekv0hRITwilYR%2BlEsH4opf33M1SCXY%2FhR7r1PqDpeY%3D&se=2030-03-12T18:36:25Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-1546-f1e4cbdac44d/Phys%20Ed%20102_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=bbc2dcfe-a0e9-4c1e-b441-746489f23e05&sig=GM3xNTizzIycovL%2BgpYXFob934edtQJvuQFak5V%2F%2BpQ%3D&st=2015-04-26T22%3A39%3A41Z&se=2115-04-02T22%3A39%3A41Z'
	)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Intermediate', 'Secondary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C3')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H10')
   
----------------------------------------
 -- Video 103 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 103: Literacy - Reading Language Arts',
		'',
		'Protocol focuses on eliciting and interpreting individual students’ thinking.',
		'FINAL video 103.pdf',
		'1:58-3:32 and 8:35-9:50',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-4585-f1e4cc11c4aa/103_Literacy_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.6671927.jpg?sv=2012-02-12&sr=c&si=04eab4ca-892a-49ac-94a4-6a083f7271e7&sig=M0Mq%2FedVbO%2Bjr3oKpMqjMvIxn6EPUjJ9oRZIJ733VWI%3D&se=2030-03-12T19:23:26Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-de9f-f1e4cb99dd9d/103_Literacy_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=423df62c-b722-464a-8acc-528036e9feb0&sig=PxVNGTEr61UQh5yQ9VT0cbS65SGC5mnd0L%2FkIbMpN8s%3D&st=2015-04-26T22%3A42%3A12Z&se=2115-04-02T22%3A42%3A12Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')
   
----------------------------------------
 -- Video 107 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 107: Fostering Positive Relationships',
		'',
		'Protocol focuses on engaging in strategic relationship-building conversations with students.',
		'FINAL video 107.pdf',
		'0:43-2:04 and 2:17-14:42',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-aaf7-f1e4cc11a68b/107_CTE_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2439764.jpg?sv=2012-02-12&sr=c&si=31fa9804-c057-4e48-80b8-30debcd114a7&sig=TkRhy7K9DPeiSdNh1X9tDgpKBiCeMoGNhmBWYaX7j6Y%3D&se=2030-03-12T19:22:25Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-7adc-f1e4cb9b22e0/107_CTE_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=4113f6b8-e52e-4677-b541-6a90242ea5d2&sig=lBP5Td0ZYzlFw3xKTHDpp6bwPs%2FfelFCDXHejWfZYKc%3D&st=2015-04-26T22%3A43%3A16Z&se=2115-04-02T22%3A43%3A16Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H10')
   
----------------------------------------
 -- Video 111 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 111: Instructional Analysis',
		'',
		'Protocol focuses on making content explicit through explanation, modeling and representation and leading a whole-class discussion.',
		'FINAL video 111.pdf',
		'3:42-8:42',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-ada0-f1e4cc117c40/111_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0160398.jpg?sv=2012-02-12&sr=c&si=38ada939-a32f-45ff-b53e-dc76123dd47f&sig=6s8Tgr%2BKAsjRxUCkKQyOIM30lEOD9YsKtiRZTd1neA4%3D&se=2030-03-12T19:21:29Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-438c-f1e4cb9c41ed/111_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=c9df77aa-d44a-4a98-b394-5776d4f79173&sig=8uwBR37UCrdzjKAi1s7%2BEd2KeYe%2BbHCQBRD9o7ShekI%3D&st=2015-04-26T22%3A54%3A51Z&se=2115-04-02T22%3A54%3A51Z'
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
   and fn.ShortName IN ('C3', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1', 'H2')
   
----------------------------------------
 -- Video 112 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 112: Delivering Instruction',
		'',
		'Protocol focuses on teaching a lesson or segment of instruction.',
		'FINAL video 112.pdf',
		'0:00-3:58',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-5284-f1e4cc1151ee/112_Music_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3814385.jpg?sv=2012-02-12&sr=c&si=19d3b196-b3fc-4b4c-860c-38a998ec76d9&sig=PI6aj0Q7dhJLScn%2F%2F5VXn2Nlfb48lt8%2BCBXtXBEy9I0%3D&se=2030-03-12T19:20:18Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-8745-f1e4cb9d4a06/112_Music_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=a5c0fa2c-63f8-466b-9c58-7593b1dad083&sig=T9RwqolemQv5yo%2FnaSYx65Am0P%2Bul6nzRnh%2Bc8Gxij0%3D&st=2015-04-26T22%3A55%3A27Z&se=2115-04-02T22%3A55%3A27Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7')
   
   
----------------------------------------
 -- Video 113 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 113: Scaffolding Learning',
		'',
		'Protocol focuses on teaching a segment of a lesson and implementing organizational routines, procedures and strategies to support the learning environment.',
		'FINAL video 113.pdf',
		'0:00-2:32 and 9:30-12:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-1268-f1e4cc1121b2/113_ENL_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0095383.jpg?sv=2012-02-12&sr=c&si=2df99392-08d2-41fd-9233-3d6fc29a378d&sig=8RjJUpfLX53Arclm0dt6S2Dd3o04LMDUO3vW1NqSsyA%3D&se=2030-03-12T19:19:05Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-c1c8-f1e4cb9ee744/113_ENL_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=79cb97d1-723d-4048-8fff-29c7fec4b9d9&sig=ZiVFKS3ZsoGvx5i9QGzKH6qzHJfis%2BWEfyyM14X9euw%3D&st=2015-04-26T22%3A56%3A01Z&se=2115-04-02T22%3A56%3A01Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C3', 'C4', 'C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7', 'H8')
   

----------------------------------------
 -- Video 120B --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 120B: Instructional Analysis',
		'',
		'Protocol focuses on leading a whole group discussion and elicting and interpreting students'' thinking.',
		'FINAL video 120B.pdf',
		'9:20-14:20',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-8041-f1e4cc11038c/120B_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.0068000.jpg?sv=2012-02-12&sr=c&si=7304e586-995e-47a9-a99c-d783f2e89117&sig=%2FlTyW5ZmTnYsJYFSx7T%2Bi3GVG7A9YY9cPL0NEsa9JaM%3D&se=2030-03-12T19:17:55Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-bbee-f1e4cba047df/120B_Mathematics_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=872eea62-4ce6-40c8-895c-9fb3fba415ab&sig=sw%2FP1uXxeGKrlK4hFsEe3guu9HxZaBf2pL%2B9%2B0bFTos%3D&st=2015-04-26T20%3A27%3A46Z&se=2115-04-02T20%3A27%3A46Z'
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
   and fn.ShortName IN ('C2', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H3')

----------------------------------------
 -- Video 121 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 121: Active Scientific Inquiry',
		'',
		'Protocol focuses on setting up and managing small group work.',
		'FINAL video 121.pdf',
		'0:00-2:08 and 14:36-15:58',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-4a2b-f1e4cc10d91a/121_Science_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.0907246.jpg?sv=2012-02-12&sr=c&si=4dc6d4e4-65c5-4486-a0bf-2341d7353ad5&sig=kpV5tINj964ba8sv%2FpPdYwCmuXh1wI3DmKpr%2BSsevHU%3D&se=2030-03-12T19:16:59Z',
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-a1eb-f1e4cba1f6b9/121_Science_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=774287f3-528e-4b75-aeb4-3d929069742a&sig=oGK6qtg1STBtFdTpRwOZ%2BpTyD33MAGKJiylvqRZLVVc%3D&st=2015-03-16T07%3A36%3A44Z&se=2017-03-15T07%3A36%3A44Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H9')
   
   ----------------------------------------
 -- Video 128 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 128: Creating a Productive Learning Environment',
		'',
		'Protocol focuses on eliciting and interpreting individual students'' thinking.',
		'FINAL video 128.pdf',
		'0:00-4:09',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-175a-f1e4cc10aedf/128_Physical Education_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4904000.jpg?sv=2012-02-12&sr=c&si=cddeaaa7-3e7b-4f92-a271-c6f4a4b2ba32&sig=ykKqXELw%2FYguobg2%2FewKE8pS64Vj%2Bc5Jf28bqj4OMKQ%3D&se=2030-03-12T19:15:48Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-d172-f1e4cbaece3b/128_Physical%20Education_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=f0131b3e-a1ff-45a1-a6cf-4fc0a3b539fc&sig=j6XbOeo8J00SOINV8a0i2odzBdW4i18PfPDzWlkDCz0%3D&st=2015-04-26T22%3A56%3A58Z&se=2115-04-02T22%3A56%3A58Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H8')
   
----------------------------------------
 -- Video 132 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 132: Leading a Whole-Class Discussion',
		'',
		'Protocol focuses on learning a whole class discussion.',
		'FINAL video 132.pdf',
		'0:19-1:15 and 1:50-2:04 and 4:28-6:20 and 10:34-11:20',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-5245-f1e4cc1084a2/132_Art_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.2319020.jpg?sv=2012-02-12&sr=c&si=ceefc248-81ac-46d5-9a40-16078d5ecd59&sig=B7j%2FL95qu4ztH%2FsysvVAzElUtULryjjvBMhvcnSZAEE%3D&se=2030-03-12T19:14:40Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-a353-f1e4cbb046b7/132_Art_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=fe19f68b-c4fb-4d20-bdf4-f673f327a12c&sig=4c0jYlsXoA1o27ELemJb%2Fj%2BvxTy2b1OPZs%2BADVz6Ngk%3D&st=2015-04-26T22%3A57%3A25Z&se=2115-04-02T22%3A57%3A25Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Intermediate', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2')
   
----------------------------------------
 -- Video 137 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 137: Lesson Segmenting for Student Engagement',
		'',
		'Protocol focuses on teaching a lesson or segment of instruction.',
		'FINAL video 137.pdf',
		'0:45-5:05',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-f1ae-f1e4cc105a6e/137_Physical Education_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.6045823.jpg?sv=2012-02-12&sr=c&si=edc1d641-33d1-4931-9863-cc8dafbacc97&sig=uOXKfo8loZDQLpCba5wcGz7gmfye1Lcdrb%2BRfZ3IxZw%3D&se=2030-03-12T19:13:29Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-7306-f1e4cbb16362/137_Physical%20Education_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=c017e517-43be-491b-9150-ffb2bedaf0ce&sig=9yOnvcJHrYvXUkMbccwSH46qtmE%2BrdHq132x3UgxWWY%3D&st=2015-04-26T22%3A57%3A52Z&se=2115-04-02T22%3A57%3A52Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Primary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C3', 'C4', 'C5')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7')
   
----------------------------------------
 -- Video 154 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 154: Demonstrate Lesson',
		'',
		'Protocol focuses on teaching a lesson or segment of instruction and setting up and managing small group work.',
		'FINAL video 154.pdf',
		'0:00-2:56',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-c2ac-f1e4cc100be6/154_CTE_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.7672000.jpg?sv=2012-02-12&sr=c&si=c0675316-4dcc-41a7-88b9-694144ea091a&sig=LNmDtAJ4To2Y505nQHVHYpkoOnQ34GGENMYrNTJDRrc%3D&se=2030-03-12T19:11:20Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-223c-f1e4cbb3da27/154_CTE_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=e33fc44e-de55-41e5-816f-8eccab20c581&sig=hnOFVFp%2BNSHtD9LandutPP6c4Lk%2BYnvfCaid8aloATo%3D&st=2015-04-26T22%3A58%3A22Z&se=2115-04-02T22%3A58%3A22Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5', 'C6')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7', 'H9')
   
----------------------------------------
 -- Video 161 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 161: Probing Student Understanding',
		'',
		'Protocol focuses on making content eplicit through explanation, modeling and representation and leading whole class discussion.',
		'FINAL video 161.pdf',
		'0:00-2:00 and 4:17-5:29',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-c579-f1e4cc0fe78c/161_Science_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.9070548.jpg?sv=2012-02-12&sr=c&si=b11482d7-bcc9-4e6e-995d-c2d64349b565&sig=VumgB4UmXkVNVfvf56ruomFaVDLMPI1t%2FCpW4iQzJ4A%3D&se=2030-03-12T19:10:09Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-9756-f1e4cbb4fa84/161_Science_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=eccbf560-9244-45e5-82a4-7266b41d3d02&sig=Fvv%2BZNiOSxYaWxprcH06zQ0D05N0cQc0EwHdlrBEwb8%3D&st=2015-04-26T22%3A58%3A53Z&se=2115-04-02T22%3A58%3A53Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Intermediate', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1', 'H2')
   
 ----------------------------------------
 -- Video 167 --
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 167: Creative a Productive Learning Environment',
		'',
		'Protocol focuses on appraising, choosing and modifying tasks for a specific learning goal and designing a sequence of lessons toward a specific learning goal.',
		'FINAL video 167.pdf',
		'4:22-6:48 and 8:35-10:58',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-86fa-f1e4cc0fa537/167_Physical Education_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.8627882.jpg?sv=2012-02-12&sr=c&si=47becdf8-5c9e-407b-a293-ed6f0108c80d&sig=PMH6AvG16k1wsZE23TeFpRXaXsHBelSUJFWVeRgss%2Fc%3D&se=2030-03-12T19:08:08Z',
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-53b8-f1e4cbb73a07/167_Physical%20Education_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=46daf73c-c12b-4c44-a38b-e20502841b13&sig=jglj4DGCKaySQ9tJi3IGDa%2F3rDHajYUvElzTX2CUUT0%3D&st=2015-04-26T22%3A59%3A19Z&se=2115-04-02T22%3A59%3A19Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Primary', 'National Board')

SELECT * FROM dbo.SETrainingProtocolLabel

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C3', 'C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H12', 'H13')
   
   ----------------------------------------
 -- Video 183 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 183: Creating Productive Learning Environment',
		'',
		'Protocol focuses on teaching a lesson or segment of instruction.',
		'FINAL video 183.pdf',
		'0:00-4:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-4441-f1e4cc0f7add/183_PhysicalEducation_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.4056000.jpg?sv=2012-02-12&sr=c&si=06b4f0f4-353a-4aae-bc35-90489fce2521&sig=uV5UjaJH5YPShFSlzB3EhLdduW4DANPiTHefH%2BlWf38%3D&se=2030-03-12T19:07:10Z',
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-2e43-f1e4cbb888e3/183_Physical%20Education_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=b157258e-d588-4cce-a408-361fe1626649&sig=Y2UYWuEr70YXIxju%2FqERk%2FSVf0L3PPIwUnJE%2BbTEb2U%3D&st=2015-04-26T22%3A59%3A48Z&se=2115-04-02T22%3A59%3A48Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Health', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C1', 'C3', 'C5')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H7')
   
----------------------------------------
 -- Video 192 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 192: Scaffolding Learning',
		'',
		'Protocol focuses on making content explicit through explanation, modeling, representation and eliciting and interpreting students'' thinking.',
		'FINAL video 192.pdf',
		'3:45-7:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-f70c-f1e4cc0f5091/192_ENL_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.9588353.jpg?sv=2012-02-12&sr=c&si=0eb9ec4f-3f42-4c6d-aed4-df385674dcc6&sig=SkPKs10peU%2FXGXsSYAKodkG4y85E5WIm9H3XxI3iJlU%3D&se=2030-03-12T19:06:02Z',
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-57ce-f1e4cbb98e88/192_ENL_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=3fa29ec2-7bd5-4d43-b79e-423df889855e&sig=G1YIOKCDicGMCu5a4Qsk1HEE4AROzH%2FFaGTQHpyph2Q%3D&st=2015-04-26T23%3A00%3A19Z&se=2115-04-02T23%3A00%3A19Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H1', 'H3')
   
 ----------------------------------------
 -- Video 195 --
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 195: Promoting Social Understanding',
		'',
		'Protocol focuses on making content explicit through explanation, modeling, representation and examples.',
		'FINAL video 195.pdf',
		'4:21-6:51 and 8:50-10:15',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-c69d-f1e4cc0f2c4d/195_Social Studies-History_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.3387137.jpg?sv=2012-02-12&sr=c&si=a18e1fb6-c79b-4916-8ce4-5f312409a4de&sig=7WOXcKlkgKnL973W84X8vS2PfYBjkBZuBTJ58DgTAgA%3D&se=2030-03-12T19:04:48Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-f602-f1e4cbbabb87/195_Social%20Studies-History_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=96a88ff5-963b-465a-825a-0cb83bd1efb5&sig=sk8J%2Fj%2FZZdK5QetkK2HOtoHBkw65COsHOIqpooqT8bU%3D&st=2015-04-26T23%3A00%3A49Z&se=2115-04-02T23%3A00%3A49Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Primary', 'National Board')

SELECT * FROM dbo.SETrainingProtocolLabel

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
   and fn.ShortName IN ('H1')

----------------------------------------
 -- Video 202 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 202: Developing Musicianship',
		'',
		'Protocol focuses on selecting and using particular methosd to check understanding and monitor student learning.',
		'FINAL video 202.pdf',
		'1:00-3:30 and 8:45-10:45',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-97e8-f1e4cc0b5b4f/Music 202_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.6867809.jpg?sv=2012-02-12&sr=c&si=ebd4934e-272a-4d76-b7ec-ad2a8d2665b7&sig=cqu%2Bhm%2BGej3nsKzrfa9jBmsR%2F1NENU0pHafGabUtoQ4%3D&se=2030-03-12T18:37:36Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-baa6-f1e4cbd99fb0/Music%20202_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=9b432ef1-f916-4f45-a111-caec088e81a0&sig=1jktAY5GkXyvulx1o2HcXwqvzrP0lCE2lqeh1MWRodI%3D&st=2015-04-26T20%3A39%3A52Z&se=2115-04-02T20%3A39%3A52Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C2', 'C5')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H14')

----------------------------------------
 -- Video 202-2 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 202-2: Developing Musicianship',
		'',
		'Protocol focuses on checking for understanding and monitoring student learning.',
		'FINAL video 202-2.pdf',
		'9:20-11:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-97e8-f1e4cc0b5b4f/Music 202_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.6867809.jpg?sv=2012-02-12&sr=c&si=ebd4934e-272a-4d76-b7ec-ad2a8d2665b7&sig=cqu%2Bhm%2BGej3nsKzrfa9jBmsR%2F1NENU0pHafGabUtoQ4%3D&se=2030-03-12T18:37:36Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-baa6-f1e4cbd99fb0/Music%20202_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=9b432ef1-f916-4f45-a111-caec088e81a0&sig=1jktAY5GkXyvulx1o2HcXwqvzrP0lCE2lqeh1MWRodI%3D&st=2015-04-26T20%3A39%3A52Z&se=2115-04-02T20%3A39%3A52Z'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C6')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H14')
 ----------------------------------------
 -- Video 203 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 203: Fostering Civic Competence',
		'',
		'Protocol focuses on leading a whole class discussion and eliciting and interpreting individual students'' thinking.',
		'FINAL video 203.pdf',
		'3:50-9:00',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-0034-f1e4cc0ead91/203_Social Studies-History_H264_4500kbps_AAC_und_ch2_128kbps_00.00.03.1054367.jpg?sv=2012-02-12&sr=c&si=a74b25dc-60d9-4544-8d35-83902c3a47b8&sig=4pVh5gzUpTK1H2RsVgzOrc8rrkGHn2Rmf5wixwIVCTI%3D&se=2030-03-12T19:01:26Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-5872-f1e4cbbe837f/203_Social%20Studies-History_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=b10992f7-e758-420f-ad67-9fddbba10e6d&sig=R8W8WfRWTs55IKucUABM6UaRQCkqqY0VLhkWbWGPCSg%3D&st=2015-04-26T23%3A01%3A35Z&se=2115-04-02T23%3A01%3A35Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'National Board')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5')
INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H2', 'H3')
   
  ----------------------------------------
 -- Video 212 --
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 212: Engaging all Learners',
		'',
		'Protocol focuses on setting up and managing small group work.',
		'FINAL video 212.pdf',
		'2:00-4:30',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-effe-f1e4cc0e5f1d/212_World Languages_H264_4500kbps_AAC_und_ch2_128kbps_00.00.01.5065106.jpg?sv=2012-02-12&sr=c&si=d711d905-1c99-4c47-b4ed-9c0b2b0d91af&sig=nZJALmMULm0SYYf8yxmY%2BjFTnWeUbBgkO3fYP3OxS2A%3D&se=2030-03-12T18:59:02Z',
		'https://evalwashington.blob.core.windows.net/asset-8712445d-1500-80c2-607b-f1e4cbc215a3/212_World%20Languages_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=4e132b1e-1c1d-4733-bd2a-e88ed4c3dcc2&sig=xRJyCHrdtgVcd8GEcGuzm%2Bv55NRWep977U8pJqEPe94%3D&st=2015-04-26T23%3A02%3A04Z&se=2115-04-02T23%3A02%3A04Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C5')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H9') 
   
----------------------------------------
 -- Video 216 --
 ----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 216: Fostering an Appreciation of Literature',
		'',
		'Protocol focuses on eliciting and interpreting individual students'' thinking.',
		'FINAL video 216.pdf',
		'3:36-4:24',
		1,
		0,
		1,
		1,
		'https://evalwashington.blob.core.windows.net/asset-fd0c445d-1500-80c3-907f-f1e4cc0e40d6/216_Library Media_H264_4500kbps_AAC_und_ch2_128kbps_00.00.02.1887128.jpg?sv=2012-02-12&sr=c&si=694d2b76-5c3b-4f4a-b0fc-d3eb9676f54e&sig=HmF8%2BuB3Jmq9u3cuftqWWObiih6SfRCJ0%2BUuhrYRjus%3D&se=2030-03-12T18:58:04Z',
		'https://evalwashington.blob.core.windows.net/asset-cc1e445d-1500-80c2-f05b-f1e4cbc3536f/216_Library%20Media_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&sr=c&si=25097613-a213-4f6b-8d95-b454668fdb94&sig=vj9f7i3wsutAKTbM%2Ffle9nw4907Ni7uf43xuYcd4Yro%3D&st=2015-04-26T23%3A02%3A45Z&se=2115-04-02T23%3A02%3A45Z'
				)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'National Board')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   1
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.Name=@FrameworkName
   and f.SchoolYear=2014
   and fn.ShortName IN ('C4')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3')
   


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
