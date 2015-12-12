
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

select @bugFixed = 37119453
, @title = 'bug34453127_AddNewSchoolsFromCDS_20120914'
, @comment = 'schools added on 9/14, whose districts were loaded mid-august'


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

	CREATE TABLE #m (districtcode VARCHAR (20), schoolcode VARCHAR (20))
insert #m(districtcode, schoolCode)values ('32081','1533')
insert #m(districtcode, schoolCode)values ('32081','1567')
insert #m(districtcode, schoolCode)values ('32081','1603')
insert #m(districtcode, schoolCode)values ('32081','1604')
insert #m(districtcode, schoolCode)values ('32081','1698')
insert #m(districtcode, schoolCode)values ('32081','1767')
insert #m(districtcode, schoolCode)values ('31002','1810')
insert #m(districtcode, schoolCode)values ('32081','2045')
insert #m(districtcode, schoolCode)values ('37501','2075')
insert #m(districtcode, schoolCode)values ('17001','2977')
insert #m(districtcode, schoolCode)values ('32081','3008')
insert #m(districtcode, schoolCode)values ('17001','3380')
insert #m(districtcode, schoolCode)values ('32081','3819')
insert #m(districtcode, schoolCode)values ('32081','4286')
insert #m(districtcode, schoolCode)values ('36140','5187')
insert #m(districtcode, schoolCode)values ('17210','5218')
insert #m(districtcode, schoolCode)values ('17210','5219')
insert #m(districtcode, schoolCode)values ('39119','5232')
insert #m(districtcode, schoolCode)values ('15204','5234')
insert #m(districtcode, schoolCode)values ('03017','5235')
insert #m(districtcode, schoolCode)values ('16048','5236')
insert #m(districtcode, schoolCode)values ('22009','5237')
insert #m(districtcode, schoolCode)values ('25155','5238')
insert #m(districtcode, schoolCode)values ('37501','5239')
insert #m(districtcode, schoolCode)values ('17405','5240')
insert #m(districtcode, schoolCode)values ('30303','5241')
insert #m(districtcode, schoolCode)values ('19028','5242')
insert #m(districtcode, schoolCode)values ('25118','5243')
insert #m(districtcode, schoolCode)values ('17407','5244')
insert #m(districtcode, schoolCode)values ('37502','5245')
insert #m(districtcode, schoolCode)values ('08404','5246')
insert #m(districtcode, schoolCode)values ('25118','5247')
insert #m(districtcode, schoolCode)values ('34111','5248')
insert #m(districtcode, schoolCode)values ('32081','5249')
insert #m(districtcode, schoolCode)values ('32081','5250')
insert #m(districtcode, schoolCode)values ('13161','5251')
insert #m(districtcode, schoolCode)values ('33211','5252')
insert #m(districtcode, schoolCode)values ('17401','5254')
insert #m(districtcode, schoolCode)values ('17210','5255')
insert #m(districtcode, schoolCode)values ('36402','5256')
insert #m(districtcode, schoolCode)values ('36402','5257')
insert #m(districtcode, schoolCode)values ('06037','5258')
insert #m(districtcode, schoolCode)values ('34111','5259')
insert #m(districtcode, schoolCode)values ('17001','5260')
insert #m(districtcode, schoolCode)values ('11051','5261')
insert #m(districtcode, schoolCode)values ('39202','5262')
insert #m(districtcode, schoolCode)values ('39007','5263')
insert #m(districtcode, schoolCode)values ('39007','5264')
insert #m(districtcode, schoolCode)values ('17414','5265')
insert #m(districtcode, schoolCode)values ('33207','5266')
insert #m(districtcode, schoolCode)values ('33207','5267')
insert #m(districtcode, schoolCode)values ('32354','5268')
insert #m(districtcode, schoolCode)values ('32360','5269')
insert #m(districtcode, schoolCode)values ('06037','5271')
insert #m(districtcode, schoolCode)values ('24111','5272')
insert #m(districtcode, schoolCode)values ('13161','5273')
insert #m(districtcode, schoolCode)values ('20406','5274')
insert #m(districtcode, schoolCode)values ('17415','5275')
insert #m(districtcode, schoolCode)values ('17001','5276')
insert #m(districtcode, schoolCode)values ('17401','5277')
insert #m(districtcode, schoolCode)values ('32356','5278')
insert #m(districtcode, schoolCode)values ('17210','5279')
insert #m(districtcode, schoolCode)values ('17210','5280')
insert #m(districtcode, schoolCode)values ('17403','5282')
insert #m(districtcode, schoolCode)values ('33206','5283')
insert #m(districtcode, schoolCode)values ('17406','5284')
insert #m(districtcode, schoolCode)values ('01147','5285')
insert #m(districtcode, schoolCode)values ('04019','5286')
insert #m(districtcode, schoolCode)values ('17412','5287')
insert #m(districtcode, schoolCode)values ('39120','5289')
insert #m(districtcode, schoolCode)values ('06801','5290')
insert #m(districtcode, schoolCode)values ('06119','5291')
insert #m(districtcode, schoolCode)values ('17001','5292')
insert #m(districtcode, schoolCode)values ('01158','5293')
insert #m(districtcode, schoolCode)values ('04228','5295')
insert #m(districtcode, schoolCode)values ('17410','5296')
insert #m(districtcode, schoolCode)values ('27400','5297')
insert #m(districtcode, schoolCode)values ('27400','5298')
insert #m(districtcode, schoolCode)values ('28144','5299')
insert #m(districtcode, schoolCode)values ('27404','5300')
insert #m(districtcode, schoolCode)values ('32081','5301')



insert dbo.SESchoolConfiguration (DistrictCode, SchoolCode, HasBeenSubmittedToDistrictTE
	, SubmissionToDistrictDateTE, IsPrincipalAssignmentDelegated, SchoolYear)
SELECT distinct m.districtcode, m.schoolcode, 0, NULL, 0, 2013
FROM #m m JOIN seFramework f ON f.districtcode = m.districtcode
WHERE m.schoolcode NOT IN
(SELECT schoolcode FROM dbo.SESchoolConfiguration)
	
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem inserting seSchoolConfiguration' 

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
