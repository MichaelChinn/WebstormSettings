
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2699
, @title = 'Message Alerts Tables, 5/7/2012'
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
	PRINT 'FIX ALREADY APPLIED'
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


IF NOT Exists(select * from sys.tables where Name = N'MessageType' )
BEGIN
	CREATE TABLE [dbo].[MessageType](
		[MessageTypeID] [int] NOT NULL,
		[Name] [varchar](50) NOT NULL,
		[Description] [nvarchar](500) NULL,
	 CONSTRAINT [PK_MessageType] PRIMARY KEY CLUSTERED 
	(
		[MessageTypeID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	
	-- DEFAULT DATA
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(0, 'Unclassified', 'Unspecified data')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(1, 'Observation Session Pre-Conference', 'An observation session pre-conference')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(2, 'Observation Session Scoring', 'An observation session scoring')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(3, 'Observation Session Post-Conference', 'An observation session post-conference')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(4, 'Evaluator-Assigned Goal', 'An evaluator-assigned goal')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(5, 'Artifact', 'An artifact')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(6, 'Self-Assessment', 'A self-assessment')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(7, 'Observation Session', 'An observation')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(8, 'Observation Session Settings', 'An observation session settings')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(9, 'Practice Session Invite', 'A practice observation session invitation')
	INSERT INTO [MessageType]([MessageTypeID], Name, Description) VALUES(10, 'Evaluatee-Assigned Goal', 'An evaluatee-assigned goal')


END




IF NOT Exists(select * from sys.tables where Name = N'Message' )
BEGIN

	CREATE TABLE [dbo].[Message](
		[MessageID] [bigint] IDENTITY(1,1) NOT NULL,
		[ThreadRootID] [bigint] NULL,
		[ThreadParentID] [bigint] NULL,
		[SenderID] [bigint] NULL,
		[Sender] [nvarchar](256) NULL,
		[RecipientUsers] [nvarchar](1000) NOT NULL,
		[Subject] [nvarchar](512) NULL,
		[Body] [ntext] NOT NULL,
		[MessageTypeID] [int] NULL,
		[SendTime] [datetime] NOT NULL,
		[HasAttachments] [bit] NOT NULL,
		[Importance] [smallint] NOT NULL,
	 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
	(
		[MessageID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
SELECT @sql_error_message = 'Failed trying to apply Message Tables. In: ' 
	+ @bugFixed
	+ ' >>>' + ISNULL(@sql_error_message, '')
GOTO ErrorHandler
END

	ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Message_ThreadParent] FOREIGN KEY([ThreadParentID])
	REFERENCES [dbo].[Message] ([MessageID])

	ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_MessageType] FOREIGN KEY([MessageTypeID])
	REFERENCES [dbo].[MessageType] ([MessageTypeID])

	ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Message_ThreadParent]

	ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Message_ThreadRoot] FOREIGN KEY([ThreadRootID])
	REFERENCES [dbo].[Message] ([MessageID])

	ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_SEUser] FOREIGN KEY([SenderID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Message_ThreadRoot]


	ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Message_SendDate]  DEFAULT (getutcdate()) FOR [SendTime]

	ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Message_HasAttachments]  DEFAULT ((0)) FOR [HasAttachments]

	ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Message_MessageType]  DEFAULT ((0)) FOR [MessageTypeID]

	ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Message_Importance]  DEFAULT ((0)) FOR [Importance]


	CREATE TABLE [dbo].[MessageHeader](
		[MessageID] [bigint] NOT NULL,
		[SenderID] [bigint] NOT NULL,
		[RecipientID] [bigint] NOT NULL,
		[Subject] [nvarchar](512) NULL,
		[Sender] [nvarchar](256) NULL,
		[SendTime] [datetime] NOT NULL,
		[MessageTypeID] [int] NULL,
		[Importance] [smallint] NOT NULL,
		[IsRead] [bit] NOT NULL,
		[Deleted] [bit] NOT NULL,
		[StateFlag] [int] NULL,
		[Flag] [int] NULL,
		[Tags] [nvarchar](500) NULL,
	 CONSTRAINT [PK_MessageHeader] PRIMARY KEY NONCLUSTERED 
	(
		[MessageID] ASC,
		[RecipientID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
SELECT @sql_error_message = 'Failed trying to apply Message Tables. In: ' 
	+ @bugFixed
	+ ' >>>' + ISNULL(@sql_error_message, '')
GOTO ErrorHandler
END

	ALTER TABLE [dbo].[MessageHeader]  WITH CHECK ADD  CONSTRAINT [FK_MessageHeader_MessageType] FOREIGN KEY([MessageTypeID])
	REFERENCES [dbo].[MessageType] ([MessageTypeID])

	ALTER TABLE [dbo].[MessageHeader]  WITH CHECK ADD  CONSTRAINT [FK_MessageHeader_Message] FOREIGN KEY([MessageID])
	REFERENCES [dbo].[Message] ([MessageID])

	ALTER TABLE [dbo].[MessageHeader] CHECK CONSTRAINT [FK_MessageHeader_Message]

	ALTER TABLE [dbo].[MessageHeader]  WITH CHECK ADD  CONSTRAINT [FK_MessageHeader_SEUser] FOREIGN KEY([RecipientID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[MessageHeader]  WITH CHECK ADD  CONSTRAINT [FK_MessageHeader_SEUser2] FOREIGN KEY([SenderID])
	REFERENCES [dbo].[SEUser] ([SEUserID])

	ALTER TABLE [dbo].[MessageHeader] CHECK CONSTRAINT [FK_MessageHeader_SEUser]

	ALTER TABLE [dbo].[MessageHeader] ADD  CONSTRAINT [DF_MessageHeader_MessageType]  DEFAULT ((0)) FOR [MessageTypeID]

	ALTER TABLE [dbo].[MessageHeader] ADD  CONSTRAINT [DF_MessageHeader_Importance]  DEFAULT ((0)) FOR [Importance]

	ALTER TABLE [dbo].[MessageHeader] ADD  CONSTRAINT [DF_MessageHeader_IsRead]  DEFAULT ((0)) FOR [IsRead]

	ALTER TABLE [dbo].[MessageHeader] ADD  CONSTRAINT [DF_MessageHeader_Deleted]  DEFAULT ((0)) FOR [Deleted]

END




SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to apply Message Tables. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


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