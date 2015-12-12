
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

select @bugFixed = 94591664
, @title = '94591664: The rest of the 3rd set of Gates national board training protocols'
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

DECLARE @ProtocolID BIGINT
DECLARE @FrameworkName VARCHAR(MAX)
SELECT @FrameworkName = name from seframework where derivedfromframeworkname ='Dan, StateView'

----------------------------------------
 -- Video 24 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 24: Demonstrating and Developing Musicianship',
		'',
		'Protocol focuses on making content explicit through explanation, modeling and representation and teaching a lesson or segment of instruction.',
		'FINAL video 24.pdf',
		'0:00-3:30 and 10:20-12:20',
		1,
		0,
		1,
		1,
		'',
		''
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Intermediate', 'National Board')

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
   and fn.ShortName IN ('H1', 'H7')

----------------------------------------
 -- Video 46 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 46: Large Group Presentation of Art History',
		'',
		'Protocol focuses on making content explicit through explanation, modeling, representation and eliciting and interpreting students'' thinking.',
		'FINAL video 46.pdf',
		'0:00-5:04 and 13:02-end',
		1,
		0,
		1,
		1,
		'',
		''
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Intermediate', 'National Board')

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
   and fn.ShortName IN ('H1', 'H3')
   
----------------------------------------
 -- Video 4 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 4: Planning',
		'',
		'Protocol focuses on engaging in strategic relationship-building conversations with students.',
		'FINAL video 4.pdf',
		'Whole Video',
		1,
		0,
		1,
		1,
		'',
		''	
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Intermediate', 'National Board')

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
   and fn.ShortName IN ('H10')
   
----------------------------------------
 -- Video 99 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 99: Student Engagement',
		'',
		'Protocol focuses on eliciting and interpreting individual students'' thinking and teaching a lesson or segment of instruction.',
		'FINAL video 99.pdf',
		'6:25-10:25',
		1,
		0,
		1,
		1,
		'',
		''
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
   and fn.ShortName IN ('C1', 'C2', 'C3')

INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
SELECT @ProtocolID,
	   fn.FrameworkNodeID,
	   0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SEFramework f on fn.frameworkid=f.frameworkid
 where f.SchoolYear=2014
   and fn.ShortName IN ('H3', 'H9')
   
----------------------------------------
 -- Video 65 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 65: Identifying High Leverage Practices in a Middle School Music Lesson',
		'',
		'Protocol focuses on identifying practices.',
		'FINAL video 65.pdf',
		'Whole Video',
		1,
		0,
		1,
		1,
		'',
		''
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Music', 'Intermediate', 'National Board')


----------------------------------------
 -- Video 29 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 29: Integration of Instructional Technologies',
		'',
		'Protocol focuses on teaching a lesson or segment of instruction..',
		'FINAL video 29.pdf',
		'4:00-9:17',
		1,
		0,
		1,
		1,
		'',
		''
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
		
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Intermediate', 'National Board')

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
   and fn.ShortName IN ('H7')
   
----------------------------------------
 -- Video 81 --
----------------------------------------
	
INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
VALUES(	'Video 81: Learning About Making Art',
		'',
		'Protocol focuses on providing oral and written feedback to students on their work. ',
		'FINAL video 81.pdf',
		'1:55-3:55 and 8:50-10:04 and 13:40-15:57',
		1,
		0,
		1,
		1,
		'',
		''
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
   and fn.ShortName IN ('H16')
   

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
