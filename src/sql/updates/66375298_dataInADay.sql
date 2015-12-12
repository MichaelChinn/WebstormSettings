
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 66375298
, @title = 'Data in a Day Mobile App'
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

INSERT dbo.SEPracticeSessionType(Name) VALUES('Learning Walks')

CREATE TABLE [dbo].[SELearningWalkClassRoom](
	[LearningWalkClassRoomID] [bigint] IDENTITY(1,1) NOT NULL,
	[PracticeSessionID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SELearningWalkClassRoom] PRIMARY KEY CLUSTERED 
(
	[LearningWalkClassRoomID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SELearningWalkClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassRoom_PracticeSessionID] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])
ALTER TABLE [dbo].[SELearningWalkClassRoom] CHECK CONSTRAINT [FK_SELearningWalkClassRoom_PracticeSessionID]

ALTER TABLE [dbo].[SEFrameworkNodeScore] ADD LearningWalkClassRoomID BIGINT NULL
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_LearningWalkClassroomID] FOREIGN KEY([LearningWalkClassroomID])
REFERENCES [dbo].[SELearningWalkClassroom] ([LearningWalkClassroomID])
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_LearningWalkClassroomID]

ALTER TABLE [dbo].[SERubricRowScore] ADD LearningWalkClassRoomID BIGINT NULL
ALTER TABLE SERubricRowScore DROP CONSTRAINT PK_SERubricRowScore

ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_LearningWalkClassroomID] FOREIGN KEY([LearningWalkClassroomID])
REFERENCES [dbo].[SELearningWalkClassroom] ([LearningWalkClassroomID])
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_LearningWalkClassroomID]

CREATE TABLE [dbo].[SELearningWalkSessionScore] (
	[LearningWalkSessionScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClassroomID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NOT NULL,
	[SEUserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SELearningWalkSessionScore] PRIMARY KEY CLUSTERED 
(
	[LearningWalkSessionScoreID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_ClassroomID] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[SELearningWalkClassroom] ([LearningWalkClassroomID])
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_ClassroomID]

ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_SessionID] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_SessionID]

ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceLevelID] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_PerformanceLevelID]

ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_SEUserID] FOREIGN KEY([SEUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_SEUserID]


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


