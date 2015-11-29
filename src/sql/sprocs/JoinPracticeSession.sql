if exists (select * from sysobjects 
where id = object_id('dbo.JoinPracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc JoinPracticeSession.'
      drop procedure dbo.JoinPracticeSession
   END
GO
PRINT '.. Creating sproc JoinPracticeSession.'
GO
CREATE PROCEDURE JoinPracticeSession
	 @pPracticeSessionID BIGINT
	,@pUserID BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
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

DECLARE @PracticeSessionID BIGINT
DECLARE @SessionID BIGINT
SELECT @SessionID =
(SELECT EvalSessionID
   FROM dbo.SEPracticeSessionParticipant
  WHERE PracticeSessionID=@pPracticeSessionID
    AND UserID=@pUserID)
    
IF (@SessionID IS NOT NULL)
BEGIN
	SELECT * FROM vEvalSession WHERE EvalSessionID=@SessionID
END
ELSE
BEGIN

DECLARE @Title VARCHAR(200)
DECLARE @SchoolYear SMALLINT
DECLARE @TrainingProtocolID BIGINT
DECLARE @LockState SMALLINT
DECLARE @EvaluateeUserID BIGINT
DECLARE @AnchorType SMALLINT
SELECT @SchoolYear=SchoolYear, 
		@TrainingProtocolID=TrainingProtocolID, 
		@Title=Title,
		@LockState=LockStateID,
		@EvaluateeUserID=EvaluateeUserID,
		@AnchorType=CASE WHEN(PracticeSessionTypeID = 1) THEN 1 ELSE 2 END
  FROM dbo.SEPracticeSession
 WHERE PracticeSessionID=@pPracticeSessionID


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
	EvalSessionLockStateID)
SELECT 
	@pSchoolCode, 
	@pDistrictCode, 
	@pUserID, 
	@pUserID,
	2, 
	@Title, 
	3, 
	@AnchorType,
	@TrainingProtocolID,
	@SchoolYear,
	1,
	@LockState
SELECT @sql_error = @@ERROR, @SessionID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert anchor session into SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEPracticeSessionParticipant(UserID, PracticeSessionID, EvalSessionID)
SELECT @pUserID
	  ,@pPracticeSessionID
	  ,@SessionID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert SEPracticeSessionParticipant  failed. In: ' 
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
VALUES (@UserPromptID, @pUserID, @SessionID, @SchoolYear, @pDistrictCode)

-- Insert rubric recommendations

SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='RubricRecommendations'
   AND EvaluationTypeID=2
   
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @pUserID, @SessionId, @SchoolYear, @pDistrictCode)  

END
   
SELECT *
  FROM dbo.vEvalSession
 WHERE EvalSessionID=@SessionID


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


