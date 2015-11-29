
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 34530893
, @title = 'Report Print Config'
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

DECLARE @OptionID BIGINT, @RootOptionID BIGINT, @ObserveOptionID BIGINT, @RubricsOptionID BIGINT

/************** FINAL_OBSERVATION *********************/
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Pre-Conference', NULL)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Pre-Conference Focus/Alignment', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Pre-Conference Notes', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Pre-Conference Prompts', @OptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Observation', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Observation Notes', @ObserveOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Excerpts', @RubricsOptionID)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Prioritized Excerpts', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Excerpts', @OptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Session Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Session Recommendations', @ObserveOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Post-Conference', NULL)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Post-Conference Notes', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(1, 'Post-Conference Prompts', @OptionID)

/************** FINAL_SELFASSESSMENT *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(2, 'Assessment', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(2, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(2, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(2, 'Assessment Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(2, 'Assessment Recommendations', @ObserveOptionID)

/************** FINAL_EVALUATION *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(3, 'Additional Measures', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(3, 'Reflections', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(3, 'Final Notes', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(3, 'Final Recommendations', NULL)

/************** FINAL_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(4, 'Include Instructional', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(4, 'Complete Observations Only', NULL)



/************** DISCREPANCY_OBSERVATION *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Observation', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Observation Notes', @ObserveOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Excerpts', @RubricsOptionID)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Prioritized Excerpts', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Excerpts', @OptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Session Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(5, 'Session Recommendations', @ObserveOptionID)

/************** DISCREPANCY_SELFASSESSMENT *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(6, 'Assessment', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(6, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(6, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(6, 'Assessment Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(6, 'Assessment Recommendations', @ObserveOptionID)

/************** DISCREPANCY_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(7, 'Include State', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(7, 'Include Student Growth', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(7, 'Include Instructional', NULL)


/************** OBSERVATION_OBSERVATION *********************/
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Pre-Conference', NULL)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Pre-Conference Focus/Alignment', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Pre-Conference Notes', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Pre-Conference Prompts', @OptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Observation', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Observation Notes', @ObserveOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Excerpts', @RubricsOptionID)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Prioritized Excerpts', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Excerpts', @OptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Session Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Session Recommendations', @ObserveOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Post-Conference', NULL)
SELECT @OptionID = SCOPE_IDENTITY()
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Post-Conference Notes', @OptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(8, 'Post-Conference Prompts', @OptionID)

/************** OBSERVATION_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(9, 'Include State', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(9, 'Include Student Growth', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(9, 'Include Instructional', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(9, 'Include Focus Only', NULL)


/************** SELFASSESS_ASSESS *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(10, 'Assess', NULL)
SELECT @ObserveOptionID = SCOPE_IDENTITY()

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(10, 'Rubrics', @ObserveOptionID)
SELECT @RubricsOptionID = SCOPE_IDENTITY()

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(10, 'Evidence/Notes', @RubricsOptionID)

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(10, 'Assessment Notes', @ObserveOptionID)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(10, 'Assessment Recommendations', @ObserveOptionID)

/************** SELFASSESS_TOPLEVEL *********************/

INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(11, 'Include State', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(11, 'Include Student Growth', NULL)
INSERT SEReportPrintOption(ReportPrintOptionTypeID, Name, ParentReportOptionID) VALUES(11, 'Include Instructional', NULL)


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


