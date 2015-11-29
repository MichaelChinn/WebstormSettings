if exists (select * from sysobjects 
where id = object_id('dbo.AddItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddItem.'
      drop procedure dbo.AddItem
   END
GO
PRINT '.. Creating sproc AddItem.'
GO
CREATE PROCEDURE AddItem
		@pParentNodeID bigint
		,@pUserId bigint
		,@pItemName varchar(512)
		,@pDescription varchar(1024) = ''
		,@pKeywords varchar (1024) = ''
		,@pVerifiedByStudent bit = 0
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

	declare @treeOwner bigint, @rc int, @parentFolderName varchar(512)

	select @treeOwner = ownerID
		, @parentFolderName = FolderName
		from dbo.RepositoryFolder where RepositoryFolderID =@pParentNodeID

	if (@treeOwner <> @pUserId)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'You may not place items in locker that is not owned by you. '
			GOTO ErrorHandler
		END
	end

	/* check for item name collisions */
	declare @isNameCollision bit
	select @isNameCollision = dbo.IsCollision_fn(@pParentNodeId, @pItemName)
	if (@isNameCollision = 1)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END
	end

	if (@parentFolderName='_Recycle Bin')
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'User may not add a folder to the recycle bin: ' 
			  GOTO ErrorHandler
		   END
	end

	insert dbo.RepositoryItem (RepositoryFolderID, ItemName, ownerID
		, description, keywords, verifiedByStudent)
	values (@pParentNodeId, @pItemName, @pUserId
		, @pDescription, @pKeywords, @pVerifiedByStudent)

	declare @lastItemId bigint
	select @lastItemId = scope_identity()
		,@sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert a new file node: '
		  GOTO ErrorHandler
	   END

	insert dbo.Bundle (RepositoryItemId, PrimaryBitstreamId)
	values (@LastItemId, null)

	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert bundle for item: '
		  GOTO ErrorHandler
	   END


	select * from dbo.vRepositoryItem where repositoryItemId = @lastItemId


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


