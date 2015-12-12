
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

select @bugFixed = 36215815
, @title = 'bug36215815_ZapDupSEUserDistrictSchool.SQL'
, @comment = ''


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

set rowcount 1 delete from seUserDistrictSchool where SEUserID = 158   and schoolcode = ''   
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 253   and schoolcode = ''   
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 798   and schoolcode = ''   
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 889   and schoolcode = ''   
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1187  and schoolcode = ''   
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1551  and schoolcode = '2552'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 863   and schoolcode = '2701'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 855   and schoolcode = '2847'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 838   and schoolcode = '3090'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1203  and schoolcode = '3168'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 839   and schoolcode = '3173'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1554  and schoolcode = '3199'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 861   and schoolcode = '3225'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 836   and schoolcode = '3407'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 856   and schoolcode = '3436'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 844   and schoolcode = '3437'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 882   and schoolcode = '3486'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1486  and schoolcode = '3527'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1518  and schoolcode = '3664'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 854   and schoolcode = '3789'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1517  and schoolcode = '4004'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1254  and schoolcode = '4125'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1556  and schoolcode = '4205'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1560  and schoolcode = '4320'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1519  and schoolcode = '4365'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1508  and schoolcode = '4373'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 904   and schoolcode = '4382'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 848   and schoolcode = '5240'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1404  and schoolcode = '2799'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1565  and schoolcode = '2816'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 851   and schoolcode = '3100'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1567  and schoolcode = '3174'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 1564  and schoolcode = '3522'
set rowcount 1 delete from seUserDistrictSchool where SEUserID = 875   and schoolcode = '3633'

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
