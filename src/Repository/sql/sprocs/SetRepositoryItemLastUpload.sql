GO
IF OBJECT_ID ('dbo.SetRepositoryItemLastUpload') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc SetRepositoryItemLastUpload.'
      DROP PROCEDURE dbo.SetRepositoryItemLastUpload
   END
GO
PRINT '.. Creating sproc SetRepositoryItemLastUpload.'
GO
CREATE PROCEDURE dbo.SetRepositoryItemLastUpload
(
	@pItemId		BIGINT
)

AS

SET NOCOUNT ON 
---------------
-- VARIABLES --
---------------
DECLARE @sql_error                   INT
       ,@ProcName                    SYSNAME
       ,@tran_count                  INT
        ,@sql_error_message	     VARCHAR(250)
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

UPDATE RepositoryItem
   SET LastUpload = getdate() 
 WHERE RepositoryItemId = @pItemId

SELECT @sql_error = @@Error
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Update Repository Item Failed: ' + @ProcName + '. ' + ISNULL('>>>' + @sql_error_message, '')
	GOTO ErrorHandler
END

-------------------
-- Handle errors --
-------------------

ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + 
      	  '-- ItemId = ' + convert(varchar(20), ISNULL(@pItemId, '')) + 
          '.  In: ' + @ProcName + '. ' 
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

RETURN(@sql_error)

GO
