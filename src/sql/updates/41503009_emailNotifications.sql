

/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 41503009
, @title = 'Email notifications'
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

-- SELECT * FROM messagetype

-- UG: user-defined
UPDATE dbo.MessageType SET Name='UG: ' + Name
-- SG: systemd-defined
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(11, 'SG: Session Locking', 'System-generated lock change notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(12, 'SG: New Artifact', 'System-generated new artifact notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(13, 'SG: Pre-conf Visible', 'System-generated pre-conf public notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(14, 'SG: Observe Visible', 'System-generated observe public notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(15, 'SG: Post-conf Visible', 'System-generated post-conf public notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(16, 'SG: Pre-conf Complete', 'System-generated pre-conf complete notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(17, 'SG: Observe Complete', 'System-generated observe complete notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(18, 'SG: Post-conf Complete', 'System-generated post-conf complete notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(19, 'SG: Final Eval Submitted', 'System-generated final evaluation submitted notification')
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(20, 'SG: Final Eval Visibility Settings Changed', 'System-generated final evaluation visibility settings changed notification')

-- Set all the existing messages as being sent so we only start with future ones
DECLARE @Query VARCHAR(MAX)
ALTER TABLE dbo.MessageHeader ADD EmailSent BIT DEFAULT(0)
ALTER TABLE dbo.MessageHeader ADD EmailSentDateTime DATETIME
SELECT @Query = 'UPDATE dbo.MessageHeader SET EmailSent=1'
EXEC(@Query)
ALTER TABLE dbo.MessageHeader ALTER COLUMN EmailSent BIT NOT NULL

CREATE TABLE [dbo].[EmailDeliveryType](
	[EmailDeliveryTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EmailDeliveryType] PRIMARY KEY CLUSTERED 
(
	[EmailDeliveryTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @Query = 'INSERT INTO dbo.EmailDeliveryType(Name) VALUES(''None'')' 
EXEC(@Query)
SELECT @Query = 'INSERT INTO dbo.EmailDeliveryType(Name) VALUES(''Individual'')' 
EXEC(@Query)
SELECT @Query = 'INSERT INTO dbo.EmailDeliveryType(Name) VALUES(''Nightly Digest'')' 
EXEC(@Query)
SELECT @Query = 'INSERT INTO dbo.EmailDeliveryType(Name) VALUES(''Weekly Digest'')' 
EXEC(@Query)


ALTER TABLE dbo.SEUser ADD MessageEmailOverride VARCHAR(200) NULL

CREATE TABLE dbo.MessageTypeRecipientConfig
	(
	MessageTypeRecipientConfigID BIGINT IDENTITY(1,1) NOT NULL,
	RecipientID BIGINT NOT NULL,
	MessageTypeID INT NOT NULL,
	Inbox BIT NOT NULL DEFAULT(0),
	EmailDeliveryTypeID SMALLINT DEFAULT(1)
CONSTRAINT [PK_MessageTypeRecipientConfig] PRIMARY KEY CLUSTERED 
(
	[MessageTypeRecipientConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	
ALTER TABLE [dbo].[MessageTypeRecipientConfig]  WITH CHECK ADD  CONSTRAINT [FK_MessageTypeRecipientConfig_MessageType] FOREIGN KEY([MessageTypeID])
REFERENCES [dbo].[MessageType] ([MessageTypeID])

CREATE TABLE [dbo].[MessageTypeRole](
	[MessageTypeID] [smallint] NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
)

-- select * from MessageType
-- select * from aspnet_roles

-- UG: Observation Pre-Conference
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(1, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(1, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(1, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(1, ''SESchoolTeacher'')' 
EXEC (@Query)
-- UG: Observation Scoring
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(2, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(2, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
-- UG: Observation Post-Conference
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(3, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(3, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(3, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(3, ''SESchoolTeacher'')' 
EXEC (@Query)
-- UG: Evaluator-assigned Goals
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(4, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(4, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(4, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(4, ''SESchoolTeacher'')' 
EXEC (@Query)
-- UG: Artifacts
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(5, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(5, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
-- UG: Self-Assess
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(6, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(6, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
-- UG: Session Settings
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(8, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(8, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
-- UG: Practice Session
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(9, ''SESchoolTeacher'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(9, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(9, ''SEDistrictEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(9, ''SEPracticeParticipantGuest'')' 
EXEC (@Query)
-- UG: Evaluatee-assigned Goals
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(10, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(10, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(10, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(10, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session Locking
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(11, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(11, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(11, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(11, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: New Artifact
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(12, ''SETeacherEvaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(12, ''SEPrincipalEvaluator'')' 
EXEC (@Query)
-- SG: Session Pre-Conf Section Visible
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(13, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(13, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session Observe Section Visible
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(14, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(14, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session Post-Conf Section Visible
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(15, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(15, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session Pre-Conf Section Complete
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(16, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(16, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session Observe Section Complete
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(17, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(17, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Session P0st-Conf Section Complete
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(18, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(18, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Final Exam Submitted
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(19, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(19, ''SESchoolTeacher'')' 
EXEC (@Query)
-- SG: Final Exam Visibility Settings Changed
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(20, ''SESchoolPrincipal'')' 
EXEC (@Query)
SELECT @Query = 'INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(20, ''SESchoolTeacher'')' 
EXEC (@Query)
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


