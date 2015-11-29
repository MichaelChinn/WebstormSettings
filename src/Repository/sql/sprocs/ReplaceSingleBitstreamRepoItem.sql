if exists (select * from sysobjects 
where id = object_id('dbo.ReplaceSingleBitstreamRepoItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ReplaceSingleBitstreamRepoItem.'
      drop procedure dbo.ReplaceSingleBitstreamRepoItem
   END
GO
PRINT '.. Creating sproc ReplaceSingleBitstreamRepoItem.'
GO
CREATE PROCEDURE ReplaceSingleBitstreamRepoItem
		@pItemId bigint
		,@pUserId bigint
		,@pFileName varchar(512)
        ,@pFileExt  varchar(10)
	    ,@pItemName varchar(1024)
	    ,@pBitstream image = null
		,@pURL varchar (500) = null
		,@pContentType varchar(250)
		,@pDescription varchar(1024) = ''
		,@pKeywords varchar (1024) = ''
		,@pVerifiedByStudent bit = 0
		,@pDebug BIT = 0
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



	DECLARE @size BIGINT, @ParentNodeId bigint
	SELECT @size = DATALENGTH(@pBitstream)
	SELECT @ParentNodeID = @ParentNodeId 
	FROM dbo.RepositoryItem WHERE RepositoryItemID = @pItemId
	
	IF (@pDebug=1)
		SELECT @SIZE, @PARENTNODEID

	/* to url or not to url */
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

	if ((@pContentType='URL') and (@pFileExt <> ''))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You may not supply an extension with an url type. '
		  GOTO ErrorHandler
	END

	if ((@pContentType<>'URL') and (@size = 0))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You specified a file to be uploaded, but no size for the file. '
		  GOTO ErrorHandler
	END
	if ((@pContentType='URL') and (@size <> 0))
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'An url cannot specify a file size. '
		  GOTO ErrorHandler
	END

/* check for name collisions */
DECLARE @isNameCollision BIT
SELECT @isNameCollision = dbo.IsCollision_fn(@ParentNodeId, @pItemName)
IF (@isNameCollision = 1)
BEGIN
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
		GOTO ErrorHandler
	END
END

EXEC dbo.UpdateRepositoryItem @pItemId = @pItemId, -- bigint
    @pItemName = @pItemName -- varchar(512)
    ,@pDescription = @pDescription -- varchar(1024)
    ,@pKeywords = @pKeywords -- varchar(1024)
    ,@pVerifiedByStudent = @pVerifiedByStudent
    ,@pWithdrawnFlag=0
    
SELECT @sql_error = @@error
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to replace RepositoryItem. '
	  GOTO ErrorHandler
   END

DECLARE @bitstreamID BIGINT, @bundleId BIGINT, @now DATETIME, @oldSize bigint
SELECT @bundleId = bun.BundleID, @bitstreamID = bun.PrimaryBitstreamId 
	,@oldSize = bs.Size, @now = GETDATE()
FROM dbo.Bundle bun
JOIN dbo.Bitstream bs ON bs.BitstreamID = bun.PrimaryBitstreamID
WHERE RepositoryItemID = @pItemId



UPDATE dbo.Bitstream 
	SET Bitstream = @pBitstream
	,URL = @pUrl
	,[Name] = @pFileName
	,Ext = @pFileExt
	,DESCRIPTION = @pDescription
	,LastUpload = @now
	,ContentType = @pContentType
	,Size = @size
WHERE BitstreamID = @bitStreamId

SELECT @sql_error = @@error, @bitstreamId = SCOPE_IDENTITY()
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to replace bitstream. '
	  GOTO ErrorHandler
   END

IF (@oldSize IS NULL)
	SELECT @oldSize = 0

IF (@size IS NOT NULL)
BEGIN
	UPDATE dbo.UserRepoContext
	   SET DiskUsage = DiskUsage + -@oldSize + @size
	 WHERE OwnerID = @pUserId

	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to update disk quota. '
		  GOTO ErrorHandler
	   END
END

SELECT * from dbo.vRepositoryItem
where RepositoryItemID = @pItemId

----------------------
-- Handle errors --
----------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '---'
			+ 'ParentNodeID = ' + CONVERT(varchar (20),@ParentNodeID) + ' | '
		    + 'UserID = ' + CONVERT(varchar (20),@pUserId) + ' | '
		    + 'ItemName = ' + @pItemName  + '---'
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


