
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
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

select @bugFixed = 34766767
, @title = 'District accounts in batch'
, @comment = 'demo version... esd cel, dan and mar districts'


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2461
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug2)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug2 AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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

/*
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31016', @pDistrictCode = 'CL101', @pUserName = 'ESD 101 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '17408', @pDistrictCode = 'CL105', @pUserName = 'ESD 105 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27931', @pDistrictCode = 'CL112', @pUserName = 'ESD 112 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '06119', @pDistrictCode = 'CL113', @pUserName = 'ESD 113 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37501', @pDistrictCode = 'CL114', @pUserName = 'ESD 114 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '01122', @pDistrictCode = 'CL121', @pUserName = 'ESD 121 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27403', @pDistrictCode = 'CL123', @pUserName = 'ESD 123 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20203', @pDistrictCode = 'CL171', @pUserName = 'ESD 171 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '37503', @pDistrictCode = 'CL189', @pUserName = 'ESD 189 CEL SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '18100', @pDistrictCode = 'CLAWS', @pUserName = 'AWSP CEL SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '09075', @pDistrictCode = 'CLOSP', @pUserName = 'OSPI CEL SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '16046', @pDistrictCode = 'CLWEA', @pUserName = 'WEA CEL SD'    
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29100', @pDistrictCode = 'DA101', @pUserName = 'ESD 101 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '20215', @pDistrictCode = 'DA105', @pUserName = 'ESD 105 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '18401', @pDistrictCode = 'DA112', @pUserName = 'ESD 112 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21926', @pDistrictCode = 'DA113', @pUserName = 'ESD 113 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '21401', @pDistrictCode = 'DA114', @pUserName = 'ESD 114 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '02250', @pDistrictCode = 'DA121', @pUserName = 'ESD 121 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27400', @pDistrictCode = 'DA123', @pUserName = 'ESD 123 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '27932', @pDistrictCode = 'DA171', @pUserName = 'ESD 171 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38300', @pDistrictCode = 'DA189', @pUserName = 'ESD 189 DAN SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36250', @pDistrictCode = 'DAAWS', @pUserName = 'AWSP DAN SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '38306', @pDistrictCode = 'DAOSP', @pUserName = 'OSPI DAN SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33206', @pDistrictCode = 'DAWEA', @pUserName = 'WEA DAN SD'    
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '36400', @pDistrictCode = 'MA101', @pUserName = 'ESD 101 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '33115', @pDistrictCode = 'MA105', @pUserName = 'ESD 105 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '29011', @pDistrictCode = 'MA112', @pUserName = 'ESD 112 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '13151', @pDistrictCode = 'MA113', @pUserName = 'ESD 113 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '05313', @pDistrictCode = 'MA114', @pUserName = 'ESD 114 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '22073', @pDistrictCode = 'MA121', @pUserName = 'ESD 121 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '10050', @pDistrictCode = 'MA123', @pUserName = 'ESD 123 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '26059', @pDistrictCode = 'MA171', @pUserName = 'ESD 171 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '19007', @pDistrictCode = 'MA189', @pUserName = 'ESD 189 MAR SD'
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '31330', @pDistrictCode = 'MAAWS', @pUserName = 'AWSP MAR SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '07002', @pDistrictCode = 'MAOSP', @pUserName = 'OSPI MAR SD'   
exec InsertSEUser @pFirstname ='District', @pEmail = '', @pSchoolCode = '', @pLastname = '32414', @pDistrictCode = 'MAWEA', @pUserName = 'WEA MAR SD'        
*/
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed 34766767. In: ' 
			+ Convert(varchar(20), @bugFixed)
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
