
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 92077308
, @title = 'Labels for Classroom Walks'
, @comment = 'Labels for classroom Walks'
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
CREATE TABLE [dbo].[SELearningWalkClassroomLabel](
	[LabelID] [bigint] IDENTITY(1,1) NOT NULL,
	[Label] [varchar](50) NULL,
	[PracticeSessionID] [bigint] NOT NULL,
CONSTRAINT [PK_SELearningWalkClassroomLabel] PRIMARY KEY CLUSTERED 
(
	[LabelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SELearningWalkClassroomLabel]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabel_SEPracticeSession] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])

CREATE TABLE [dbo].[SELearningWalkClassroomLabelRelationship](
	[ClassroomID] [bigint] NOT NULL,
	[LabelID] [bigint] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[SELearningWalkClassRoom] ([LearningWalkClassRoomID])
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] CHECK CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel] FOREIGN KEY([LabelID])
REFERENCES [dbo].[SELearningWalkClassroomLabel] ([LabelID])
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] CHECK CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]
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


