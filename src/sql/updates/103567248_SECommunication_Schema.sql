
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 103567248
, @title = '103567248_SECommunication_Schema'
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

CREATE TABLE [dbo].[SEArtifactBundleRejection](
	[ArtifactBundleRejectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ArtifactBundleID] [bigint] NOT NULL,
	[RejectionTypeID] [smallint] NOT NULL,
	[CommunicationSessionKey] [uniqueidentifier] NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleRejection] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleRejectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[SEArtifactBundleRejectionType](
	[ArtifactBundleRejectionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleRejectionType] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleRejectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[SECommunication](
	[CommunicationID] [bigint] IDENTITY(1,1) NOT NULL,
	[CommunicationSessionKey] [uniqueidentifier] NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Message] [varchar](max) NOT NULL,
 CONSTRAINT [PK_SECommunication] PRIMARY KEY CLUSTERED 
(
	[CommunicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEUser]

ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])

ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundle]

ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType] FOREIGN KEY([RejectionTypeID])
REFERENCES [dbo].[SEArtifactBundleRejectionType] ([ArtifactBundleRejectionTypeID])

ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]

ALTER TABLE [dbo].[SECommunication]  WITH CHECK ADD  CONSTRAINT [FK_SECommunication_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SECommunication] CHECK CONSTRAINT [FK_SECommunication_SEUser]

ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEArtifactBundleRejectionType] FOREIGN KEY([RejectionTypeID])
REFERENCES [dbo].[SEArtifactBundleRejectionType] ([ArtifactBundleRejectionTypeID])

ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEArtifactBundleRejectionType]



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


