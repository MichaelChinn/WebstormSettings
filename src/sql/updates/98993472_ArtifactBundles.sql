
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 98993472
, @title = '98993472_ArtifactBundles'
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

INSERT SEArtifactLibItemType(Name) VALUES('FILE')
INSERT SEArtifactLibItemType(Name) VALUES('WEB')
INSERT SEArtifactLibItemType(Name) VALUES('PROF-PRACTICE')

SET IDENTITY_INSERT [dbo].[SEWfState] ON
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (6, N'Artifact', N'Collection has been registered', N'ARTIFACT')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (7, N'Private Evidence', N'The artifact is private evidence', N'PRIVATE EVIDENCE')
INSERT [dbo].[SEWfState] ([WfStateID], [Title], [Description], [ShortName]) VALUES (8, N'Public Evidence', N'The artifact is public evidence', N'PUBLIC EVIDENCE')
SET IDENTITY_INSERT [dbo].[SEWfState] OFF

-- select * from sewftransition

INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (6, 7, NULL)
INSERT [dbo].[SEWfTransition] ([StartStateID], [EndStateID], [description]) VALUES (7, 8, NULL)


INSERT SEResourceItemType(Name) VALUES('FILE')
INSERT SEResourceItemType(Name) VALUES('WEB')


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


