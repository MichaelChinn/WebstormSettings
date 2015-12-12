/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 103448640
, @title = '103448640 SEEvent'
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


CREATE TABLE [dbo].[SEEventType](
	[EventTypeId] [int] NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[EventTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO [dbo].[SEEventType]
           ([EventTypeId]
           ,[Name]
           ,[Description])
     VALUES
           (1, 'Observation Created', 'Observation Created')
INSERT INTO [dbo].[SEEventType]
           ([EventTypeId]
           ,[Name]
           ,[Description])
     VALUES
           (2, 'Artifact Submitted', 'Artifact Submitted')
INSERT INTO [dbo].[SEEventType]
           ([EventTypeId]
           ,[Name]
           ,[Description])
     VALUES
           (3, 'Artifact Rejected', 'Artifact Rejected')

CREATE TABLE [dbo].[SEEvent](
	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[Name] [nvarchar](300) NOT NULL,
	[Detail] [nvarchar](500) NULL,
	[Url] [nvarchar](50) NULL,
	[CreateDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Note] [nvarchar](500) NULL,
	[ObjectId] [bigint] NULL,
 CONSTRAINT [PK_SEEvent] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEEvent]  WITH CHECK ADD  CONSTRAINT [FK_SEEvent_SEEventType] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[SEEventType] ([EventTypeId])

ALTER TABLE [dbo].[SEEvent] CHECK CONSTRAINT [FK_SEEvent_SEEventType]


CREATE TABLE [dbo].[SENotification](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NULL,
	[Title] [nvarchar](500) NULL,
	[Description] [nvarchar](max) NULL,
	[ReceiverUserId] [bigint] NULL,
	[ReceiverRoleId] [int] NULL,
	[IsViewed] [bit] NULL,
	[AlignedTo] [nvarchar](100) NULL,
	[ViewedDateTime] [datetime] NULL,
	[EmailSentForNotification] [bit] NULL,
	[NotificationType] [int] NULL,
	[CreatedByUserId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEEvent] FOREIGN KEY([EventId])
REFERENCES [dbo].[SEEvent] ([EventId])

ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEEvent]

ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEUser] FOREIGN KEY([ReceiverUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEUser]

ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEUser1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEUser1]


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


