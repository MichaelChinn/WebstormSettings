if exists (select * from sysobjects 
where id = object_id('dbo.MoveBitStreamItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc MoveBitStreamItem.'
      drop procedure dbo.MoveBitStreamItem
   END
GO
PRINT '.. Creating sproc MoveBitStreamItem.'
GO
CREATE PROCEDURE MoveBitStreamItem
		 @pBitstreamId bigint
		,@pDestRepositoryItemId bigint
		,@pMakePrimary bit =0
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
	   ,@sql_error_message		= ''
------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

/***********************************************************************************/
BEGIN
	
	if (dbo.ItemIsImmutable_fn(@pDestRepositoryItemId)=1)
		   BEGIN
			  SELECT @sql_error_message = 'Destination item marked immutable, so bitstream could not be moved '
			  GOTO ErrorHandler
		   END

	declare @sourceBundleId bigint
			, @sourceBundlePrimaryBS bigint
			, @sourceItemId bigint
			, @sourceOwnerId bigint
	
	select @sourceBundleId= bundleId
			,@sourceOwnerId = ownerId
	  from dbo.Bitstream 
	 where BitstreamID = @pBitstreamId

	select @sourceBundlePrimaryBs = PrimaryBitstreamId
			, @sourceItemId = repositoryItemID
	  from dbo.Bundle
	 WHERE BundleId = @sourceBundleId

	if (dbo.ItemIsImmutable_fn(@sourceItemId)=1)
   BEGIN
	  SELECT @sql_error_message = 'Source item marked immutable, so bitstream could not be moved '
	  GOTO ErrorHandler
   END

	If not exists(
		select bitstreamId 
		  from dbo.bitstream 
		 where bitstreamId = @pBitstreamId
	)
	BEGIN
	  SELECT @sql_error_message = 'Could not find bitstream requested. '
	  GOTO ErrorHandler
	END

	If not exists(
		select repositoryItemID 
		  from dbo.RepositoryItem 
		 where RepositoryItemID = @pDestRepositoryItemID
	)
	BEGIN
	  SELECT @sql_error_message = 'Could not find destination repositoryItem.  Destination repositoryItem is NULL.'
	  GOTO ErrorHandler
	END
	
	declare @destOwnerId bigint
	select @destOwnerId = ownerId 
 	  from dbo.RepositoryItem where RepositoryItemId = @pDestRepositoryItemId

	if (@destOwnerId <> @sourceOwnerId)
	begin
		   BEGIN
			  SELECT @sql_error_message = 'Cannot move a bitstream to an item not owned by the same person.'
			  GOTO ErrorHandler
		   END
	end

	DECLARE @destBUndleId bigint
	select @destBundleID = bundleId 
	  from dbo.bundle
	 Where repositoryItemID = @pDestRepositoryItemId

	update dbo.Bitstream set BundleID = @destBundleId
	where BitstreamID = @pBitstreamId

	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
			  SELECT @sql_error_message = 'Move item failed. '
			  GOTO ErrorHandler
	   END

	if (@pMakePrimary=1)
	BEGIN
		UPDATE dbo.Bundle
		   SET PrimaryBitstreamId = @pBitstreamId
		 WHERE bundleId = @destBundleId

		select @sql_error = @@error
		IF @sql_error <> 0
		BEGIN
			  SELECT @sql_error_message = 'Could not make bitstream the new primary bitstream in dest bundle. '
			  GOTO ErrorHandler
		END
	END

	--do we need to fixup primary bitstream in old bundle?
	IF (@sourceBundlePrimaryBS=@pBitstreamId)
	BEGIN
		DECLARE @nextBSInSourceBundle bigint
		SELECT @nextBsInSourceBundle = BitstreamId
		  FROM dbo.Bitstream
		 WHERE bundleId = @sourceBundleID

		UPDATE dbo.Bundle
		   SET PrimaryBitstreamId = @nextBSInSourceBundle
		 WHERE BUndleId = @sourceBundleId

		select @sql_error = @@error
		IF @sql_error <> 0
		BEGIN
			  SELECT @sql_error_message = 'Could not set new primary bitstream in source bundle. '
			  GOTO ErrorHandler
		END

	END

	GOTO ProcEnd
end

-------------------
-- Handle errors --
-------------------
ErrorHandler:
   BEGIN
		ROLLBACK TRANSACTION
      
		SELECT @sql_error_message = @sql_error_message + '---'
			+ 'bitstreamid = ' + CONVERT(varchar (20),@pBitstreamId) + ' | '
		    + 'destination item = ' + isnull(CONVERT(varchar (20),@pDestRepositoryItemId),'') + '---'
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



