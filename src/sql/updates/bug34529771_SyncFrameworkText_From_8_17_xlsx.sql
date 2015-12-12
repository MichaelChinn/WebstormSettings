
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

select @bugFixed = 34529771
, @title = 'bug34529771_SyncFrameworkText_From_8_17_xlsx.SQL'
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

--repair the titles first
update seframeworknode set title = rtrim ('Creating a school culture that promotes the ongoing improvement of learning and teaching for students and staff.                                                 ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C1' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Providing for school safety.                                                                                                                                     ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C2' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Leading development, implementation and evaluation of a data-driven plan for increasing student achievement, including the use of multiple student data elements.') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C3' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Assisting instructional staff with alignment of curriculum, instruction and assessment with state and local district learning goals.                             ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C4' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Monitoring, assisting and evaluating effective instruction and assessment practices.                                                                             ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C5' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Managing both staff and fiscal resources to support student achievement and legal responsibilities.                                                              ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C6' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Partnering with the school community to promote student learning.                                                                                                ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C7' and derivedFromFrameworkName = 'Prin, StateView'
update seframeworknode set title = rtrim ('Demonstrating commitment to closing the achievement gap.                                                                                                         ') from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkID where shortname = 'C8' and derivedFromFrameworkName = 'Prin, StateView'


update seRubricRow set pl4Descriptor = rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.') where title like'sg 3.2%'
update seRubricRow set pl4Descriptor = rtrim('Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.') where title like'sg 6.2%'


--sg principal rows...
update SERubricRow  set IsStudentGrowthAligned = 1
from SEFramework f
join SEFrameworkNode fn on fn.FrameworkID = f.FrameworkID
join SERubricRowFrameworkNode rrfn on rrfn.FrameworkNodeID = fn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
where f.SchoolYear = 2013 and f.DerivedFromFrameworkName like 'prin%'
and (rr.Title like '3.4%' or rr.Title like '5.2%' or rr.Title like '8.3%')

update seRubricRow set title = rtrim ('2a: Creating an Environment of Respect and Rapport') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '2a: Creating an Environment of Respect and Rapport'
update seRubricRow set title = rtrim ('2b: Establishing a Culture for Learning           ') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '2b: Establishing a Culture for Learning'
update seRubricRow set title = rtrim ('2c: Managing Classroom Procedures                 ') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '2c: Managing Classroom Procedures'
update seRubricRow set title = rtrim ('2e: Organizing Physical Space                     ') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '2e: Organizing Physical Space'
update seRubricRow set title = rtrim ('3c: Engaging Students in Learning                 ') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '3c: Engaging Students in Learning'
update seRubricRow set title = rtrim ('3e: Demonstrating Flexibility and Responsiveness  ') from seRubricRow rr join seRubricRowFrameworkNode rrfn on rrfn.rubricRowID = rr.rubricRowID join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID join seFramework f on f.frameworkID = fn.frameworkID where f.schoolyear = 2013 and f.DerivedFromFrameworkName like 'dan, ifw%' and rr.title = '3e: Demonstrating Flexibility and Responsiveness'

update seFrameworkNode set shortname ='A'   from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'a' 
update seFrameworkNode set shortname ='CEC' from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'cec'
update seFrameworkNode set shortname ='CP'  from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'cp' 
update seFrameworkNode set shortname ='P'   from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'p'  
update seFrameworkNode set shortname ='PCC' from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'pcc'
update seFrameworkNode set shortname ='SE'  from seFrameworkNode fn join seFramework f on f.frameworkId = fn.frameworkId where schoolYear = 2013 and derivedFromFrameworkName like 'cel, i%' and shortname = 'se' 

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
