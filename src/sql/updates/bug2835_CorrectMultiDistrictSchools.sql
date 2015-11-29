
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2835
, @title = 'Correct schools that are in multiple districts'
, @comment = 'corrections from nancy and nathan, mail of 7/19'

DECLARE @dependsOnBug bigint
SET @dependsOnBug = 2898
--SET @dependsOnBug2 = 





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
	SELECT @sql_Error=-1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_Error=-1,  @sql_error_message = 'Error: Fail Bug patch : ' 
		+ CONVERT(VARCHAR(10),@bugFixed )+ ' DEPENDS ON BUG NOT APPLIED: ' + CONVERT(VARCHAR(10), @dependsOnBug)
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
17210 1952 Birth to Three Devel - remove
17401 1952 Birth to Three Devel - remove
17001 4068 Boyer Clinic         - remove
17401 4068 Boyer Clinic         -remove
17001 1782 Childhaven           -remove
17401 1782 Childhaven           -remove
17401 1955 Dynamic Family Servi -remove
17210 1955 Dynamic Family Servi -remove

29311 5960 Northwest Career & T -remove
09206 4105 Wenatchee Valley Tec -remove

Leave these... these are correct...
29320 5960 Northwest Career & T
04246 4105 Wenatchee Valley Tec

*/

--first three schools were closed completely
delete seDistrictSchool where schoolcode in ('1952', '4068', '1782', '1955')

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed removing closed schools. In: ' 
		+ CONVERT (VARCHAR(10), @bugFixed)
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

--these have incorrect districts      
delete seDistrictSchool where districtCode = '29311' and schoolcode = '5960'   --Northwest Career & T 
delete seDistrictSchool where districtCode = '09206' and schoolcode = '4105'   --Wenatchee Valley Tec 


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to insert new students from latest cedars. In: ' 
		+ CONVERT (VARCHAR(10), @bugFixed)
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- This brought over from what chris did; '00025' is not in cds master... it is an indiana district 
-- and must have been added by mistake to the prod database!!!!  !!!! !!!!
DELETE sedistrictschool WHERE districtCode='00025' AND schoolcode IN ('', '0029', '0033', '0037', '0041')


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Failed trying to remove indiana district. In: ' 
		+ CONVERT (VARCHAR(10), @bugFixed)
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
		+ 'Patch ERROR!!!>>>' + ISNULL(@sql_error_message, '')

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

/*

select * from coeStudentSiteconfig
select * from updatelog


*/