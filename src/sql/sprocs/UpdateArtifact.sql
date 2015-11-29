if exists (select * from sysobjects 
where id = object_id('dbo.UpdateArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateArtifact.'
      drop procedure dbo.UpdateArtifact
   END
GO
PRINT '.. Creating sproc UpdateArtifact.'
GO
CREATE PROCEDURE UpdateArtifact
	 @pArtifactID BIGINT
	,@pComments TEXT
	,@pIsPublic BIT
	,@pArtifactTypeID SMALLINT
	,@pContextResponse VARCHAR(MAX) = NULL
	,@pAlignmentResponse VARCHAR(MAX) = NULL
	,@pReflectionResponse VARCHAR(MAX) = NULL
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

IF (@pComments IS NULL)
BEGIN
UPDATE dbo.SEArtifact
   SET IsPublic=@pIsPublic
WHERE ArtifactID=@pArtifactID
END
ELSE
BEGIN
UPDATE dbo.SEArtifact
	SET Comments=@pComments
	   ,IsPublic=@pIsPublic
	   ,ArtifactTypeID=@pArtifactTypeID
	  ,ContextPromptResponse=@pContextResponse
	  ,AlignmentPromptResponse=@pAlignmentResponse
	  ,ReflectionPromptResponse=@pReflectionResponse
WHERE ArtifactID=@pArtifactID
END

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEArtifact  failed. In: ' 
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


