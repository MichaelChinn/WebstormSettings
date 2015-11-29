if exists (select * from sysobjects 
where id = object_id('dbo.JoinLearningWalkPracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc JoinLearningWalkPracticeSession.'
      drop procedure dbo.JoinLearningWalkPracticeSession
   END
GO
PRINT '.. Creating sproc JoinLearningWalkPracticeSession.'
GO
CREATE PROCEDURE JoinLearningWalkPracticeSession
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
    
DECLARE @EvalSessionID BIGINT
SELECT @EvalSessionID = AnchorSessionID
  FROM dbo.SEPracticeSession
 WHERE PracticeSessionID=@pPracticeSessionID

IF NOT EXISTS (SELECT UserID 
                 FROM dbo.SEPracticeSessionParticipant
                WHERE PracticeSessionID=@pPracticeSessionID
                  AND UserID=@pUserID)
BEGIN
   
INSERT dbo.SEPracticeSessionParticipant(UserID, PracticeSessionID, EvalSessionID)
SELECT @pUserID
	  ,@pPracticeSessionID
	  ,@EvalSessionID
	  
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert SEPracticeSessionParticipant  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

SELECT *
  FROM dbo.vEvalSession
 WHERE EvalSessionID=@EvalSessionID

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


