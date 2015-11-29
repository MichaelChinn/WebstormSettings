if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDropToPaperOverrideComment') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDropToPaperOverrideComment.'
      drop procedure dbo.UpdateDropToPaperOverrideComment
   END
GO
PRINT '.. Creating sproc UpdateDropToPaperOverrideComment.'
GO
CREATE PROCEDURE dbo.UpdateDropToPaperOverrideComment
	@pEvaluationID bigint
    ,@pComment text = ''

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
	   ,@sql_error_message		   VARCHAR(200)
       ,@ProcName                  SYSNAME
       ,@tran_count                INT

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

BEGIN


	UPDATE dbo.SEEvaluation 
       SET DropToPaperOverrideComment=@pComment
          ,DropToPaper=1
	 WHERE EvaluationID = @pEvaluationID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update evaluation state here. '
		GOTO ErrorHandler
	END
END

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
		SELECT @sql_error_message = @sql_error_message +
		'EvaluationId : ' + Convert(varchar(20), @pEvaluationID) + '; ' +
		'In: ' + @ProcName

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


