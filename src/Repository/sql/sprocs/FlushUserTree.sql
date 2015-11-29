if exists (select * from sysobjects 
where id = object_id('dbo.FlushUserTree') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc FlushUserTree.'
      drop procedure dbo.FlushUserTree
   END
GO
PRINT '.. Creating sproc FlushUserTree.'
GO
CREATE PROCEDURE FlushUserTree
	 @pOwnerId bigint
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

/***********************************************************************************/
BEGIN

	IF EXISTS (
		SELECT RepositoryItemID
		  FROM dbo.AppUsageCount
		 WHERE 
			((ReferenceCount >0) OR (ImmutabilityCOunt > 0) )
			AND (
					RepositoryItemId in (
						SELECT RepositoryItemID
						  FROM dbo.RepositoryItem
						 WHERE OwnerId = @pOwnerId
				)
			)
	)
		





	BEGIN
		SELECT @sql_error = 1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'An item in your tree has been marked immutable, and so cannot be recycled.'
			  GOTO ErrorHandler
		   END
	END

	UPDATE dbo.bundle
	   SET PrimaryBitstreamID = null
	 WHERE bundleID in (
		select bundleID from dbo.bundle b
		  JOIN dbo.RepositoryItem ri on ri.RepositoryItemID = b.RepositoryItemID
		 WHERE ri.OwnerId = @pOwnerId
	)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not set primary bitstream null.'
		  GOTO ErrorHandler
	   END


	DELETE dbo.BitStream 
     WHERE ownerID = @pOwnerId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove bitstreams.'
		  GOTO ErrorHandler
	   END

	DELETE dbo.Bundle
	 WHERE bundleID in (
		select bundleID from dbo.bundle b
		  JOIN dbo.RepositoryItem ri on ri.RepositoryItemID = b.RepositoryItemID
		 WHERE ri.OwnerId = @pOwnerID
	)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove bundle.'
		  GOTO ErrorHandler
	   END


	DELETE dbo.RepositoryItem 
	 WHERE OwnerID = @pOwnerID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user files... failed.'
		  GOTO ErrorHandler
	   END

	delete dbo.RepositoryFolder where OwnerID = @pOwnerID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user folders... failed.'
		  GOTO ErrorHandler
	   END

	delete dbo.UserRepoContext where OwnerID = @pOwnerID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user context... failed.'
		  GOTO ErrorHandler
	   END

END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '---'
		    + 'ownerID = ' + CONVERT(varchar (20),@pOwnerId) + '---'
            + 'In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
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


