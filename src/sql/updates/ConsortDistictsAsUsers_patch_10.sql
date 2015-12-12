
DECLARE @ahora dateTime
SELECT @ahora = GETDATE()

if ( (select max(versionnumber) from updateLog) is null)
begin
	INSERT updateLog(versionnumber, updateName, comment, timestamp)
	values (1, 'Initial Entry', 'A Do Nothing update', @ahora)
end


/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @thisVersion bigint, @title varchar(100), @comment varchar(400)
SELECT  @sql_error= 0,@tran_count = @@TRANCOUNT , @prevVersion = ISNULL(max(versionNumber), 0) from dbo.UpdateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @thisVersion = 10
, @title = 'Insert Consortium Districts as Users'
, @comment = 'without this, the district guy cannot view or add resources'
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the version number, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version table), but the change won't be
        made again.
*/
if ((select versionNumber from dbo.updateLog where versionNumber = @thisVersion) is not null)
BEGIN
	SELECT @sql_error_message = 'Error: Patch #' + Convert(varchar(20), @thisVersion) + ' has already been applied'
    GOTO ProcEnd
END
if (@prevVersion <> @thisVersion -1)
BEGIN
  SELECT @sql_Error = -1, @sql_error_message = 'Version mismatch... this version:' 
		+ Convert(varchar (20),@thisVersion) + '... prevVersion: ' + Convert(varchar(20),@prevVersion)
  GOTO ErrorHandler
END

INSERT dbo.UpdateLog (VersionNumber, UpdateName, TimeStamp) values (@thisVersion, @title, @ahora)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '01160'  , @pDistrictCode = '01160', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Ritzville School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '22009'  , @pDistrictCode = '22009', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Reardan-Edwall School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '22017'  , @pDistrictCode = '22017', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Almira School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '22200'  , @pDistrictCode = '22200', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Wilbur School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '22207'  , @pDistrictCode = '22207', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Davenport School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '32362'  , @pDistrictCode = '32362', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Liberty School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '33049'  , @pDistrictCode = '33049', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Wellpinit School District'
exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = '38267'  , @pDistrictCode = '38267', @pEmail = '', @pSchoolCode = ''  , @pUserName ='Pullman School District'


IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'problem inserting consortium districts as users In: ' 
		+ @thisVersion
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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
