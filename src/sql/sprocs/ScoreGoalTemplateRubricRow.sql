if exists (select * from sysobjects 
where id = object_id('dbo.ScoreGoalTemplateRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ScoreGoalTemplateRubricRow..'
      drop procedure dbo.ScoreGoalTemplateRubricRow
   END
GO
PRINT '.. Creating sproc ScoreGoalTemplateRubricRow..'
GO
CREATE PROCEDURE ScoreGoalTemplateRubricRow
	 @pGoalTemplateID		BIGINT
	,@pRubricRowID			BIGINT
	,@pPerformanceLevelID	SMALLINT
	,@pUserID				BIGINT
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

IF EXISTS (SELECT RubricRowID 
		     FROM dbo.SEGoalTemplateRubricRowScore
			WHERE RubricRowID=@pRubricRowID
			  AND GoalTemplateID=@pGoalTemplateID)
BEGIN
	UPDATE dbo.SEGoalTemplateRubricRowScore
	   SET PerformanceLevelID=@pPerformanceLevelID
	      ,UserID=@pUserID
	WHERE RubricRowID=@pRubricRowID
      AND GoalTemplateID=@pGoalTemplateID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SEGoalTemplateRubricRowScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SEGoalTemplateRubricRowScore(GoalTemplateID, RubricRowID, PerformanceLevelID, UserID)
	VALUES(@pGoalTemplateID, @pRubricRowID, @pPerformanceLevelID, @pUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SEGoalTemplateRubricRowScore  failed. In: ' 
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


