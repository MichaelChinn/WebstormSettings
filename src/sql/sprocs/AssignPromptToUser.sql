if exists (select * from sysobjects 
where id = object_id('dbo.AssignPromptToUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AssignPromptToUser.'
      drop procedure dbo.AssignPromptToUser
   END
GO
PRINT '.. Creating sproc AssignPromptToUser.'
GO
CREATE PROCEDURE AssignPromptToUser
	 @pUserID BIGINT
	 ,@pPromptID BIGINT
	 ,@pEvalSessionID BIGINT
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

IF NOT EXISTS (SELECT EvaluateeID 
			     FROM dbo.SEUserPromptResponse
			    WHERE EvaluateeID=@pUserID
			      AND UserPromptID=@pPromptID
			      AND SchoolYear=@pSchoolYear
			      AND DistrictCode=@pDistrictCode
			      AND ((@pEvalSessionID IS NULL AND EvalSessionID IS NULL) OR
			          (EvalSessionID=@pEvalSessionID)))
BEGIN

INSERT dbo.SEUserPromptResponse(UserPromptID, EvaluateeID, EvalSessionID, SchoolYear, DistrictCode) 
VALUES(@pPromptID, @pUserID, @pEvalSessionID, @pSchoolYear, @pDistrictCode)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEUserPromptResponse  failed. In: ' 
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


