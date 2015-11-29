
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime , @NextVersion bigint
SELECT  @ahora = GETDATE()
SELECT @sql_error= 0,@tran_count = @@TRANCOUNT  FROM dbo.updateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 56963908
, @title = '56963908_newCDSMaster'
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



INSERT  seDistrictSchool
        ( districtcode ,
          schoolcode ,
          districtschoolName ,
          isschool ,
          issecondary
        )
        SELECT  districtcode ,
                schoolcode ,
                ExtendedDistrictSchoolName ,
                1 ,
                0
        FROM    stateeval_proto.dbo.cds_latest
        WHERE   schoolcode IN ( SELECT  schoolcode
                                FROM    stateeval_proto.dbo.CDS_Latest
                                EXCEPT
                                SELECT  schoolcode
                                FROM    dbo.SEDistrictSchool )
                AND schoolcode <> '0001'


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'bad insert new. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END



UPDATE  seDistrictSchool
SET     districtSchoolName = l.extendedDistrictSchoolName
FROM    seDistrictSchool ds
        JOIN stateeval_proto.dbo.cds_latest l ON l.districtcode = ds.districtcode
                                                 AND l.schoolcode = ds.schoolcode
WHERE   ds.districtSchoolName <> l.ExtendedDistrictSchoolName


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'bad update. In: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END



--now stuff in any necessary seSchoolConfiguration records for 
--any schools whose districts have chosen for 2014

INSERT  seschoolconfiguration
        ( schoolcode ,
          districtcode ,
          hasbeensubmittedTodistrictTE ,
          isprincipalAssignmentDelegated ,
          schoolYear
        )
        SELECT  schoolcode ,
                sn.districtcode ,
                0 ,
                0 ,
                2014
        FROM    dbo.vSchoolName sn
                JOIN dbo.SEFramework f ON f.DistrictCode = sn.districtCode
        WHERE   f.SchoolYear = 2014
        EXCEPT
        SELECT  schoolCode ,
                districtcode ,
                0 ,
                0 ,
                2014
        FROM    dbo.SESchoolConfiguration


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
