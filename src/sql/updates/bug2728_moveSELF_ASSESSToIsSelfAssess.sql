
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2728
, @title = 'Move SEEvaluationType.SELF_ASSESS to SEEvalSesion.IsSelfAssess'
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

ALTER TABLE dbo.SEEvalSession ADD IsSelfAssess BIT
ALTER TABLE [dbo].SEEvalSession ADD  CONSTRAINT [DF_SEEvalSession_IsSelfAssess]  DEFAULT ((0)) FOR [IsSelfAssess]

DECLARE @Query VARCHAR(200)
SELECT @Query = 
'UPDATE dbo.SEEvalSession 
   SET IsSelfAssess=
   CASE WHEN (EvaluationTypeID=3) THEN 1  ELSE 0 END'
EXEC (@Query)
   
UPDATE dbo.SEEvalSession
   SET EvaluationTypeID=
   CASE WHEN (EvaluationTypeID=3 AND EvaluateeUserID IN (SELECT u.SEUserID 
														   FROM dbo.SEUser u
														   JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
														   JOIN dbo.aspnet_Roles r on ur.RoleId=r.RoleId
														  WHERE r.RoleName='SESchoolPrincipal')) THEN 1 ELSE EvaluationTypeID END
														  
UPDATE dbo.SEEvalSession
   SET EvaluationTypeID=
   CASE WHEN (EvaluationTypeID=3 AND EvaluateeUserID IN (SELECT u.SEUserID 
														   FROM dbo.SEUser u
														   JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
														   JOIN dbo.aspnet_Roles r on ur.RoleId=r.RoleId
														  WHERE r.RoleName='SESchoolTeacher')) THEN 2 ELSE EvaluationTypeID END											  
   
DELETE SEEvaluationType WHERE Name='Self-Assess'

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
