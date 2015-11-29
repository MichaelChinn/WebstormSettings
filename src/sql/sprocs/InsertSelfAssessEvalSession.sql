if exists (select * from sysobjects 
where id = object_id('dbo.InsertSelfAssessEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertSelfAssessEvalSession.'
      drop procedure dbo.InsertSelfAssessEvalSession
   END
GO
PRINT '.. Creating sproc InsertSelfAssessEvalSession.'
GO
CREATE PROCEDURE InsertSelfAssessEvalSession
	 @pEvaluateeUserID BIGINT
	,@pSchoolCode VARCHAR(20)
	,@pDistrictCode VARCHAR(20)
	,@pEvaluatorUserID BIGINT
	,@pTitle VARCHAR(50)
	,@pEvaluationTypeID SMALLINT
	,@pEvaluationScoreTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pFocused BIT = 0

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

DECLARE @Id BIGINT
INSERT dbo.SEEvalSession(SchoolCode, DistrictCode, EvaluatorUserID, EvaluateeUserID, EvaluationTypeID, Title, 
				EvaluationScoreTypeID, AnchorTypeID, IsSelfAssess, SchoolYear, IsFocused)
VALUES (@pSchoolCode, @pDistrictCode, @pEvaluatorUserID, @pEvaluatorUserID, @pEvaluationTypeID, @pTitle,
				@pEvaluationScoreTypeID, NULL, 1, @pSchoolYear, @pFocused)
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
IF (@pFocused = 1)
BEGIN

	DECLARE @FocusedFrameworkNodeID BIGINT
	DECLARE @FrameworkNodeShortName VARCHAR(20)
	DECLARE @SGFocusedFrameworkNodeID BIGINT
	
	SELECT @FocusedFrameworkNodeID = e.FocusedFrameworkNodeID
	      ,@FrameworkNodeShortName = fn_focused.ShortName
	      ,@SGFocusedFrameworkNodeID = e.FocusedSGFrameworkNodeID
	  FROM dbo.SEEvaluation e
	  JOIN dbo.SEFrameworkNode fn_focused ON e.FocusedFrameworkNodeID=fn_focused.FrameworkNodeID
	 WHERE e.SchoolYear=@pSchoolYear
	   AND e.DistrictCode=@pDistrictCode
	   AND e.EvaluateeID=@pEvaluateeUserID
	
	UPDATE dbo.SEEvalSession 
	   SET FocusedFrameworkNodeID=@FocusedFrameworkNodeID
	      ,FocusedSGFrameworkNodeID=@SGFocusedFrameworkNodeID
	 WHERE EvalSessionID=@Id
	
	INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
	SELECT @Id
		  ,rrfn.RubricRowID
		  ,1
	  FROM dbo.SEFrameworkNode fn 
	  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
	 WHERE fn.FrameworkNodeID=@FocusedFrameworkNodeID
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
	IF (@SGFocusedFrameworkNodeID <> @FocusedFrameworkNodeID)
	BEGIN
		INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
		SELECT @Id
			  ,rr.RubricRowID
			  ,1
		  FROM dbo.SEFrameworkNode fn 
		  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
		  JOIN dbo.SERubricRow rr ON rrfn.RubricRowID=rr.RubricRowID
		 WHERE fn.FrameworkNodeID=@SGFocusedFrameworkNodeID
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


