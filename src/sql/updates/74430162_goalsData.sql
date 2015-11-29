
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 74430162
, @title = 'Goals Data 2014-2015'
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

INSERT SEReportPrintOptionType(Name) VALUES('STUDENT_GROWTH_GLOBAL')

/************** STUDENT_GROWTH_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Process', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Results', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Feedback', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Statement Rubric', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Results Rubric', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(13, 'Include Artifacts', NULL)

INSERT SEReportPrintOptionType(Name) VALUES('PROF_DEV_GLOBAL')

/************** STUDENT_GROWTH_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(14, 'Include Process', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(14, 'Include Results', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(14, 'Include Feedback', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(14, 'Include Artifacts', NULL)

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
INSERT SEUserPrompt(SchoolYear, PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (2015, 6, 'GoalTemplateGoalNotes', 'Notes', '', '', 2, 1, @theDate, 0, 1, 0)
INSERT SEUserPrompt(SchoolYear, PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID, Published, PublishedDate, Retired, EvaluationTypeID, Private)
VALUES (2015, 6, 'GoalTemplateGoalNotes', 'Notes', '', '', 2, 1, @theDate, 0, 2, 0)

DECLARE @ID BIGINT

INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Student Growth Goal Template', 2015, 1)
SELECT @ID = SCOPE_IDENTITY()

-- SG 3.5 
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2015 SG 3.5', 'SG 3.5', 2015, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2015 SG 3.5', 'SG 3.5', 2015, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2015 SG 3.5', 'SG 3.5', 2015, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2015 SG 3.5', 'SG 3.5', 2015, 1, 4)

-- SG 5.5
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q5 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q6 PR 2015 SG 5.5', 'SG 5.5', 2015, 1, 6)

-- SG 8.3
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2015 SG 8.3', 'SG 8.3', 2015, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2015 SG 8.3', 'SG 8.3', 2015, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2015 SG 8.3', 'SG 8.3', 2015, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2015 SG 8.3', 'SG 8.3', 2015, 1, 4)


INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Student Growth Goal Template', 2015, 2)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 TR 2015', '', 2015, 2, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 TR 2015', '', 2015, 2, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 TR 2015', '', 2015, 2, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 TR 2015', '', 2015, 2, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q5 TR 2015', '', 2015, 2, 5)


INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Professional Growth Goal Template', 2015, 1)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q1 PR 2015', '', 2015, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q2 PR 2015', '', 2015, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q3 PR 2015', '', 2015, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q4 PR 2015', '', 2015, 1, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q5 PR 2015', '', 2015, 1, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q6 PR 2015', '', 2015, 1, 6)

INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Professional Growth Goal Template', 2015, 2)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q1 TR 2015', '', 2015, 2, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q2 TR 2015', '', 2015, 2, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q3 TR 2015', '', 2015, 2, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q4 TR 2015', '', 2015, 2, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q5 TR 2015', '', 2015, 2, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q6 TR 2015', '', 2015, 2, 6)

INSERT SEArtifactType(Name)VALUES('Linked to Goal')

SELECT * FROM messagetype
-- UG: Goals Dashboard
INSERT dbo.MessageType(MessageTypeID, Name, Description) VALUES(21, 'UG: Goals Dashboard Notification', 'User-generated notification from goals dashboard')
INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(21, 'SETeacherEvaluator')
INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(21, 'SEPrincipalEvaluator')
INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(21, 'SESchoolPrincipal')
INSERT MessageTypeRole(MessageTypeID, RoleName) VALUES(21, 'SESchoolTeacher')

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


