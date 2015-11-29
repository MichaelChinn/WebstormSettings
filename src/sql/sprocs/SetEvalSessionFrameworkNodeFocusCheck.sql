if exists (select * from sysobjects 
where id = object_id('dbo.SetEvalSessionFrameworkNodeFocusCheck') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvalSessionFrameworkNodeFocusCheck..'
      drop procedure dbo.SetEvalSessionFrameworkNodeFocusCheck
   END
GO
PRINT '.. Creating sproc SetEvalSessionFrameworkNodeFocusCheck..'
GO
CREATE PROCEDURE SetEvalSessionFrameworkNodeFocusCheck
	 @pEvalSessionID		BIGINT
	,@pFrameworkNodeID		BIGINT
	,@pEvalRoleTypeID		SMALLINT
	,@pIsChecked			BIT
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

-- Delete any for this frameworknode and if they are checked add them all back in
DELETE dbo.SEEvalSessionRubricRowFocus
  FROM dbo.SEEvalSessionRubricRowFocus rrf
  JOIN dbo.SERubricRowFrameworkNode rrfn 
    ON rrf.RubricRowID=rrfn.RubricRowID 	  
 WHERE rrfn.FrameworkNodeID=@pFrameworkNodeID
  AND EvalSessionID=@pEvalSessionID
  AND EvaluationRoleTypeID=@pEvalRoleTypeID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete  SEEvalSessionRubricRowFocus failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF (@pIsChecked = 1)
BEGIN
	INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
	SELECT @pEvalSessionID
		  ,rrfn.RubricRowID
		  ,@pEvalRoleTypeID
	  FROM dbo.SERubricRowFrameworkNode rrfn 
	 WHERE rrfn.FrameworkNodeID=@pFrameworkNodeID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert  SEEvalSessionRubricRowFocus failed. In: ' 
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


