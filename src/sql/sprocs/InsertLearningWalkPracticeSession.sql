if exists (select * from sysobjects 
where id = object_id('dbo.InsertLearningWalkPracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertLearningWalkPracticeSession.'
      drop procedure dbo.InsertLearningWalkPracticeSession
   END
GO
PRINT '.. Creating sproc InsertLearningWalkPracticeSession.'
GO
CREATE PROCEDURE InsertLearningWalkPracticeSession
	 @pCreatedByUserID BIGINT
	,@pTitle VARCHAR(120)
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT 
	,@pIsPrivate BIT
	,@pNumClassrooms INT
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

DECLARE @Random3Digit SMALLINT
SELECT @Random3Digit = (convert(numeric(3,0),rand() * 899) + 100)

INSERT dbo.SEPracticeSession(CreatedByUserID, DistrictCode, CreationDateTime, Title, LockStateID, PracticeSessionTypeID, TrainingProtocolID, SchoolYear, EvaluateeUserID, IsPrivate, RandomDigits)
VALUES(@pCreatedByUserID, @pDistrictCode, @theDate, @pTitle, 1, 3, NULL, @pSchoolYear, NULL, @pIsPrivate, @Random3Digit)
SELECT @sql_error = @@ERROR, @PracticeSessionID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert into SEPracticeSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Create the first participant session for the owner

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
	EvalSessionLockStateID)
SELECT 
	@pSchoolCode, 
	@pDistrictCode, 
	@pCreatedByUserID, 
	NULL,
	2, -- teacher observation
	@pTitle, 
	3, -- drift detect
	1, -- live
	NULL,
	@pSchoolYear,
	1,
	1 -- unlocked
SELECT @sql_error = @@ERROR, @SessionID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert anchor session into SEEvalSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

INSERT dbo.SEPracticeSessionParticipant(UserID, PracticeSessionID, EvalSessionID)
VALUES(@pCreatedByUserID, @PracticeSessionID, @SessionID)

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert SEPracticeSessionParticipant  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

UPDATE dbo.SEPracticeSession
   SET AnchorSessionID=@SessionID
 WHERE PracticeSessionID=@PracticeSessionID
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEPracticeSession  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DECLARE @i int = 1
WHILE (@i <= @pNumClassrooms)
BEGIN
    INSERT dbo.SELearningWalkClassRoom(PracticeSessionID, Name) VALUES(@PracticeSessionID, 'Room #' + CONVERT(VARCHAR, @i))
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SELearningWalkClassRoom  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
	
    SET @i = @i + 1
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


