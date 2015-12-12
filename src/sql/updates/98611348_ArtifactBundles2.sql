
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 98611348
, @title = '98611348_ArtifactBundles'
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

CREATE TABLE [dbo].[SEArtifactLibItemType](
	[ArtifactLibItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactLibItemType] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEArtifactLibItem](
	[ArtifactLibItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [smallint] NOT NULL,
	[EvaluationID] BIGINT NOT NULL,
	[Title] VARCHAR(200) NOT NULL DEFAULT(''),
	[Comments] VARCHAR(MAX) NOT NULL DEFAULT(''),
	[CreationDateTime] DATETIME NOT NULL
 CONSTRAINT [PK_SEArtifactLibItem] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 

ALTER TABLE [dbo].[SEArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactLibItem_ItemType] FOREIGN KEY([ItemTypeID])
REFERENCES [dbo].[SEArtifactLibItemType] ([ArtifactLibItemTypeID])
ALTER TABLE [dbo].[SEArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactLibItem_ItemType]

CREATE TABLE [dbo].[SEArtifactToArtifactLibItem](
	[ArtifactLibItemID] [bigint] NOT NULL,
	[ArtifactID] [bigint] NOT NULL
	)

ALTER TABLE [dbo].[SEArtifactToArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactToArtifactLibItem_ArtifactID] FOREIGN KEY([ArtifactID])
REFERENCES [dbo].[SEArtifact] ([ArtifactID])
ALTER TABLE [dbo].[SEArtifactToArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactToArtifactLibItem_ArtifactID]

ALTER TABLE [dbo].[SEArtifactToArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactToArtifactLibItem_ArtifactLibItemID] FOREIGN KEY([ArtifactLibItemID])
REFERENCES [dbo].[SEArtifactLibItem] ([ArtifactLibItemID])
ALTER TABLE [dbo].[SEArtifactToArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactToArtifactLibItem_ArtifactLibItemID]

ALTER TABLE [dbo].[SEArtifact] ADD Title VARCHAR(200) NULL
ALTER TABLE [dbo].[SEArtifact] ADD IsEvidence BIT DEFAULT(0)
ALTER TABLE [dbo].[SEArtifact] ADD EvaluationID BIGINT NULL

ALTER TABLE [dbo].[SEArtifact]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifact_EvaluationID] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
ALTER TABLE [dbo].[SEArtifact] CHECK CONSTRAINT [FK_SEArtifact_EvaluationID]





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


