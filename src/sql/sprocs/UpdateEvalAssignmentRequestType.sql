if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvalAssignmentRequestType') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvalAssignmentRequestType.'
      drop procedure dbo.UpdateEvalAssignmentRequestType
   END
GO
PRINT '.. Creating sproc UpdateEvalAssignmentRequestType.'
GO
CREATE PROCEDURE UpdateEvalAssignmentRequestType
	 @pEvaluateeUserID BIGINT
	,@pEvaluatorUserID BIGINT
	,@pRequestType SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
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

-- If the status/requesttype changes to accepted/assigned-evaluator we need to check
-- for any other requests for this teacher that were already
-- accepted/assigned-evalator and change their eval type to observations only

IF (@pRequestType=2) -- ASSIGNED EVALUATOR
BEGIN

UPDATE dbo.SEEvalAssignmentRequest
   SET RequestTypeID=1 -- OBS ONLY
 WHERE EvaluateeID=@pEvaluateeUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND Status=2 -- ACCEPTED
   AND EvaluatorID<>@pEvaluatorUserID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalAssignmentRequest  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

UPDATE dbo.SEEvaluation
   SET EvaluatorID=@pEvaluatorUserID
 WHERE EvaluateeID=@pEvaluateeUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END
ELSE -- OBSERVE_ONLY
BEGIN

	-- if switching to observe_only then remove user as the assigned evaluator
	UPDATE dbo.SEEvaluation
	   SET EvaluatorID=NULL
	 WHERE EvaluateeID=@pEvaluateeUserID
	   AND SchoolYear=@pSchoolYear
	   AND DistrictCode=@pDistrictCode
	   AND EvaluatorID=@pEvaluatorUserID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

END

UPDATE dbo.SEEvalAssignmentRequest
   SET RequestTypeID=@pRequestType
 WHERE EvaluateeID=@pEvaluateeUserID
   AND EvaluatorID=@pEvaluatorUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvalAssignmentRequest  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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


