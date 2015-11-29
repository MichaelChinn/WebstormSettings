GO
IF OBJECT_ID ('dbo.UpdateBundle') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc UpdateBundle.'
      DROP PROCEDURE dbo.UpdateBundle
   END
GO
PRINT '.. Creating sproc UpdateBundle.'
GO
CREATE PROCEDURE dbo.UpdateBundle
(
	@pBundleId		BIGINT
	,@pPrimaryBitstreamID BIGINT
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

IF @tran_count = 0
   BEGIN TRANSACTION

DECLARE @itemId bigint
SELECT @ItemId = RepositoryItemId 
  FROM dbo.Bundle
 WHERE bundleId = @pBundleId

if (dbo.ItemIsImmutable_fn(@ItemId)=1)
BEGIN
      SELECT @sql_error = -1
	  SELECT @sql_error_message = 'Item Immutable; cannot add bundle. '
	  GOTO ErrorHandler
END



UPDATE dbo.Bundle 
   SET
	 PrimaryBitstreamID = @pPrimaryBitStreamID
 WHERE BundleID = @pBundleID


SELECT @sql_error = @@Error
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Update Bundle Failed'
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
      	  '-- bundleId = ' + convert(varchar(20), ISNULL(@pBundleId, '')) + 
	      '-- primaryBitstreamId = ' + convert(varchar(20), ISNULL(@pPrimaryBitstreamID, '')) + 
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

