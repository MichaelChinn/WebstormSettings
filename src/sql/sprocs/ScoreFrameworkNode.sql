if exists (select * from sysobjects 
where id = object_id('dbo.ScoreFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ScoreFrameworkNode..'
      drop procedure dbo.ScoreFrameworkNode
   END
GO
PRINT '.. Creating sproc ScoreFrameworkNode..'
GO
CREATE PROCEDURE ScoreFrameworkNode
	 @pEvalSessionID		BIGINT
	,@pFrameworkNodeID		BIGINT
	,@pPerformanceLevelID	SMALLINT
	,@pSEUserID			BIGINT
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

DECLARE @IsFocused BIT
SELECT @IsFocused = IsFocused FROM dbo.SEEvalSession WHERE EvalSessionID=@pEvalSessionID

IF EXISTS (SELECT FrameworkNodeID 
		     FROM dbo.SEFrameworkNodeScore
			WHERE FrameworkNodeID=@pFrameworkNodeID
			  AND EvalSessionID=@pEvalSessionID)
BEGIN
	UPDATE dbo.SEFrameworkNodeScore
	   SET PerformanceLevelID=@pPerformanceLevelID
	      ,SEUserID=@pSEUserID
	WHERE FrameworkNodeID=@pFrameworkNodeID
      AND EvalSessionID=@pEvalSessionID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SEFrameworkNodeScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SEFrameworkNodeScore(EvalSessionID, FrameworkNodeID, PerformanceLevelID, SEUserID)
	VALUES(@pEvalSessionID, @pFrameworkNodeID, @pPerformanceLevelID, @pSEUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SEFrameworkNodeScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END

IF (@IsFocused=1)
BEGIN
	UPDATE dbo.SEEvalSession 
	   SET PerformanceLevelID=@pPerformanceLevelID
	 WHERE EvalSessionID=@pEvalSessionID
END
	
IF EXISTS 
(SELECT fns.PerformanceLevelID
  FROM dbo.SEFrameworkNodeScore fns
  JOIN dbo.SEFrameworkNode fn on fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f on fn.FrameworkID=f.FrameworkID
 WHERE EvalSessionID=@pEvalSessionID
   AND fns.PerformanceLevelID IS NOT NULL
   AND f.FrameworkTypeID IN (1,3) -- state
   )
BEGIN

SELECT 'Raw Score: ' + CONVERT(VARCHAR, SUM(fns.PerformanceLevelID)) + '/' + CONVERT(VARCHAR, COUNT(fns.PerformanceLevelID)*4)
  FROM dbo.SEFrameworkNodeScore fns
  JOIN dbo.SEFrameworkNode fn on fns.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f on fn.FrameworkID=f.FrameworkID
 WHERE EvalSessionID=@pEvalSessionID
   AND fns.PerformanceLevelID IS NOT NULL
   AND f.FrameworkTypeID IN (1,3) -- state
      
END
ELSE
BEGIN
	SELECT 'Raw Score: ' + '0/0'
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


