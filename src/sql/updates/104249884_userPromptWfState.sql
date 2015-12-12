
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 104249884
, @title = '104249884_userPromptWfState'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update theset version log), but the change won't be
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

alter table SEUserPrompt add WfStateID BIGINT NULL

ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])

ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEWfState]

SET IDENTITY_INSERT [dbo].[SEWfState] ON
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (21, N'USERPROMPT INPROGRESS', N'USERPROMPT INPROGRESS', N'INPROGRESS')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (22, N'USERPROMPT FINALIZED', N'USERPROMPT FINALIZED', N'RETIRED')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (23, N'USEPROMPT RETIRED', N'RETIRED', N'RETIRED')
SET IDENTITY_INSERT [dbo].[SEWfState] OFF

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





 




