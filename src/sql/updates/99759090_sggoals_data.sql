/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 99759090
, @title = '99759090_StudentGrowthGoals Data'
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
 
 -- Goal Setting Prompts
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2015, 'PR: Goal Setting Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2015, 'PR: Goal Setting Prompt 2?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2015, 'PR: Goal Setting Prompt 3?')

INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Context</b><br/> Describe the context, including student population?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Needs Assessment</b><br/> What student needs have been identified? What are the related content area essential/enduring skills, concepts and/or processes?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Sources of Evidence</b><br/> What sources of evidence/measures will you use to establish baseline data and measure student growth?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Interval of Instruction</b><br/> What is the course-long interval of instruction (i.e. trimester, semester, one school year, etc.)?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Expected Growth</b><br/> What is/are the target/targets for expected growth for all students? Keep in mind the growth goal should challenge students to exceed typical expectations. (For example, "During this school year all of my students will improve by one performance level ?.")')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2015, '<b>Expected Proficiency</b><br/> What is the proficiency target? What percentage of students will meet or exceed that target? (For example, XX% of my students will meet or exceed level 3 of the rubric?"')

INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2016, 'PR: Goal Setting Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2016, 'PR: Goal Setting Prompt 2?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 1, 2016, 'PR: Goal Setting Prompt 3?')

INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Context</b><br/> Describe the context, including student population?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Needs Assessment</b><br/> What student needs have been identified? What are the related content area essential/enduring skills, concepts and/or processes?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Sources of Evidence</b><br/> What sources of evidence/measures will you use to establish baseline data and measure student growth?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Interval of Instruction</b><br/> What is the course-long interval of instruction (i.e. trimester, semester, one school year, etc.)?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Expected Growth</b><br/> What is/are the target/targets for expected growth for all students? Keep in mind the growth goal should challenge students to exceed typical expectations. (For example, "During this school year all of my students will improve by one performance level ?.")')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(1, '', 2, 2016, '<b>Expected Proficiency</b><br/> What is the proficiency target? What percentage of students will meet or exceed that target? (For example, XX% of my students will meet or exceed level 3 of the rubric?"')

-- Goal Monitoring Prompts
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(2, '', 1, 2015, 'PR: Goal Monitoring Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(2, '', 2, 2015, 'TR: Goal Monitoring Prompt 1?')

INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(2, '', 1, 2016, 'PR: Goal Monitoring Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(2, '', 2, 2015, 'TR: Goal Monitoring Prompt 1?')

-- Goal Review Prompts
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(3, '', 1, 2015, 'PR: Goal Review Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(3, '', 2, 2015, 'TR: Goal Review Prompt 1?')

INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(3, '', 1, 2016, 'PR: Goal Review Prompt 1?')
INSERT dbo.SEStudentGrowthFormPrompt(FormPromptTypeID, DistrictCode, EvaluationTypeID, SchoolYear, Prompt) VALUES(3, '', 2, 2015, 'TR: Goal Review Prompt 1?')

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


