if exists (select * from sysobjects 
where id = object_id('dbo.AssignPromptDefaultToUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AssignPromptDefaultToUser.'
      drop procedure dbo.AssignPromptDefaultToUser
   END
GO
PRINT '.. Creating sproc AssignPromptDefaultToUser.'
GO
CREATE PROCEDURE AssignPromptDefaultToUser
	 @pUserID BIGINT
	 ,@pPromptID BIGINT
	 ,@pPromptTypeID SMALLINT
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
			     FROM dbo.SEUserPromptConferenceDefault
			    WHERE EvaluateeID=@pUserID
			      AND UserPromptID=@pPromptID
			      AND UserPromptTypeID=@pPromptTypeID
			      AND DistrictCode=@pDistrictCode)
BEGIN

INSERT dbo.SEUserPromptConferenceDefault(UserPromptID, EvaluateeID, UserPromptTypeID, DistrictCode) 
VALUES(@pPromptID, @pUserID, @pPromptTypeID, @pDistrictCode)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEUserPromptConferenceDefault  failed. In: ' 
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


