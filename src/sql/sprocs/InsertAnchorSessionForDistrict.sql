if exists (select * from sysobjects 
where id = object_id('dbo.InsertAnchorSessionForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertAnchorSessionForDistrict.'
      drop procedure dbo.InsertAnchorSessionForDistrict
   END
GO
PRINT '.. Creating sproc InsertAnchorSessionForDistrict.'
GO
CREATE PROCEDURE InsertAnchorSessionForDistrict
	 @pProtocolID BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
	,@pCreatedByUserID BIGINT
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

DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()

DECLARE @SessionID BIGINT

INSERT dbo.SEEvalSession(
	SchoolCode, 
	DistrictCode, 
	EvaluatorUserID, 
	EvaluateeUserID, 
	EvaluationTypeID, 
	Title, 
	EvaluationScoreTypeID, 
	AnchorTypeID,
	TrainingProtocolID,
	SchoolYear,
	ObserveIsPublic,
	ObserveStartTime,
	EvalSessionLockStateID)
SELECT 
	'', 
	@pDistrictCode, 
	@pCreatedByUserID, 
	@pCreatedByUserID,
	2, -- teacher observation
	'Anchor', 
	2, -- anchor
	2, -- video
	@pProtocolID,
	@pSchoolYear,
	1,
	@theDate,
	1 -- unlocked

SELECT @sql_error = @@ERROR, @SessionID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert anchor session into SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Insert rubric notes
DECLARE @UserPromptID BIGINT
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricNotes'
   AND EvaluationTypeID=2
      
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pCreatedByUserID, @SessionID, @pSchoolYear, @pDistrictCode)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert into SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
-- Insert rubric recommendations

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricRecommendations'
   AND EvaluationTypeID=2
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pCreatedByUserID, @SessionId, @pSchoolYear, @pDistrictCode)   
 SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert into SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
  
INSERT SEDistrictTrainingProtocolAnchor(DistrictCode, TrainingProtocolID, EvalSessionID, SchoolYear)
VALUES(@pDistrictCode, @pProtocolID, @SessionID, @pSchoolYear)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert into SEDistrictTrainingProtocolAnchor  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT ID=@SessionID

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


