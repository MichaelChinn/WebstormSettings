
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

select @bugFixed = 38524817
, @title = 'bug38524817_CorrectedStudentGrowthText'
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

declare @sg310 varchar (1000),  @sg320 varchar (1000), @sg610 varchar (1000), @sg620 varchar (1000), @sg810 varchar (1000)
declare @sg311 varchar (1000),  @sg321 varchar (1000), @sg611 varchar (1000), @sg621 varchar (1000), @sg811 varchar (1000)
declare @sg312 varchar (1000),  @sg322 varchar (1000), @sg612 varchar (1000), @sg622 varchar (1000), @sg812 varchar (1000)
declare @sg313 varchar (1000),  @sg323 varchar (1000), @sg613 varchar (1000), @sg623 varchar (1000), @sg813 varchar (1000)
declare @sg314 varchar (1000),  @sg324 varchar (1000), @sg614 varchar (1000), @sg624 varchar (1000), @sg814 varchar (1000)



select @sg310='SG 3.1: Establish Student Growth Goal(s)'
select @sg311='Does not establish student growth goal(s) or establishes inappropriate goal(s) for subgroups of students not reaching full learning potential.  Goal(s) do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg312='Establishes appropriate student growth goal(s) for subgroups of students not reaching full learning potential.  Goal(s) do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg313='Establishes appropriate student growth goal(s) for subgroups of students not reaching full learning potential.  Goal(s) identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg314='Establishes appropriate student growth goal(s) for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goal(s) identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg320='SG 3.2: Achievement of Student Growth Goal(s)'
select @sg321='Growth or achievement data from at least two points in time shows no evidence of growth for most students.'
select @sg322='Multiple sources of growth or achievement data from at least two points in time show some evidence of growth for some students.'
select @sg323='Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.'
select @sg324='Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.'
select @sg610='SG 6.1: Establish Student Growth Goal(s)'
select @sg611='Does not establish student growth goal(s) or establishes inappropriate goal(s) for whole classroom.  Goal(s) do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg612='Establishes appropriate student growth goal(s) for whole classroom.  Goal(s) do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg613='Establishes appropriate student growth goal(s) for whole classroom.  Goal(s) identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg614='Establishes appropriate student growth goal(s) for  students in collaboration with students and parents. These whole classroom goals align to school goal(s). Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goal(s).'
select @sg620='SG 6.2: Achievement of Student Growth Goal(s)'
select @sg621='Growth or achievement data from at least two points in time shows no evidence of growth for most students.'
select @sg622='Multiple sources of growth or achievement data from at least two points in time show some evidence of growth for some students.'
select @sg623='Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.'
select @sg624='Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.'
select @sg810='SG 8.1: Establish Team Student Growth Goal(s)'
select @sg811='Does not collaborate or reluctantly collaborates with other grade, school, or district team members to establish goal(s), to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.'
select @sg812='Does not consistently collaborate with other grade, school, or district team members to establish goal(s), to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.'
select @sg813='Consistently and actively collaborates with other grade, school, or district team members to establish goal(s), to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.'
select @sg814='Leads other grade, school, or district team members to establish goal(s), to develop and implement common, high-quality measures, and to monitor growth and achievement during the year.'


update seRubricRow set title = @sg310 ,pl1Descriptor = @sg311 ,pl2Descriptor = @sg312 ,pl3Descriptor = @sg313 ,pl4Descriptor = @sg314 where title like 'SG 3.1%'      
update seRubricRow set title = @sg320 ,pl1Descriptor = @sg321 ,pl2Descriptor = @sg322 ,pl3Descriptor = @sg323 ,pl4Descriptor = @sg324 where title like 'SG 3.2%'      
update seRubricRow set title = @sg610 ,pl1Descriptor = @sg611 ,pl2Descriptor = @sg612 ,pl3Descriptor = @sg613 ,pl4Descriptor = @sg614 where title like 'SG 6.1%'      
update seRubricRow set title = @sg620 ,pl1Descriptor = @sg621 ,pl2Descriptor = @sg622 ,pl3Descriptor = @sg623 ,pl4Descriptor = @sg624 where title like 'SG 6.2%'      
update seRubricRow set title = @sg810 ,pl1Descriptor = @sg811 ,pl2Descriptor = @sg812 ,pl3Descriptor = @sg813 ,pl4Descriptor = @sg814 where title like 'SG 8.1%'      
                                                                                                                                                                     


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
