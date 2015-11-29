if exists (select * from sysobjects 
where id = object_id('dbo.ScoreLWEvalSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ScoreLWEvalSession..'
      drop procedure dbo.ScoreLWEvalSession
   END
GO
PRINT '.. Creating sproc ScoreLWEvalSession..'
GO
CREATE PROCEDURE ScoreLWEvalSession
	 @pEvalSessionID		BIGINT
	,@pPerformanceLevelID	SMALLINT
	,@pClassroomID			BIGINT
	,@pUserID			    BIGINT
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

IF EXISTS (SELECT LearningWalkSessionScoreID 
		     FROM dbo.SELearningWalkSessionScore
			WHERE EvalSessionID=@pEvalSessionID
			  AND ClassroomID=@pClassroomID
			  AND SEUserID=@pUserID)
BEGIN
	UPDATE dbo.SELearningWalkSessionScore
	   SET PerformanceLevelID=@pPerformanceLevelID
	WHERE EvalSessionID=@pEvalSessionID
      AND ClassroomID=@pClassroomID
      AND SEUserID=@pUserID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SELearningWalkSessionScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SELearningWalkSessionScore(ClassroomID, EvalSessionID, PerformanceLevelID, SEUserID)
	VALUES(@pClassroomID, @pEvalSessionID, @pPerformanceLevelID, @pUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SELearningWalkSessionScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END


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


