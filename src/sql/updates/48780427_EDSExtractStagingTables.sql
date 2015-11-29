
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime , @NextVersion bigint
SELECT  @ahora = GETDATE()
SELECT @sql_error= 0,@tran_count = @@TRANCOUNT  FROM dbo.updateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 48780427
, @title = '48780427_EDSExtractStagingTables'
, @comment = 'need to pre-create tables for EDSUser and EDSRoles'
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

INSERT dbo.UpdateLog ( bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

CREATE TABLE eDsroles
    (
      PersonId BIGINT ,
      OrganizationName VARCHAR(200) ,
      OSPILegacyCode VARCHAR(20) ,
      OrganizationRoleName VARCHAR(6000)
    )
    
CREATE TABLE eDsUsers
    (
      PersonId BIGINT ,
      FirstName VARCHAR(200) ,
      LastName VARCHAR(200) ,
      Email VARCHAR(6000)
    )

CREATE TABLE EDSStaging
    (
      stagingId BIGINT IDENTITY(1, 1) ,
      personID BIGINT ,
      locationCode VARCHAR(20) ,
      locationName VARCHAR(200) ,
      roleString VARCHAR(MAX) ,
      rawRoleString VARCHAR(MAX) ,
      districtCode VARCHAR(10) ,
      schoolCode VARCHAR(10) ,
      seEvaluationTypeID SMALLINT ,
      cAspnetUsers VARCHAR(200) ,
      cAspnetUIR VARCHAR(200) ,
      cInsertEval VARCHAR(200) ,
      isNew BIT ,
      firstEntry BIT 
    )
    
CREATE TABLE EDSError
    (
      stagingId BIGINT ,
      personID BIGINT ,
      locationCode VARCHAR(20) ,
      locationName VARCHAR(200) ,
      roleString VARCHAR(MAX) ,
      rawRoleString VARCHAR(MAX) ,
      districtCode VARCHAR(10) ,
      schoolCode VARCHAR(10) ,
      seEvaluationTypeID SMALLINT ,
      cAspnetUsers VARCHAR(200) ,
      cAspnetUIR VARCHAR(200) ,
      cInsertEval VARCHAR(200) ,
      isNew BIT ,
      firstEntry BIT ,
      errorMsg VARCHAR(200) 
    )

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