if exists (select * from sysobjects 
where id = object_id('dbo.RemoveArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RemoveArtifact.'
      drop procedure dbo.RemoveArtifact
   END
GO
PRINT '.. Creating sproc RemoveArtifact.'
GO
CREATE PROCEDURE RemoveArtifact
	 @pArtifactID BIGINT
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

DELETE dbo.SEArtifactRubricRowAlignment
 WHERE ArtifactID=@pArtifactID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEArtifactRubricRowAlignment  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Remove Notes
DELETE dbo.SEUserPromptResponseEntry
 WHERE UserPromptResponseID IN (SELECT UserPromptResponseID
							   FROM dbo.SEUserPromptResponse	
							  WHERE ArtifactID=@pArtifactID)
 SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponseEntry  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEUserPromptResponse
 WHERE ArtifactID=@pArtifactID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEArtifact
 WHERE ArtifactID=@pArtifactID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEArtifact  failed. In: ' 
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


