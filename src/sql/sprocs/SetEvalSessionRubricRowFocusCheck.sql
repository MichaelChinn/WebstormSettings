if exists (select * from sysobjects 
where id = object_id('dbo.SetEvalSessionRubricRowFocusCheck') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvalSessionRubricRowFocusCheck..'
      drop procedure dbo.SetEvalSessionRubricRowFocusCheck
   END
GO
PRINT '.. Creating sproc SetEvalSessionRubricRowFocusCheck..'
GO
CREATE PROCEDURE SetEvalSessionRubricRowFocusCheck
	 @pEvalSessionID		BIGINT
	,@pRubricRowID			BIGINT
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

IF (@pIsChecked = 0)
BEGIN
	DELETE dbo.SEEvalSessionRubricRowFocus
	 WHERE RubricRowID=@pRubricRowID
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
END
ELSE
BEGIN
IF (@pIsChecked = 1 AND
   NOT EXISTS (SELECT RubricRowID 
				 FROM dbo.SEEvalSessionRubricRowFocus
				WHERE RubricRowID=@pRubricRowID
				  AND EvalSessionID=@pEvalSessionID
				  AND EvaluationRoleTypeID=@pEvalRoleTypeID))
BEGIN
	INSERT dbo.SEEvalSessionRubricRowFocus(EvalSessionID, RubricRowID, EvaluationRoleTypeID)
	VALUES (@pEvalSessionID, @pRubricRowID, @pEvalRoleTypeID)
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert  SEEvalSessionRubricRowFocus failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
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


