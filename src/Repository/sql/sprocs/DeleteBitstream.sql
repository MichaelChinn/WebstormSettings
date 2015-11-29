if exists (select * from sysobjects 
where id = object_id('dbo.DeleteBitstream') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteBitstream.'
      drop procedure dbo.DeleteBitstream
   END
GO
PRINT '.. Creating sproc DeleteBitstream.'
GO
CREATE PROCEDURE DeleteBitstream
		@pBitstreamId bigint
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

UPDATE dbo.Bundle SET PrimaryBitstreamID=NULL WHERE PrimaryBitstreamID=@pBitstreamID
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to update Bundle.PrimaryBitstreamID. '
	  GOTO ErrorHandler
   END

DECLARE @isImmutable bit, @repoItemId bigint
SELECT @repoItemId = ri.RepositoryItemID
  FROM dbo.RepositoryItem ri
  JOIN dbo.Bundle b on b.RepositoryItemId = ri.RepositoryItemId
  JOIN dbo.Bitstream bs on bs.bundleId = b.bundleId
 WHERE bs.BitstreamId = @pBitstreamID

if (dbo.ItemIsImmutable_fn(@repoItemId) = 1)
BEGIN
      SELECT @sql_error = -1
	  SELECT @sql_error_message = 'The item has been marked immutable, and cannot be modified. '
	  GOTO ErrorHandler
END

DECLARE @size BIGINT, @ownerId BIGINT
SELECT @size = [size]
		,@ownerId = ownerId
  FROM dbo.Bitstream
 WHERE BitstreamID = @pBitstreamID

DELETE dbo.Bitstream WHERE BitstreamID=@pBitstreamId
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to delete bitstream. '
	  GOTO ErrorHandler
   END

UPDATE dbo.UserRepoContext
   SET DiskUsage = DiskUsage - @size
 WHERE OwnerID = @ownerID

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


