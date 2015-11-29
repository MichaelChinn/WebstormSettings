if exists (select * from sysobjects 
where id = object_id('dbo.AddBitstreamToRepositoryItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddBitstreamToRepositoryItem.'
      drop procedure dbo.AddBitstreamToRepositoryItem
   END
GO
PRINT '.. Creating sproc AddBitstreamToRepositoryItem.'
GO
CREATE PROCEDURE AddBitstreamToRepositoryItem
		@pRepositoryItemId bigint
		,@pContentType varchar(250)
		,@pBitstream image = NULL
		,@pURL varchar(500) = NULL
		,@pName varchar(2000)
		,@pExt varchar (20)
		,@pDescription text
		,@pSize bigint = 0
		,@pIsPrimaryBitstream bit
		,@pOldRepoPath varchar(1024) = ''
		,@pOwnerId bigint
		,@pSuppressOutput bit = 0

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)
       ,@bundle_id					BIGINT

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
	if not exists (
		select RepositoryItemID 
		  from dbo.RepositoryItem 
		 where RepositoryItemID = @pRepositoryItemID)
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'Non existant repositoryItem id. '
		  GOTO ErrorHandler
	END

	DECLARE @isImmutable bit
	SELECT @isImmutable=dbo.ItemIsImmutable_fn(@pRepositoryItemId)

	if (@isImmutable = 1)
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'The item has been marked immutable, and cannot be modified. '
		  GOTO ErrorHandler
	END

	SELECT @bundle_id = BundleID
      FROM dbo.Bundle
     WHERE RepositoryItemID=@pRepositoryItemID

	if ((@pContentType='URL') and (@pBitstream is not NULL))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You specified an url, but supplied a bitstream. '
		  GOTO ErrorHandler
	END

	if ((@pContentType='URL') and (@pURL is NULL))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You specified an url, but did not supply one. '
		  GOTO ErrorHandler
	END

	if ((@pContentType='URL') and (@pExt <> ''))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You may not supply an extension with an url type. '
		  GOTO ErrorHandler
	END

	if ((@pContentType<>'URL') and (@pSize = 0))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You specified a file to be uploaded, but no size for the file. '
		  GOTO ErrorHandler
	END
	if ((@pContentType='URL') and (@pSize <> 0))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'An url cannot specify a file size. '
		  GOTO ErrorHandler
	END

	DECLARE @now datetime, @id bigint
	SELECT @NOw=GetDate()

	insert dbo.Bitstream (
		BundleId
		,ContentType
		,Bitstream, URL, [Name],Ext
		,Description,[Size]
		,LastUpload,InitialUpload
		,OldRepoPath
		,OwnerId
	)

	values (
		@bundle_id
		,@pContentType
		,@pBitstream, @pURL, @pName,@pExt
		,@pDescription,@pSize
		,@now, @now
		,@pOldRepoPath
		,@pOwnerId
	)
	select @id = scope_identity()
		,@sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert a new bitstream. '
		  GOTO ErrorHandler
	   END

	if (@pIsPrimaryBitstream=1)
	update dbo.bundle 
	   set PrimaryBitstreamId = @id
	 where bundleId = @bundle_id

	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to update primary bitstreamID. '
		  GOTO ErrorHandler
	   END

	Update dbo.UserRepoContext
	   SET DiskUsage = @pSize + DiskUsage
	 WHERE OwnerID = @pOwnerID

	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Couldn''t update diskUsage. '
		  GOTO ErrorHandler
	   END

	if (@pSuppressOutput=0)
		select * from dbo.vBitstream where BitstreamId = @id

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
			+ '@pRepositoryItemId         : ' + Convert(varchar(20), @pRepositoryItemId          ) + '...' 
			+ '@pContentType      : ' + @pContentType + '...'
			+ '@pName             : ' + @pName                                    + '...'
			+ '@pName             : ' + @pName                                    + '...'
			+ '@pSize             : ' + Convert(varchar(20), @pSize              ) + '...'
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


