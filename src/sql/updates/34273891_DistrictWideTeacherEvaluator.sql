
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 34273891
, @title = 'District-wide Teacher Evaluator, 8/17/2012'
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

EXEC aspnet_Roles_CreateRole 'SE', 'SETeacherEvaluator'
-- added this because in a rebuild this role isn't here. I can't find any update script that created it.
EXEC aspnet_Roles_CreateRole 'SE', 'SEPrincipalEvaluator'

CREATE TABLE [dbo].[SEEvalAssignmentRequestType](
	[EvalAssignmentRequestTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequestType] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEEvalAssignmentRequestStatusType](
	[EvalAssignmentRequestStatusTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequestStatusType] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestStatusTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEEvalAssignmentRequest](
	[EvalAssignmentRequestID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[EvaluatorID] [bigint] NOT NULL,
	[RequestTypeID] [smallint] NOT NULL,
	[Status] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequest] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType] FOREIGN KEY([Status])
REFERENCES [dbo].[SEEvalAssignmentRequestStatusType] ([EvalAssignmentRequestStatusTypeID])
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]

ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType] FOREIGN KEY([RequestTypeID])
REFERENCES [dbo].[SEEvalAssignmentRequestType] ([EvalAssignmentRequestTypeID])
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SESchoolYear]
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser] FOREIGN KEY([EvaluatorID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser]
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser1] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser1]

DECLARE @Query VARCHAR(MAX)
SELECT @Query = 'INSERT SEEvalAssignmentRequestType(Name) VALUES(''Observations Only'')'
EXEC(@Query)
SELECT @Query = 'INSERT SEEvalAssignmentRequestType(Name) VALUES(''Assigned Evaluator'')'
EXEC(@Query)

SELECT @Query = 'INSERT SEEvalAssignmentRequestStatusType(Name) VALUES(''Pending'')'
EXEC(@Query)
SELECT @Query = 'INSERT SEEvalAssignmentRequestStatusType(Name) VALUES(''Accepted'')'
EXEC(@Query)
SELECT @Query = 'INSERT SEEvalAssignmentRequestStatusType(Name) VALUES(''Rejected'')'
EXEC(@Query)

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



