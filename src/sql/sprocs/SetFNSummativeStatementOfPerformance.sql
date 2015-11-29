if exists (select * from sysobjects 
where id = object_id('dbo.SetFNSummativeStatementOfPerformance') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetFNSummativeStatementOfPerformance..'
      drop procedure dbo.SetFNSummativeStatementOfPerformance
   END
GO
PRINT '.. Creating sproc SetFNSummativeStatementOfPerformance..'
GO
CREATE PROCEDURE SetFNSummativeStatementOfPerformance
	 @pEvaluateeID		BIGINT
	,@pUserID			BIGINT
	,@pFrameworkNodeID		BIGINT
	,@pStatement VARCHAR(MAX)
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

IF EXISTS (SELECT FrameworkNodeID 
		     FROM dbo.SESummativeFrameworkNodeScore
			WHERE FrameworkNodeID=@pFrameworkNodeID
			  AND EvaluateeID=@pEvaluateeID)
BEGIN
	UPDATE dbo.SESummativeFrameworkNodeScore
	   SET StatementOfPerformance=@pStatement
	      ,SEUserID=@pUserID
	WHERE FrameworkNodeID=@pFrameworkNodeID
      AND EvaluateeID=@pEvaluateeID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SESummativeFrameworkNodeScore  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN
	INSERT dbo.SESummativeFrameworkNodeScore(EvaluateeID, FrameworkNodeID, PerformanceLevelID, StatementOfPerformance, SEUserID)
	VALUES(@pEvaluateeID, @pFrameworkNodeID, NULL, @pStatement, @pUserID)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert SESummativeFrameworkNodeScore  failed. In: ' 
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


