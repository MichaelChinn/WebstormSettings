
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2742
, @title = 'User Prompts - New Tables'
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

CREATE TABLE [dbo].[SEUserPromptType](
	[UserPromptTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEUserPromptType] PRIMARY KEY CLUSTERED 
(
	[UserPromptTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEUserPromptResponseEntry](
	[UserPromptResponseEntryID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptResponseID] [bigint] NOT NULL,
	[Response] [varchar](max) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SEUserPromptResponseEntry] PRIMARY KEY CLUSTERED 
(
	[UserPromptResponseEntryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEUserPrompt](
	[UserPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[PromptTypeID] [smallint] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Prompt] [varchar](max) NOT NULL,
	[DistrictCode] [varchar](10) NOT NULL,
	[SchoolCode] [varchar](10) NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[Published] [bit] NOT NULL,
	[PublishedDate] [datetime] NULL,
	[Retired] [bit] NOT NULL,
	[EvaluationTypeID] SMALLINT NOT NULL,
	[Private] BIT NOT NULL,
	[EvaluateeID] BIGINT NULL,
	[EvalSessionID] BIGINT NULL,
	-- modified 4/29/13 so that the field can be dropped
	-- It is no longer needed and we want to remove the field, 
	-- but it can't be removed if it is referenced in an earlier script.
	-- remove it here because it is only needed for the update case and it has already been 
	-- loaded in the update case. 
	-- [MigrateQuestionID] BIGINT NULL,
	[CreatedAsAdmin] BIT NOT NULL,
	[Sequence] SMALLINT NULL,
 CONSTRAINT [PK_SEUserPrompt] PRIMARY KEY CLUSTERED 
(
	[UserPromptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEUserPromptConferenceDefault] (
	[UserPromptID] [bigint] NOT NULL,
	[UserPromptTypeID] [smallint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL
	)
ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])

ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType] FOREIGN KEY([UserPromptTypeID])
REFERENCES [dbo].[SEUserPromptType] ([UserPromptTypeID])

ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])

CREATE TABLE [dbo].[SEGoalPrompt](
	[GoalPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEGoalPrompt] PRIMARY KEY CLUSTERED 
(
	[GoalPromptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEUserPromptRubricRowAlignment](
	[UserPromptID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[SEUserPromptResponse](
	[UserPromptResponseID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptID] [bigint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NULL,
 CONSTRAINT [PK_SEUserPromptResponse] PRIMARY KEY CLUSTERED 
(
	[UserPromptResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Retired]  DEFAULT ((0)) FOR [Retired]
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Published]  DEFAULT ((0)) FOR [Published]
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Private]  DEFAULT ((0)) FOR [Private]
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_CreatedAsAdmin]  DEFAULT ((1)) FOR [CreatedAsAdmin]
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Sequence] DEFAULT ((1)) FOR [Sequence]

ALTER TABLE [dbo].[SEGoalPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEGoalPrompt_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])

ALTER TABLE [dbo].[SEGoalPrompt] CHECK CONSTRAINT [FK_SEGoalPrompt_SEUserPrompt]

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEUserPromptType] FOREIGN KEY([PromptTypeID])
REFERENCES [dbo].[SEUserPromptType] ([UserPromptTypeID])

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEUserPromptType]

ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_SEUser]

ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_EvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_EvalSession]

ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])

ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_SEUserPrompt]

ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])

ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] CHECK CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SERubricRow]

ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])

ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] CHECK CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SEUserPrompt]

ALTER TABLE [dbo].[SEUserPromptResponseEntry]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponseEntry_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEUserPromptResponseEntry]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponseEntry_SEUserPromptResponse] FOREIGN KEY([UserPromptResponseID])
REFERENCES [dbo].[SEUserPromptResponse] ([UserPromptResponseID])

ALTER TABLE dbo.SEArtifact ADD UserPromptResponseID BIGINT NULL

INSERT SEUserPromptType(Name) VALUES('Pre-Conference')
INSERT SEUserPromptType(Name) VALUES('Post-Conference')
INSERT SEUserPromptType(Name) VALUES('Reflection')
INSERT SEUserPromptType(Name) VALUES('EvaluatorGoal')
INSERT SEUserPromptType(Name) VALUES('EvaluateeGoal')
INSERT SEUserPromptType(Name) VALUES('Comments')

INSERT SEArtifactType(Name) VALUES('EvalatorGoal')
INSERT SEArtifactType(Name) VALUES('EvalateeGoal')
INSERT SEArtifactType(Name) VALUES('Pre-Conference')
INSERT SEArtifactType(Name) VALUES('Post-Conference')
INSERT SEArtifactType(Name) VALUES('Reflection')


DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'PreConfNotes', 'Notes', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'PreConfNotes', 'Notes', '', '', 2, 1, @theDate, 0, 2, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'PostConfNotes', 'Notes', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'PostConfNotes', 'Notes', '', '', 2, 1, @theDate, 0, 2, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'EvaluationNotes', 'Notes', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (6, 'EvaluationNotes', 'Notes', '', '', 2, 1, @theDate, 0, 2, 0)

/* Removing migration code to new userprompts tables to allow removal of MigrateQuestionID column */

 UPDATE dbo.SEUser Set FirstName='State Admin' 
  WHERE FirstName='Anne' 
    and LastName='Chinn'
    AND DistrictCode IS NULL
    AND SchoolCode IS NULL
    
CREATE TABLE [dbo].[SEResourceType](
	[ResourceTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEResourceType] PRIMARY KEY CLUSTERED 
(
	[ResourceTypeID] ASC
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

DECLARE @Query VARCHAR(MAX)
SELECT @Query = 'INSERT SEResourceType(Name) VALUES(''General'')'
EXEC(@Query)
SELECT @Query = 'INSERT SEResourceType(Name) VALUES(''Goal'')'
EXEC(@Query)

ALTER TABLE dbo.SEResource  
	ADD Retired BIT DEFAULT ((0))
	
ALTER TABLE dbo.SEResource  
	ADD ResourceTypeID SMALLINT DEFAULT ((1))
 
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
