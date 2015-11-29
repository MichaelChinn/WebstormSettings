
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

select @bugFixed = 94466444
, @title = 'Rollover for 2015-2016'
, @comment = ''


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
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

INSERT dbo.SESchoolYear(SchoolYear, Description, YearRange) VALUES(2016, '2015-2016 School Year', 2015-2016)

DECLARE @ID BIGINT

INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Student Growth Goal Template', 2016, 1)
SELECT @ID = SCOPE_IDENTITY()

-- SG 3.5 
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2016 SG 3.5', 'SG 3.5', 2016, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2016 SG 3.5', 'SG 3.5', 2016, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2016 SG 3.5', 'SG 3.5', 2016, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2016 SG 3.5', 'SG 3.5', 2016, 1, 4)

-- SG 5.5
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q5 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q6 PR 2016 SG 5.5', 'SG 5.5', 2016, 1, 6)

-- SG 8.3
INSERT SEGoalProcessStepType(GoalTemplateTypeID, NAME, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 PR 2016 SG 8.3', 'SG 8.3', 2016, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 PR 2016 SG 8.3', 'SG 8.3', 2016, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 PR 2016 SG 8.3', 'SG 8.3', 2016, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 PR 2016 SG 8.3', 'SG 8.3', 2016, 1, 4)


INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Student Growth Goal Template', 2016, 2)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q1 TR 2016', '', 2016, 2, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q2 TR 2016', '', 2016, 2, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q3 TR 2016', '', 2016, 2, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q4 TR 2016', '', 2016, 2, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'SG Q5 TR 2016', '', 2016, 2, 5)


INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Professional Growth Goal Template', 2016, 1)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q1 PR 2016', '', 2016, 1, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q2 PR 2016', '', 2016, 1, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q3 PR 2016', '', 2016, 1, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q4 PR 2016', '', 2016, 1, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q5 PR 2016', '', 2016, 1, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q6 PR 2016', '', 2016, 1, 6)

INSERT SEGoalTemplateType(Name, SchoolYear, EvaluationTypeID) VALUES('Professional Growth Goal Template', 2016, 2)
SELECT @ID = SCOPE_IDENTITY()

INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q1 TR 2016', '', 2016, 2, 1)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q2 TR 2016', '', 2016, 2, 2)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q3 TR 2016', '', 2016, 2, 3)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q4 TR 2016', '', 2016, 2, 4)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q5 TR 2016', '', 2016, 2, 5)
INSERT SEGoalProcessStepType(GoalTemplateTypeID, Name, RRShortName, SchoolYear, EvaluationTypeID, Sequence) VALUES(@ID, 'PD Q6 TR 2016', '', 2016, 2, 6)



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
