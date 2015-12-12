
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 66740046
, @title = 'New Resources section - Schema'
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

ALTER TABLE SETrainingProtocol 
	ADD IncludeInPublicSite BIT
	
ALTER TABLE SETrainingProtocol 
	ADD IncludeInVideoLibrary BIT
	
ALTER TABLE SETrainingProtocol
    ADD VideoPoster VARCHAR(MAX)
    
ALTER TABLE SETrainingProtocol
	ADD VideoSrc VARCHAR(MAX)
	
ALTER TABLE dbo.SEEvalSession
	ADD TrainingProtocolID BIGINT NULL
	
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])

CREATE TABLE [dbo].[SEDistrictTrainingProtocolAnchor] (
	[DistrictTrainingProtocolAnchorID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
 CONSTRAINT [PK_SEDistrictTrainingProtocolAnchor] PRIMARY KEY CLUSTERED 
(
	[DistrictTrainingProtocolAnchorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])

ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])


CREATE TABLE [dbo].[SETrainingProtocolPlaylist] (
	[TrainingProtocolPlaylistID] [bigint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolPlaylist] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolPlaylistID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])

ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])


CREATE TABLE [dbo].[SETrainingProtocolRatingStatusType](
	[TrainingProtocolRatingStatusTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolRatingStatusType] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolRatingStatusTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[SETrainingProtocolRating] (
	[TrainingProtocolRatingID] [bigint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[Rating] [SMALLINT] NOT NULL,
	[Comments] [varchar](max) NULL,
	[CreationDate] [datetime] NULL,
	[IsAnnonymous] [bit] NOT NULL,
	[Status] [smallint] NOT NULL
 CONSTRAINT [PK_SETrainingProtocolRating] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolRatingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])

ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE dbo.SETrainingProtocol
	ADD ImageName VARCHAR(500) NULL
	
ALTER TABLE dbo.SETrainingProtocol
	ADD AvgRating SMALLINT NULL
	
ALTER TABLE dbo.SETrainingProtocol
	ADD NumRatings SMALLINT NULL
	
ALTER TABLE dbo.SEEvalSession 
	 ALTER COLUMN Title VARCHAR(250)
	
-- Remove old practice session support
ALTER TABLE dbo.SEEvalSession
     DROP CONSTRAINT  FK_SEEvalSession_SEEvalSession
     
ALTER TABLE dbo.SEEvalSession
	 DROP COLUMN AnchorSessionID
		 
ALTER TABLE dbo.SEEvalSession
     DROP CONSTRAINT  FK_SEEvalSession_LibraryVideoID
     
ALTER TABLE dbo.SEEvalSession
	 DROP COLUMN LibraryVideoID

CREATE TABLE [dbo].[SEPracticeSessionType](
	[PracticeSessionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEPracticeSessionType] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEPracticeSession] (
	[PracticeSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[DistrictCode] VARCHAR(20) NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Title] VARCHAR(200) NOT NULL,
	[AnchorSessionID] [bigint] NULL,
	[TrainingProtocolID] [bigint] NULL,
	[LockStateID] [smallint] NOT NULL,
	[PracticeSessionTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluateeUserID] [bigint] NULL,
	[IsPrivate] [bit] NOT NULL,
	[RandomDigits] [smallint] NOT NULL
 CONSTRAINT [PK_SEPracticeSession] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_SchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_EvaluateeUserID] FOREIGN KEY([EvaluateeUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_AnchorSessionID] FOREIGN KEY([AnchorSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_TrainingProtocolID] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_LockStateID] FOREIGN KEY([LockStateID])
REFERENCES [dbo].[SEEvalSessionLockState] ([EvalSessionLockStateID])

ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_PracticeSessionTypeID] FOREIGN KEY([PracticeSessionTypeID])
REFERENCES [dbo].[SEPracticeSessionType] ([PracticeSessionTypeID])

CREATE TABLE [dbo].[SEPracticeSessionParticipant] (
	[PracticeSessionParticipantID] [bigint] IDENTITY(1,1) NOT NULL,
	[PracticeSessionID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEPracticeSessionParticipant] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionParticipantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_PracticeSession] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])

ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])


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


