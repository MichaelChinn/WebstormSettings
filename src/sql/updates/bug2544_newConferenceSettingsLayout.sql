
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2544
, @title = 'New Session Settings Layout'
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

DECLARE @Query VARCHAR(MAX)

CREATE TABLE [dbo].[SEEvaluateePlanType](
	[EvaluateePlanTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
CONSTRAINT [PK_SEEvaluateePlanType] PRIMARY KEY CLUSTERED 
(
	[EvaluateePlanTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @Query = 'INSERT INTO SEEvaluateePlanType(Name) VALUES(''Comprehensive'')' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvaluateePlanType(Name) VALUES(''Focused'')' 
EXEC (@Query)

CREATE TABLE [dbo].[SEEvalSessionLockState](
	[EvalSessionLockStateID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
CONSTRAINT [PK_SEEvalSessionLockState] PRIMARY KEY CLUSTERED 
(
	[EvalSessionLockStateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @Query = 'INSERT INTO SEEvalSessionLockState(Name) VALUES(''Unlocked'')' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLockState(Name) VALUES(''Locked'')' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLockState(Name) VALUES(''Unlock_Requested_Evaluator'')' 
EXEC (@Query)
SELECT @Query = 'INSERT INTO SEEvalSessionLockState(Name) VALUES(''Unlock_Requested_Evaluatee'')' 
EXEC (@Query)

ALTER TABLE dbo.SEEvalSession  
ADD EvalSessionLockStateID SMALLINT DEFAULT ((1))

ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEEvalSessionLockState] FOREIGN KEY([EvalSessionLockStateID])
REFERENCES [dbo].[SEEvalSessionLockState] ([EvalSessionLockStateID])


IF NOT Exists(select * from sys.columns where Name = N'PreConfIsPublic'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PreConfIsPublic BIT DEFAULT ((0))
END


IF NOT Exists(select * from sys.columns where Name = N'PreConfIsComplete'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PreConfIsComplete BIT DEFAULT ((0))
END

IF NOT Exists(select * from sys.columns where Name = N'PreConfStartTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PreConfStartTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'PreConfEndTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PreConfEndTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'PreConfLocation'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PreConfLocation varchar(200) DEFAULT ((''))
END

IF NOT Exists(select * from sys.columns where Name = N'ObserveIsPublic'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD ObserveIsPublic BIT DEFAULT ((0))
END

IF NOT Exists(select * from sys.columns where Name = N'ObserveIsComplete'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD ObserveIsComplete BIT DEFAULT ((0))
END

IF NOT Exists(select * from sys.columns where Name = N'ObserveStartTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD ObserveStartTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'ObserveEndTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD ObserveEndTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'ObserveLocation'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD ObserveLocation varchar(200) DEFAULT ((''))
END


IF NOT Exists(select * from sys.columns where Name = N'PostConfStartTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PostConfStartTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'PostConfEndTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PostConfEndTime datetime
END

IF NOT Exists(select * from sys.columns where Name = N'PostConfLocation'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PostConfLocation varchar(200) DEFAULT ((''))
END

IF NOT Exists(select * from sys.columns where Name = N'PostConfIsPublic'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PostConfIsPublic BIT DEFAULT ((0))
END

IF NOT Exists(select * from sys.columns where Name = N'PostConfIsComplete'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession  
	ADD PostConfIsComplete BIT DEFAULT ((0))
END

SELECT @Query = 'UPDATE SEEvalSession SET ObserveIsPublic=1, PreConfIsPublic=1, PostConfIsPublic=1 WHERE IsPublic=1'
EXEC(@Query)

SELECT @Query = 'UPDATE SEEvalSession SET EvalSessionLockStateID=1'
EXEC(@Query)

-- Drop unused columns

/*
IF Exists(select * from sys.columns where Name = N'EvaluatorPreConNotes'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN EvaluatorPreConNotes
END

IF Exists(select * from sys.columns where Name = N'EvaluateePreConNotes'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN EvaluateePreConNotes
END
*/

IF Exists(select * from sys.columns where Name = N'Location'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN Location
END

IF Exists(select * from sys.columns where Name = N'StartTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN StartTime
END

IF Exists(select * from sys.columns where Name = N'EndTime'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN EndTime
END

IF Exists(select * from sys.columns where Name = N'IsPublic'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN IsPublic 
END

-- Remove workflow tables

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_SEWfTransition_SEWfState2]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_SEWfTransition_SEWfState3]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WfTransition_WfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_WfTransition_WfState]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WfTransition_WfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_WfTransition_WfState1]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSessionWfHistory_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionWfHistory]'))
ALTER TABLE [dbo].[SEEvalSessionWfHistory] DROP CONSTRAINT [FK_SEEvalSessionWfHistory_SEUser]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSessionWfHistory_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionWfHistory]'))
ALTER TABLE [dbo].[SEEvalSessionWfHistory] DROP CONSTRAINT [FK_SEEvalSessionWfHistory_SEUser1]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WfHistory_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionWfHistory]'))
ALTER TABLE [dbo].[SEEvalSessionWfHistory] DROP CONSTRAINT [FK_WfHistory_SEEvalSession]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WfHistory_WfTransition]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionWfHistory]'))
ALTER TABLE [dbo].[SEEvalSessionWfHistory] DROP CONSTRAINT [FK_WfHistory_WfTransition]


IF Exists(select * from sys.columns where Name = N'WfStateID'  
            and Object_ID = Object_ID(N'SEEvalSession'))
BEGIN
	ALTER TABLE dbo.SEEvalSession
	DROP COLUMN WfStateID
END

IF Exists(select * from sys.tables where Name = N'SEEvalSessionWfHistory' )
BEGIN
	DROP TABLE dbo.SEEvalSessionWfHistory
END
IF Exists(select * from sys.tables where Name = N'SEWfTransition' )
BEGIN
	DROP TABLE dbo.SEWfTransition
END
IF Exists(select * from sys.tables where Name = N'SEWfState' )
BEGIN
	DROP TABLE dbo.SEWfState
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