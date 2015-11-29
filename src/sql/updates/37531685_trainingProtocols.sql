
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 37531685
, @title = 'Training Protocols'
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

CREATE TABLE [dbo].[SETrainingProtocolLabelAssignment](
	[TrainingProtocolID] [bigint] NOT NULL,
	[TrainingProtocolLabelID] [smallint] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[SETrainingProtocol](
	[TrainingProtocolID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Summary] [varchar](max) NULL,
	[Description] [varchar] (max) NULL,
	[VideoName] [varchar](100) NULL,
	[DocName] [varchar] (MAX) NOT NULL,
	[Length] [varchar](200) NOT NULL,
	[Published] [bit] NOT NULL,
	[PublishedDate] [datetime] NULL,
	[Retired] [bit] NOT NULL,
 CONSTRAINT [PK_SETrainingProtocol] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SETrainingProtocolLabelGroup](
	[TrainingProtocolLabelGroupID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolLabelGroup] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolLabelGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SETrainingProtocolLabel](
	[TrainingProtocolLabelID] [smallint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolLabelGroupID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolLabel] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolLabelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment](
	[TrainingProtocolID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[IsStateAlignment] [bit] NOT NULL,
) ON [PRIMARY]

ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel] FOREIGN KEY([TrainingProtocolLabelID])
REFERENCES [dbo].[SETrainingProtocolLabel] ([TrainingProtocolLabelID])
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]

ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Title]  DEFAULT ('') FOR [Title]
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Summary]  DEFAULT ('') FOR [Summary]
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Description]  DEFAULT ('') FOR [Description]
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Published]  DEFAULT ((0)) FOR [Published]
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Retired]  DEFAULT ((0)) FOR [Retired]

ALTER TABLE [dbo].[SETrainingProtocolLabel]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup] FOREIGN KEY([TrainingProtocolLabelGroupID])
REFERENCES [dbo].[SETrainingProtocolLabelGroup] ([TrainingProtocolLabelGroupID])
ALTER TABLE [dbo].[SETrainingProtocolLabel] CHECK CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]

ALTER TABLE [SEUserPromptResponse] ALTER COLUMN [EvaluateeID] BIGINT NULL

ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol]

ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode]


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


