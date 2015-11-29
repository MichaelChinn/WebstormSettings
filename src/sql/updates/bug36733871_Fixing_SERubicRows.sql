
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

select @bugFixed = 36733871
, @title = 'bug36733871_Fixing_SERubicRows.sql'
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

-- MAR
UPDATE [dbo].[SERubricRow]
   SET [Title] = '1.4: Demonstrating Value and Respect for Typically Underserved Students <br> The teacher demonstrates value and respect for all, including typically underserved students.'
	  ,[PL1Descriptor] = 'When the strategy is called for the teacher does not use it, or the teacher uses strategy incorrectly or with parts missing.'
      ,[PL2Descriptor] = 'The teacher minimally uses verbal and nonverbal behaviors that indicate value and respect for students, with particular attention to those typically underserved.'
      ,[PL3Descriptor] = 'The teacher uses verbal and nonverbal behaviors that indicate value and respect for students, with particular attention to those typically underserved, and monitors the quality of relationships in the classroom.'
      ,[PL4Descriptor] = 'The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.'
 WHERE [Title] = '1.4: Demonstrating Value and Respect for Typically Undeserved Students <br> The teacher demonstrates value and respect for all, including typically underserved students.'

UPDATE [dbo].[SERubricRow]
   SET [Title] = '2.4: Asking Questions of Typically Underserved Students <br> The teacher asks questions of typically underserved students with the same frequency and depth as other students.'
	  ,[PL1Descriptor] = 'When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.'
      ,[PL2Descriptor] = 'The teacher asks questions of all students with the same frequency and depth but does not monitor the quality of participation.'
      ,[PL3Descriptor] = 'The teacher asks questions of all students with the same frequency and depth and monitors the quality of participation.'
      ,[PL4Descriptor] = 'The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.'
 WHERE [Title] = '2.4: Asking Questions of Typically Undeserved Students <br> The teacher asks questions of typically underserved students with the same frequency and depth as other students.'

UPDATE [dbo].[SERubricRow]
   SET [Title] = '2.5: Probing Incorrect Answers with Typically Underserved Students <br> The teacher probes typically underserved students’ incorrect answers in the same manner as other students’ incorrect answers.'
      ,[PL1Descriptor] = 'When the strategy is called for the teacher does not use it or the teacher uses the strategy incorrectly or with parts missing.'
      ,[PL2Descriptor] = 'The teacher is not consistent in probing all students’ incorrect answers.'
      ,[PL3Descriptor] = 'The teacher probes all students’ incorrect answers and monitors the level and quality of the responses.'
      ,[PL4Descriptor] = 'The teacher adapts or creates new strategies to meet the specific needs of students for whom the typical application of strategies does not produce the desired effect.'
 WHERE [Title] = '2.5: Probing Incorrect Answers with Typically Undeserved Students <br> The teacher probes typically underserved students’ incorrect answers in the same manner as other students’ incorrect answers.'

-- CEL
UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Teacher rarely or never provides scaffolds and structures that are related to and support the development of the targeted concepts and/or skills.'
      ,[PL2Descriptor] = 'Teacher provides limited scaffolds and structures that may or may not be related to and support the development of the targeted concepts and/or skills.'
      ,[PL3Descriptor] = 'Teacher provides scaffolds and structures that are clearly related to and support the development of the targeted concepts and/or skills.'
      ,[PL4Descriptor] = 'Teacher provides scaffolds and structures that are clearly related to and support the development of the targeted concepts and/or skills. Students use scaffolds across tasks with similar demands.'
 WHERE [Title] = 'CP6    Curriculum & Pedagogy – Scaffolds for Learning: Scaffolds the task'

UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'The lesson is rarely or never linked to previous and future lessons.'
      ,[PL2Descriptor] = 'The lesson is clearly linked to previous and future lessons.'
      ,[PL3Descriptor] = 'The lessons is clearly linked to previous and future lessons. Lessons build on each other in a logical progression.'
      ,[PL4Descriptor] = 'The lesson is clearly linked to previous and future lessons. Lessons build on each other in ways that enhance student learning. Students understand how the lesson relates to previous lesson.'
 WHERE [Title] = 'P2    Purpose – Standards: Connection to previous and future lessons'

UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Instruction is rarely or never consistent with pedagogical content knowledge and does not support students in discipline-specific habits of thinking.'
      ,[PL2Descriptor] = 'Instruction is occasionally consistent with pedagogical content knoweldge and supports students in discipline-specific habits of thinking.'
      ,[PL3Descriptor] = 'Instruction is frequently consistent with pedagogical content knowledge and supports students in discipline-specific habits of thinking.'
      ,[PL4Descriptor] = 'Instruction is always consistent with pedagogical content knowledge and supports students in discipline-specific habits of thinking.'
 WHERE [Title] = 'CP3    Curriculum & Pedagogy – Teaching Approaches and/or Strategies: Pedagogical content knowledge'

-- All
UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential. Goals do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL2Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL3Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL4Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
 WHERE [Title] = 'SG 3.1 Establish Student Growth Goal(s)'

UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Growth or achievement data from at least two points in time shows no evidence of growth for most students.'
      ,[PL2Descriptor] = 'Multiple sources of growth or achievemetn data from at least two points in time show some evidence of growth for some students.'
      ,[PL3Descriptor] = 'Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.'
      ,[PL4Descriptor] = 'Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.'
 WHERE [Title] = 'SG 3.2 Achievement of Student Growth Goal(s)'

UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Does not establish student growth goals or establishes inappropriate goals for subgroups of students not reaching full learning potential. Goals do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL2Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals do not identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL3Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full learning potential.  Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
      ,[PL4Descriptor] = 'Establishes appropriate student growth goals for subgroups of students not reaching full potential in collaboration with students, parents, and other school staff. Goals identify multiple, high-quality sources of data to monitor, adjust, and evaluate achievement of goals.'
 WHERE [Title] = 'SG 6.1 Establish Student Growth Goal(s)'

UPDATE [dbo].[SERubricRow]
   SET [PL1Descriptor] = 'Growth or achievement data from at least two points in time shows no evidence of growth for most students.'
      ,[PL2Descriptor] = 'Multiple sources of growth or achievemetn data from at least two points in time show some evidence of growth for some students.'
      ,[PL3Descriptor] = 'Multiple sources of growth or achievement data from at least two points in time show clear evidence of growth for most students.'
      ,[PL4Descriptor] = 'Multiple sources of growth or achievement data from at least two points in time show evidence of high growth for all or nearly all students.'
 WHERE [Title] = 'SG 6.2 Achievement of Student Growth Goal(s)'



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
