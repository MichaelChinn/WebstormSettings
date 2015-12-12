
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2758
, @title = 'Annual Rollover - Part 1'
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

DECLARE @Query VARCHAR(MAX)


ALTER TABLE dbo.SEEvalSession  
ADD SchoolYear SMALLINT 

ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SEEvalSession Set SchoolYear=2012'
EXEC (@Query)

-- Don't do this here because we updated for both 2012 and 2013 in bug2721.
--SELECT @Query = 'UPDATE SEEvaluation Set SchoolYear=2012'
--EXEC (@Query)

ALTER TABLE [dbo].SEArtifact  WITH CHECK ADD  CONSTRAINT [FK_SEArtifact_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SEArtifact Set SchoolYear=2012'
EXEC (@Query)

ALTER TABLE dbo.SEMeasure
ADD SchoolYear SMALLINT 

ALTER TABLE [dbo].SEMeasure  WITH CHECK ADD  CONSTRAINT [FK_SEMeasure_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SEMeasure Set SchoolYear=2012'
EXEC (@Query)

ALTER TABLE dbo.SEDistrictConfiguration
ADD SchoolYear SMALLINT 

ALTER TABLE [dbo].SEDistrictConfiguration  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictConfiguration_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SEDistrictConfiguration Set SchoolYear=2012'
EXEC (@Query)

ALTER TABLE [dbo].SEFramework  WITH CHECK ADD  CONSTRAINT [FK_SEFramework_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SEFramework Set SchoolYear=2012'
EXEC (@Query)

ALTER TABLE dbo.SESchoolCOnfiguration
ADD SchoolYear SMALLINT 

ALTER TABLE [dbo].SEMeasure  WITH CHECK ADD  CONSTRAINT [FK_SESchoolCOnfiguration_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

SELECT @Query = 'UPDATE SESchoolCOnfiguration Set SchoolYear=2012'
EXEC (@Query)

ALTER TABLE dbo.SEUserPromptResponse
ADD SchoolYear SMALLINT 

ALTER TABLE [dbo].SEUserPromptResponse  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])



--As we rollover to 2013, we need to initialize an EvaluationNotes prompt
-- for each person in the seEvaluation table.  However, we need to keep straight
-- the school year, which was just added here.
-- The prompt used to be in 2721, however, since the SchoolYear tracking was 
-- brought together here, i've moved the 2013 EvaluationNotes prompt here as well...

--first, all the prompts that are currently there belong to last year:
SELECT @Query = 'UPDATE SEUserPromptResponse Set SchoolYear=2012'
EXEC (@Query)

--Now, insert an EvaluationNotes Prompt for everyone in the SeEvaluation table for 2012 and 2013
SELECT @Query = 'INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear)
SELECT up.UserPromptID, e.evaluateeID, e.SchoolYear
FROM dbo.SEEValuation e
JOIN seUserPrompt up ON up.EvaluationTypeID = e.EvaluationTypeID
WHERE up.Title = ''EvaluationNotes''
ORDER BY e.EvaluateeID'
EXEC (@Query)

CREATE TABLE [dbo].[SEEvalSessionLibraryVideo](
	[EvalSessionLibraryVideoID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[VideoName] [varchar](100) NOT NULL,
	[Retired] [bit] NOT NULL,
CONSTRAINT [PK_SEEvalSessionLibraryVideo] PRIMARY KEY CLUSTERED 
(
	[EvalSessionLibraryVideoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @Query = 'INSERT INTO SEEvalSessionLibraryVideo(Title, Description, VideoName, Retired) VALUES(''Practice Observation #1'', '''', ''30926351?byline=0&title=0&portrait=0'', 0)' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLibraryVideo(Title, Description, VideoName, Retired) VALUES(''Practice Observation #2'', '''', ''30931977?byline=0&title=0&portrait=0'', 0)' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLibraryVideo(Title, Description, VideoName, Retired) VALUES(''Practice Observation #3'', '''', ''31044985?byline=0&title=0&portrait=0'', 0)' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLibraryVideo(Title, Description, VideoName, Retired) VALUES(''Practice Observation #4'', '''', ''30924078?byline=0&title=0&portrait=0'', 0)' 
EXEC (@Query)

ALTER TABLE dbo.SEEvalSession  
ADD LibraryVideoID BIGINT 

ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_LibraryVideoID] FOREIGN KEY([LibraryVideoID])
REFERENCES [dbo].[SEEvalSessionLibraryVideo] ([EvalSessionLibraryVideoID])

SELECT @Query = 'UPDATE SEEvalSession SET LibraryVideoID=v.EvalSessionLibraryVideoID FROM dbo.SEEvalSessionLibraryVideo v WHERE v.VideoName=SEEvalSession.AnchorVideoName'
EXEC (@Query)

ALTER TABLE [dbo].[SEEvalSession] 
DROP CONSTRAINT [FK_SEEvalSession_SEEvalSession1]

ALTER TABLE dbo.SEEvalSession  
DROP COLUMN LibSessionID

ALTER TABLE dbo.SEEvalSession  
DROP COLUMN AnchorVideoName

DELETE SEEvalSession WHERE AnchorTypeID=3

DELETE SEAnchorType WHERE AnchorTypeID=3

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

/*

select * from coeStudentSiteconfig
select * from updatelog


*/