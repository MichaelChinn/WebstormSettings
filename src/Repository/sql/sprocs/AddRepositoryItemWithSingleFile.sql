if exists (select * from sysobjects 
where id = object_id('dbo.AddRepositoryItemWithSingleFile') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddRepositoryItemWithSingleFile.'
      drop procedure dbo.AddRepositoryItemWithSingleFile
   END
GO
PRINT '.. Creating sproc AddRepositoryItemWithSingleFile.'
GO
CREATE PROCEDURE AddRepositoryItemWithSingleFile
		@pParentNodeID bigint
		,@pUserId bigint
		,@pFileName varchar(512)
        ,@pFileExt  varchar(10)
	    ,@pItemName varchar(1024)
	    ,@pBitstream image = null
		,@pURL varchar (500) = null
		,@pSize bigint = 0
	    ,@pContentType varchar(250) = ''
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

IF @pContentType IS NULL
    SELECT  @pContentType = ImageType
    FROM    dbo.ImageType
    WHERE   extension = @pFileExt

DECLARE @treeOwner BIGINT, @rc INT, @parentFolderName VARCHAR(512)

SELECT @treeOwner = ownerID
	  ,@parentFolderName = FolderName
  FROM dbo.RepositoryFolder 
 WHERE RepositoryFolderID = @pParentNodeID

IF (@treeOwner <> @pUserId)
BEGIN
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'You may not place items in locker that is not owned by you. '
		GOTO ErrorHandler
	END
END
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

/* check for name collisions */
DECLARE @isNameCollision BIT
SELECT @isNameCollision = dbo.IsCollision_fn(@pParentNodeId, @pItemName)
IF (@isNameCollision = 1)
BEGIN
	SELECT @sql_error = -1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
		GOTO ErrorHandler
	END
END

IF (@parentFolderName='_Recycle Bin')
BEGIN
	SELECT @sql_error = -1
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'User may not add a folder to the recycle bin: ' 
		  GOTO ErrorHandler
	   END
END

INSERT dbo.RepositoryItem (RepositoryFolderID, ItemName, ownerID
	  , description, keywords, verifiedByStudent)
VALUES (@pParentNodeId, @pItemName, @pUserId
	  , @pDescription, @pKeywords, @pVerifiedByStudent)

DECLARE @lastItemId BIGINT, @bundleId BIGINT
SELECT @lastItemId = scope_identity()
	,@sql_error = @@error
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to insert a new file node: '
	  GOTO ErrorHandler
   END

INSERT dbo.Bundle (RepositoryItemId, PrimaryBitstreamId)
VALUES (@LastItemId, null)

select @sql_error = @@error, @bundleId = SCOPE_IDENTITY()
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to insert bundle for item: '
	  GOTO ErrorHandler
   END

DECLARE @now DATETIME, @BitstreamId BIGINT
SELECT @now = GetDate()

INSERT dbo.Bitstream (
	BundleId
	,Bitstream
	,URL
	,[Name]
	,Ext
	,Description
	,[Size]
	,LastUpload
	,InitialUpload
    ,ContentType
	,OwnerId
)

VALUES (
	@bundleId
	,@pBitstream
	,@pUrl
	,@pFileName
	,@pFileExt
	,@pDescription
	,@pSize
	,@now
    ,@now
    ,@pContentType
	,@pUserId
)

SELECT @sql_error = @@error, @bitstreamId = SCOPE_IDENTITY()
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to insert a new bitstream. '
	  GOTO ErrorHandler
   END

UPDATE dbo.UserRepoContext
   SET DiskUsage = DiskUsage + @pSize
 WHERE OwnerID = @pUserId

select @sql_error = @@error
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'Problem trying to update disk quota. '
	  GOTO ErrorHandler
   END


UPDATE dbo.Bundle
   SET PrimaryBitStreamID=@bitstreamId
 WHERE BundleId=@bundleId

SELECT * from dbo.vRepositoryItem
where RepositoryItemID = @lastItemId

----------------------
-- Handle errors --
----------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '---'
			+ 'ParentNodeID = ' + CONVERT(varchar (20),@pParentNodeID) + ' | '
		    + 'UserID = ' + CONVERT(varchar (20),@pUserId) + ' | '
		    + 'TreeOwner = ' + CONVERT(varchar (20),@treeOwner) + ' | '
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


