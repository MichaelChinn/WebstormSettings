if exists (select * from sysobjects 
where id = object_id('dbo.UnassignPromptToUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UnassignPromptToUser.'
      drop procedure dbo.UnassignPromptToUser
   END
GO
PRINT '.. Creating sproc UnassignPromptToUser.'
GO
CREATE PROCEDURE UnassignPromptToUser
	 @pUserID BIGINT
	 ,@pPromptID BIGINT
	 ,@pSchoolYear SMALLINT
	 ,@pDistrictCode VARCHAR(20)
	 ,@pPromptResponseID BIGINT = NULL
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

DECLARE @PromptResponseID BIGINT
-- If it's a goal or reflection prompt then we can get the response
-- from the promptid because they are only assigned one of each prompt at most.
IF (@pPromptResponseID IS NULL)
BEGIN
	SELECT @PromptResponseID=UserPromptResponseID 
	  FROM dbo.SEUserPromptResponse r
	  JOIN dbo.SEUserPrompt p ON r.UserPromptID=p.UserPromptID
	 WHERE r.EvaluateeID=@pUserID
	   AND r.SchoolYear=@pSchoolYear
	   AND r.DistrictCode=@pDistrictCode
	   AND p.UserPromptID=@pPromptID
END
ELSE
BEGIN
	SELECT @PromptResponseID=@pPromptResponseID 
END


DELETE dbo.SEUserPromptResponseEntry
 WHERE UserPromptResponseID=@PromptResponseID
 SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponseEntry  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEUserPromptResponse
 WHERE UserPromptResponseID=@PromptResponseID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponse  failed. In: ' 
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


