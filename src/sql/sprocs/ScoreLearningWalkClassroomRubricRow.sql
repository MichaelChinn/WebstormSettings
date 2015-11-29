if exists (select * from sysobjects 
where id = object_id('dbo.ScoreLearningWalkClassroomRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ScoreLearningWalkClassroomRubricRow..'
      drop procedure dbo.ScoreLearningWalkClassroomRubricRow
   END
GO
PRINT '.. Creating sproc ScoreLearningWalkClassroomRubricRow..'
GO
CREATE PROCEDURE ScoreLearningWalkClassroomRubricRow
	 @pLearningWalkClassroomID		BIGINT
	,@pRubricRowID					BIGINT
	,@pPerformanceLevelID			SMALLINT
	,@pSEUserID						BIGINT
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
 
 DECLARE @SessionID BIGINT

SELECT @SessionID = ps.AnchorSessionID
  FROM dbo.SELearningWalkClassroom c
  JOIN dbo.SEPracticeSession ps ON c.PracticeSessionID=ps.PracticeSessionID
 WHERE c.LearningWalkClassroomID=@pLearningWalkClassroomID
 
 
IF EXISTS (SELECT RubricRowID 
		     FROM dbo.SERubricRowScore
			WHERE RubricRowID=@pRubricRowID
			  AND EvalSessionID=@SessionID
			  AND LearningWalkClassroomID=@pLearningWalkClassroomID
			  AND SEUserID=@pSEUserID)
BEGIN
	UPDATE dbo.SERubricRowScore
	   SET PerformanceLevelID=@pPerformanceLevelID
	WHERE RubricRowID=@pRubricRowID
	  AND EvalSessionID=@SessionID
      AND LearningWalkClassroomID=@pLearningWalkClassroomID
      AND SEUserID=@pSEUserID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SERubricRowScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SERubricRowScore(LearningWalkClassroomID, EvalSessionID, RubricRowID, PerformanceLevelID, SEUserID)
	VALUES(@pLearningWalkClassroomID, @SessionID, @pRubricRowID, @pPerformanceLevelID, @pSEUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SERubricRowScore  failed. In: ' 
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


