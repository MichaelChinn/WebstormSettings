
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 85669010
, @title = '85669010_finalSubmissionWF_Data'
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

SET IDENTITY_INSERT [dbo].[SEWfState] ON
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (1, N'Draft', N'Collection has been registered', N'DRAFT')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (2, N'Ready For Conference', N'The evaluation is ready for conference', N'CONFERENCE')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (3, N'Ready For Formal Receipt', N'The evaluation is ready for formal receipt', N'RECEIPT')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (4, N'Received', N'The evaluation has been received', N'RECEIVED')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (5, N'Submitted', N'The evaluation has been submitted', N'SUBMITTED')
SET IDENTITY_INSERT [dbo].[SEWfState] OFF

-- select * from sewftransition

INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (1, 2, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (2, 3, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (3, 4, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (3, 5, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (4, 5, NULL)

INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (2, 1, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (3, 1, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (5, 1, NULL)

UPDATE SEEvaluation SET WfSTateID=1 WHERE HasBeenSubmitted=0
UPDATE SEEvaluation SET WfSTateID=4, VisibleToEvaluatee=1 WHERE HasBeenSubmitted=1

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


