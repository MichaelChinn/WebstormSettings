
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 

/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

select @bugFixed = 63759462
, @title = '63759462_SetPksOnTableForFrameworkFlush.SQL'
, @comment = ''


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2461
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	return
END


INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)


/*
Run this script on:

        (local).StateEval_BaseLine    -  This database will be modified

to synchronize it with:

        (local).StateEval

You are recommended to back up your database before running this script

Script created by SQL Compare version 10.4.8 from Red Gate Software Ltd at 1/13/2014 1:56:17 PM

*/

ALTER TABLE seSchoolconfiguration ALTER COLUMN SchoolConfigurationID bigint NOT NULL
ALTER TABLE dbo.seSchoolconfiguration ADD PK_SESchoolConfiguration bigint PRIMARY KEY (SchoolConfigurationID)


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Dropping foreign keys from [dbo].[SEEvalSessionRubricRowFocus]'
GO
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] DROP CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SEEvalSession]
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] DROP CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SERubricRow]
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] DROP CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SEEvaluationRoleType]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [dbo].[SEUserPromptRubricRowAlignment]'
GO
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] DROP CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SEUserPrompt]
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] DROP CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SERubricRow]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [dbo].[SEUserPromptConferenceDefault]'
GO
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt]
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType]
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [dbo].[SERubricRowAnnotation]'
GO
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SERubricRow]
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession]
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SEUserID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [dbo].[SEEvalSessionRubricRowFocus]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_SEEvalSessionRubricRowFocus]
(
[SEEvalSessionRubricRowFocusID] [bigint] IDENTITY (1,1) NOT NULL,
[EvalSessionID] [bigint] NOT NULL,
[RubricRowID] [bigint] NOT NULL,
[EvaluationRoleTypeID] [smallint] NOT NULL,
[PK_SEEvalSessionRubricRowFocus] [bigint] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [dbo].[tmp_rg_xx_SEEvalSessionRubricRowFocus]([EvalSessionID], [RubricRowID], [EvaluationRoleTypeID]) SELECT [EvalSessionID], [RubricRowID], [EvaluationRoleTypeID] FROM [dbo].[SEEvalSessionRubricRowFocus]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [dbo].[SEEvalSessionRubricRowFocus]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_rename N'[dbo].[tmp_rg_xx_SEEvalSessionRubricRowFocus]', N'SEEvalSessionRubricRowFocus'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__SEEvalSe__6F0051267E22B05D] on [dbo].[SEEvalSessionRubricRowFocus]'
GO
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] ADD CONSTRAINT [PK__SEEvalSe__6F0051267E22B05D] PRIMARY KEY CLUSTERED  ([SEEvalSessionRubricRowFocusID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [dbo].[SEUserPromptConferenceDefault]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_SEUserPromptConferenceDefault]
(
[SEUserPromptConferenceDefaultID] [bigint] IDENTITY (1,1) NOT NULL,
[UserPromptID] [bigint] NOT NULL,
[UserPromptTypeID] [smallint] NOT NULL,
[EvaluateeID] [bigint] NOT NULL,
[DistrictCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PK_SEUserPromptConferenceDefault] [bigint] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [dbo].[tmp_rg_xx_SEUserPromptConferenceDefault]([UserPromptID], [UserPromptTypeID], [EvaluateeID], [DistrictCode]) SELECT [UserPromptID], [UserPromptTypeID], [EvaluateeID], [DistrictCode] FROM [dbo].[SEUserPromptConferenceDefault]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [dbo].[SEUserPromptConferenceDefault]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_rename N'[dbo].[tmp_rg_xx_SEUserPromptConferenceDefault]', N'SEUserPromptConferenceDefault'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__SEUserPr__AD56DF00758D6A5C] on [dbo].[SEUserPromptConferenceDefault]'
GO
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] ADD CONSTRAINT [PK__SEUserPr__AD56DF00758D6A5C] PRIMARY KEY CLUSTERED  ([SEUserPromptConferenceDefaultID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO

PRINT N'Rebuilding [dbo].[SEUserPromptRubricRowAlignment]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_SEUserPromptRubricRowAlignment]
(
[SEUserPromptRubricRowAlignmentID] [bigint] IDENTITY (1,1) NOT NULL,
[UserPromptID] [bigint] NOT NULL,
[RubricRowID] [bigint] NOT NULL,
[CreatedByUserID] [bigint] NOT NULL,
[PK_SEUserPromptRubricRowAlignment] [bigint] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [dbo].[tmp_rg_xx_SEUserPromptRubricRowAlignment]([UserPromptID], [RubricRowID], [CreatedByUserID]) SELECT [UserPromptID], [RubricRowID], [CreatedByUserID] FROM [dbo].[SEUserPromptRubricRowAlignment]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [dbo].[SEUserPromptRubricRowAlignment]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_rename N'[dbo].[tmp_rg_xx_SEUserPromptRubricRowAlignment]', N'SEUserPromptRubricRowAlignment'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__SEUserPr__D163D27C7869D707] on [dbo].[SEUserPromptRubricRowAlignment]'
GO
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] ADD CONSTRAINT [PK__SEUserPr__D163D27C7869D707] PRIMARY KEY CLUSTERED  ([SEUserPromptRubricRowAlignmentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [dbo].[SERubricRowAnnotation]'
GO
CREATE TABLE [dbo].[tmp_rg_xx_SERubricRowAnnotation]
(
[SERubricRowAnnotationID] [bigint] IDENTITY (1,1) NOT NULL,
[RubricRowID] [bigint] NOT NULL,
[EvalSessionID] [bigint] NOT NULL,
[Annotation] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [bigint] NULL,
[PK_SERubricRowAnnotation] [bigint] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [dbo].[tmp_rg_xx_SERubricRowAnnotation]([RubricRowID], [EvalSessionID], [Annotation], [UserID]) SELECT [RubricRowID], [EvalSessionID], [Annotation], [UserID] FROM [dbo].[SERubricRowAnnotation]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [dbo].[SERubricRowAnnotation]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
EXEC sp_rename N'[dbo].[tmp_rg_xx_SERubricRowAnnotation]', N'SERubricRowAnnotation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__SERubric__1E96B6D67B4643B2] on [dbo].[SERubricRowAnnotation]'
GO
ALTER TABLE [dbo].[SERubricRowAnnotation] ADD CONSTRAINT [PK__SERubric__1E96B6D67B4643B2] PRIMARY KEY CLUSTERED  ([SERubricRowAnnotationID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO



PRINT N'Adding foreign keys to [dbo].[SEEvalSessionRubricRowFocus]'
GO
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] ADD CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SEEvalSession] FOREIGN KEY ([EvalSessionID]) REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] ADD CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SERubricRow] FOREIGN KEY ([RubricRowID]) REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] ADD CONSTRAINT [FK_SEEvalSessionRubricRowFocus_SEEvaluationRoleType] FOREIGN KEY ([EvaluationRoleTypeID]) REFERENCES [dbo].[SEEvaluationRoleType] ([EvaluationRoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[SEUserPromptRubricRowAlignment]'
GO
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] ADD CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SEUserPrompt] FOREIGN KEY ([UserPromptID]) REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] ADD CONSTRAINT [FK_SEUserPromptRubricRowAlignment_SERubricRow] FOREIGN KEY ([RubricRowID]) REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[SEUserPromptConferenceDefault]'
GO
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] ADD CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt] FOREIGN KEY ([UserPromptID]) REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] ADD CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType] FOREIGN KEY ([UserPromptTypeID]) REFERENCES [dbo].[SEUserPromptType] ([UserPromptTypeID])
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] ADD CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser] FOREIGN KEY ([EvaluateeID]) REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[SERubricRowAnnotation]'
GO
ALTER TABLE [dbo].[SERubricRowAnnotation] ADD CONSTRAINT [FK_SERubricRowAnnotation_SERubricRow] FOREIGN KEY ([RubricRowID]) REFERENCES [dbo].[SERubricRow] ([RubricRowID])
ALTER TABLE [dbo].[SERubricRowAnnotation] ADD CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession] FOREIGN KEY ([EvalSessionID]) REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
ALTER TABLE [dbo].[SERubricRowAnnotation] ADD CONSTRAINT [FK_SERubricRowAnnotation_SEUserID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
