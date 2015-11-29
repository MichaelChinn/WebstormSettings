if exists (select * from sysobjects 
where id = object_id('dbo.ScoreSummativeRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ScoreSummativeRubricRow..'
      drop procedure dbo.ScoreSummativeRubricRow
   END
GO
PRINT '.. Creating sproc ScoreSummativeRubricRow..'
GO
CREATE PROCEDURE ScoreSummativeRubricRow
	 @pEvaluateeID		BIGINT
	,@pRubricRowID		BIGINT
	,@pPerformanceLevelID	SMALLINT
	,@pUserID			BIGINT
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
		     FROM dbo.SESummativeRubricRowScore
			WHERE RubricRowID=@pRubricRowID
			  AND EvaluateeID=@pEvaluateeID)
BEGIN
	UPDATE dbo.SESummativeRubricRowScore
	   SET PerformanceLevelID=@pPerformanceLevelID
	      ,SEUserID=@pUserID
	WHERE RubricRowID=@pRubricRowID
      AND EvaluateeID=@pEvaluateeID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SESummativeRubricRowScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SESummativeRubricRowScore(EvaluateeID, RubricRowID, PerformanceLevelID, SEUserID)
	VALUES(@pEvaluateeID, @pRubricRowID, @pPerformanceLevelID, @pUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SESummativeRubricRowScore  failed. In: ' 
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


