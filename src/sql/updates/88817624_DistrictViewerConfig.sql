
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 88817624
, @title = '88817624_DistrictViewerConfig'
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

-- DA and DE no longer have to configure, we just allow them to see the ones that they are
-- the assigned evaluator for. Only ones that have to configure are new ones that come
-- in as role SEDistrictViewer
/*
CREATE TABLE #Temp(DistrictUserID BIGINT, SchoolCode VARCHAR(20), SchoolYear SMALLINT)
INSERT INTO #Temp(DistrictUserID, SchoolCode, SchoolYear)
SELECT DISTINCT v.DistrictUserID, v.SchoolCode, v.SchoolYear 
  FROM dbo.SEDistrictPRViewing v
  JOIN dbo.SEUser u ON v.DistrictUserID=u.SEUserID
 WHERE u.SEUserID NOT IN
      (SELECT u.SEUserID
         FROM dbo.SEUser u
		 JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
		 JOIN dbo.aspnet_Roles r ON ur.RoleId=r.RoleId
		WHERE r.RoleName IN ('SEDistrictAdmin', 'SEDistrictEvaluator'))
*/
ALTER TABLE [dbo].[SEDistrictPRViewing] DROP CONSTRAINT [FK_SEDAPRViewing_PRUserID]
ALTER TABLE [dbo].[SEDistrictPRViewing] DROP COLUMN [PRUserID]

DELETE dbo.SEDistrictPRViewing
/*
INSERT dbo.SEDistrictPRViewing(DistrictUserID, SchoolCode, SchoolYear)
SELECT DistrictUserID, SchoolCode, SchoolYear FROM #Temp
*/
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



