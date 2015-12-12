
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

select @bugFixed = 103871794
, @title = '103871794_NewDistrictSchoolsFromSeptCDSMaster'
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


--DROP TABLE #newDistricts   DROP TABLE #newSchools

CREATE TABLE #newDistricts (districtCode VARCHAR(10))
insert #newDistricts (districtCode)

SELECT districtCode FROM coe_user_staging.dbo.cds_20150831
EXCEPT
SELECT districtcode FROM sedistrictschool

CREATE TABLE #newSchools (schoolCode VARCHAR(10))
INSERT #newSchools(schoolCode)
SELECT schoolCode FROM coe_user_staging.dbo.cds_20150831
EXCEPT
SELECT schoolCode FROM sedistrictschool

INSERT seDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)


SELECT DISTINCT nd.districtCode, '', extendedDistrictSchoolName, 0,0 
FROM coe_user_staging.dbo.cds_20150831 cds
JOIN #newDistricts nd ON nd.districtcode = cds.DistrictCode
WHERE schoolcode = ''


INSERT seDistrictSchool (districtCode, schoolCode, districtSchoolName, isSchool, isSecondary)

SELECT DISTINCT cds.DistrictCode, ns.schoolCode, extendedDistrictSchoolName, 1,0 
FROM coe_user_staging.dbo.cds_20150831 cds
JOIN #newSchools ns ON ns.schoolCode = cds.schoolCode
WHERE ns.schoolcode <> '' AND ns.schoolCode <> '0001'




/*
--have to fix up the seSchoolConfiguration table.  But can't just
--go blindly putting in school codes.  Here is the query that generated
--what new records were inserted into the table...


select distinct
        ds.districtcode ,
        ds.schoolcode
from    seDistrictSchool ds
        join (
			--this is the core of it; what's in seDistrictSchool that 
			-- isn't in the SESchoolConfiguration table?
               select   schoolcode
               from     SEDistrictSchool
               except
               select   schoolcode
               from     SESchoolConfiguration
             ) x on fw.DistrictCode = ds.districtcode

		--but also now join with the frameworks districts picked for 2016
        join SEFramework fw on x.schoolCode = ds.schoolCode


where   ds.schoolCode <> ''
        and fw.SchoolYear = 2016

*/
USE stateeval
 insert SESchoolConfiguration(DistrictCode, SchoolCode, HasBeenSubmittedToDistrictTE, SubmissionToDistrictDateTE, IsPrincipalAssignmentDelegated, 
   SchoolYear, PK_SESchoolConfiguration)

values('31015','5358', 0, null, 0, 2016, null),
('17001','5405', 0, null, 0, 2016, null),
('11001','5394', 0, null, 0, 2016, null),
('37501','5340', 0, null, 0, 2016, null),
('04228','5418', 0, null, 0, 2016, null),
('31002','5414', 0, null, 0, 2016, null),
('27416','5338', 0, null, 0, 2016, null),
('18100','5395', 0, null, 0, 2016, null),
('11001','5391', 0, null, 0, 2016, null),
('32360','5396', 0, null, 0, 2016, null),
('06037','5342', 0, null, 0, 2016, null),
('31311','5329', 0, null, 0, 2016, null),
('11001','5392', 0, null, 0, 2016, null),
('27400','5411', 0, null, 0, 2016, null),
('11001','5345', 0, null, 0, 2016, null),
('37501','5366', 0, null, 0, 2016, null),
('11001','5393', 0, null, 0, 2016, null),
('32354','5401', 0, null, 0, 2016, null),
('32356','5328', 0, null, 0, 2016, null),
('27400','5387', 0, null, 0, 2016, null),
('17001','3518', 0, null, 0, 2016, null),
('17001','5406', 0, null, 0, 2016, null),
('17001','5351', 0, null, 0, 2016, null),
('05402','5363', 0, null, 0, 2016, null),
('13161','5323', 0, null, 0, 2016, null),
('31002','5330', 0, null, 0, 2016, null),
('27403','5372', 0, null, 0, 2016, null)

/*... a check... the below are from the above, and shouldn't be
in the seschoolconfiguration table already
SELECT * FROM dbo.SESchoolConfiguration WHERE schoolcode IN (

'5358','5405','5394','5340','5418','5414','5338','5395',
'5391','5396','5342','5329','5392','5411','5345','5366',
'5393','5401','5328','5387','3518','5406','5351','5363',
'5323','5330','5372')
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

GO
