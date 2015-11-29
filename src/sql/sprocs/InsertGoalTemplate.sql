if exists (select * from sysobjects 
where id = object_id('dbo.InsertGoalTemplate') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertGoalTemplate.'
      drop procedure dbo.InsertGoalTemplate
   END
GO
PRINT '.. Creating sproc InsertGoalTemplate.'
GO
CREATE PROCEDURE InsertGoalTemplate
	 @pUserID BIGINT
	 ,@pDistrictCode VARCHAR(20)
	 ,@pGoalTemplateTypeID BIGINT
	 ,@pSchoolYear SMALLINT
	 ,@pEvaluationTypeID SMALLINT
	 ,@pTitle VARCHAR(200)
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

-- Create Evaluation notes
DECLARE @UserPromptID BIGINT

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='GoalTemplateGoalNotes'
   AND EvaluationTypeID=@pEvaluationTypeID

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()
DECLARE @ID BIGINT

INSERT dbo.SEGoalTemplate(UserID, CreationDateTime, Title, DistrictCode, EvaluationTypeID, SchoolYear, GoalTemplateTypeID) 
VALUES(@pUserID, @theDate, @pTitle, @pDistrictCode, @pEvaluationTypeID, @pSchoolYear, @pGoalTemplateTypeID)
SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEGoalTemplate  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DECLARE @RRID BIGINT
DECLARE @GoalTemplateGoalID BIGINT

IF (@pGoalTemplateTypeID IN (2,6)) -- SG_TR_2015, SG_TR_2016
BEGIN

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 8.1'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')
SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
	   @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName = ''
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 6.1'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')
SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
	   @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName = ''

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 3.1'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')

SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
       @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName = ''

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

ELSE IF (@pGoalTemplateTypeID IN (1, 5)) -- SG_PR_2015, SG_PR_2016
BEGIN

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 8.3'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')
SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
	   @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName = 'SG 8.3'
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 5.5'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')
SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
	   @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName='SG 5.5'
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT @RRID = rr.RubricRowID
  FROM dbo.SERubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.SchoolYear=@pSchoolYear
   AND f.EvaluationTypeID=@pEvaluationTypeID
   AND rr.ShortName='SG 3.5'
	
INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, @RRID, '', '', '')

SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
       @RRID,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName='SG 3.5'

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

ELSE IF (@pGoalTemplateTypeID IN (3,4, 7, 8)) -- PD_TR_2015, PD_PR_2015, PD_TR_2016, PD_PR_2016
BEGIN

INSERT dbo.SEGoalTemplateGoal(GoalTemplateID, RubricRowID, GoalStatement, Outcome, Reflection)
VALUES (@ID, NULL, '', '', '')
SELECT @sql_error = @@ERROR, @GoalTemplateGoalID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateGoal  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode, GoalTemplateGoalID)
SELECT @UserPromptID
	  ,@pUserID
	  ,@pSchoolYear
	  ,@pDistrictCode
	  ,@GoalTemplateGoalID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEGoalTemplateProcessStep(
	[GoalTemplateID],
	[RubricRowID],
	[GoalProcessStepTypeID],
	[Response],
	[Sequence])
SELECT @ID,
	   NULL,
	   GoalProcessStepTypeID,
	   '',
	   Sequence
  FROM SEGoalProcessStepType
 WHERE SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
   AND RRShortName=''
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEGoalTemplateProcessStep  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

SELECT ID=@ID

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
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


