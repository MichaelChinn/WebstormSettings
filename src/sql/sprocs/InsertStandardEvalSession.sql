if exists (select * from sysobjects 
where id = object_id('dbo.InsertStandardEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertStandardEvalSession.'
      drop procedure dbo.InsertStandardEvalSession
   END
GO
PRINT '.. Creating sproc InsertStandardEvalSession.'
GO
CREATE PROCEDURE InsertStandardEvalSession
	 @pEvaluateeUserID BIGINT
	,@pSchoolCode VARCHAR(20)
	,@pDistrictCode VARCHAR(20)
	,@pEvaluatorUserID BIGINT
	,@pTitle VARCHAR(50)
	,@pEvaluationTypeID SMALLINT
	,@pEvaluationScoreTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pFocused BIT
	,@pisFormalObs BIT
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

DECLARE @FocusFrameworkNodeID BIGINT, @FocusSGFrameworkNodeID BIGINT, @IsFocused BIT, @EvaluateePlanTypeID SMALLINT
SELECT @FocusFrameworkNodeID=FocusedFrameworkNodeID
      ,@FocusSGFrameworkNodeID=FocusedSGFrameworkNodeID
      ,@EvaluateePlanTypeID=EvaluateePlanTypeID
  FROM dbo.SEEvaluation 
 WHERE EvaluateeID=@pEvaluateeUserID
   AND DistrictCode=@pDistrictCode
   AND SchoolYear=@pSchoolYear

IF (@EvaluateePlanTypeID=2 AND @pSchoolYear > 2013)
BEGIN
	SELECT @IsFocused = @pFocused
END
ELSE
BEGIN
	SELECT @IsFocused = 0
END

DECLARE @Id BIGINT
INSERT dbo.SEEvalSession(SchoolCode, DistrictCode, EvaluatorUserID, EvaluateeUserID, EvaluationTypeID, Title, 
				EvaluationScoreTypeID, AnchorTypeID, SchoolYear, IsFocused, FocusedFrameworkNodeID, FocusedSGFrameworkNodeID, SessionKey, isFormalObs)
VALUES (@pSchoolCode, @pDistrictCode, @pEvaluatorUserID, @pEvaluateeUserID, @pEvaluationTypeID, @pTitle,
				@pEvaluationScoreTypeID, NULL, @pSchoolYear, @IsFocused, @FocusFrameworkNodeID, @FocusSGFrameworkNodeID, '', @pisFormalObs)
SELECT @sql_error = @@ERROR, @Id = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DECLARE @Index SMALLINT
SELECT @Index = ROW_NUMBER() OVER (PARTITION BY s.SchoolYear, s.EvaluateeUserID ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID)
  FROM SEEvalSession s
 WHERE s.EvaluateeUserID=@pEvaluateeUserID
   AND s.EvaluationScoreTypeID = 1
   AND s.IsSelfAssess=0
 ORDER BY s.SchoolYear, s.EvaluateeUserID, s.EvalSessionID
 
UPDATE dbo.SEEvalSession 
   SET SessionKey=@Index
 WHERE EvalSessionID=@ID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF (@IsFocused = 1)
BEGIN	
	
	INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
	SELECT @Id
		  ,rrfn.RubricRowID
		  ,1
	  FROM dbo.SEFrameworkNode fn 
	  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
	 WHERE fn.FrameworkNodeID=@FocusFrameworkNodeID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert  SEEvalSessionRubricRowFocus failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
	
	-- if the focus criteria doesn't include any student growth elements then include the
	-- student growth rubric rows
	IF (@FocusSGFrameworkNodeID <> @FocusFrameworkNodeID)
	BEGIN
		INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
		SELECT @Id
			  ,rr.RubricRowID
			  ,1
		  FROM dbo.SEFrameworkNode fn 
		  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
		  JOIN dbo.SERubricRow rr ON rrfn.RubricRowID=rr.RubricRowID
		 WHERE fn.FrameworkNodeID=@FocusSGFrameworkNodeID
		   AND rr.IsStudentGrowthAligned=1
		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not insert  SEEvalSessionRubricRowFocus failed. In: ' 
				+ @ProcName
				+ ' >>>' + ISNULL(@sql_error_message, '')
			GOTO ErrorHandler
		END
	END
	
END

DECLARE @UserPromptID BIGINT

-- Create Pre-Conf notes
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='PreConfNotes'
   AND EvaluationTypeID=@pEvaluationTypeID
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pEvaluateeUserID, @Id, @pSchoolYear, @pDistrictCode)

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Create Post-Conf notes
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='PostConfNotes'
   AND EvaluationTypeID=@pEvaluationTypeID

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pEvaluateeUserID, @Id, @pSchoolYear, @pDistrictCode)

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


-- Insert default conference userprompts
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
SELECT d.UserPromptID
	  ,d.EvaluateeID
	  ,@Id
	  ,@pSchoolYear
	  ,@pDistrictCode
  FROM dbo.vUserPromptConferenceDefault d
 WHERE d.EvaluateeID=@pEvaluateeUserID
   AND d.UserPromptTypeID=1 -- Pre-Conference
   AND d.DistrictCode=@pDistrictCode
   AND d.SchoolYear=@pSchoolYear
  
  INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
SELECT d.UserPromptID
	  ,d.EvaluateeID
	  ,@Id
	  ,@pSchoolYear
	  ,@pDistrictCode
  FROM dbo.vUserPromptConferenceDefault d
 WHERE d.EvaluateeID=@pEvaluateeUserID
   AND d.UserPromptTypeID=2 -- Post-Conference
   AND d.DistrictCode=@pDistrictCode
   AND d.SchoolYear=@pSchoolYear
  	
-- Insert rubric notes

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricNotes'
   AND EvaluationTypeID=@pEvaluationTypeID
      
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pEvaluateeUserID, @Id, @pSchoolYear, @pDistrictCode)

-- Insert rubric recommendations

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricRecommendations'
   AND EvaluationTypeID=@pEvaluationTypeID
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pEvaluateeUserID, @Id, @pSchoolYear, @pDistrictCode)

IF (@pDistrictCode = '17001')
BEGIN
-- Seattle wants all set by default, except not rubrics descriptors
INSERT INTO dbo.SEReportPrintOptionEvalSession(ReportPrintOptionID, EvalSessionID)
SELECT o.ReportPrintOptionID, @Id
  FROM dbo.SEReportPrintOption o
  JOIN dbo.SEReportPrintOptionType t ON o.ReportPrintOptionTypeID=t.ReportPrintOptionTypeID
 WHERE t.ReportPrintOptionTypeID=8 -- OBSERVATION_OBSERVATION
   AND o.ReportPrintOptionID<> 81 -- rubric descriptors
   
END

SELECT ID=@Id

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


