if exists (select * from sysobjects 
where id = object_id('dbo.MoveItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc MoveItem.'
      drop procedure dbo.MoveItem
   END
GO
PRINT '.. Creating sproc MoveItem.'
GO
CREATE PROCEDURE MoveItem
		 @pItemId bigint
		,@pDestFolderId bigint

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
	if not exists (select RepositoryItemId from dbo.RepositoryItem where @pItemId = RepositoryItemId )
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Could not find node requested. '
			  GOTO ErrorHandler
		   END
	end
	
	declare @itemOwnerId bigint, @itemName varchar(512)
	select @itemOwnerId = ownerId 
		, @itemName = itemName
	from dbo.RepositoryItem where RepositoryItemId = @pItemId

	if (@pDestFolderID is Null)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Could not find destination folder. '
			  GOTO ErrorHandler
		   END
	end

	declare @folderOwnerId bigint
	select @folderOwnerId = ownerId from dbo.RepositoryFolder where RepositoryFolderId = @pDestFolderId

	if (@folderOwnerId <> @itemOwnerId)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Item owner and owner of target folder not the same. '
			  GOTO ErrorHandler
		   END
	end


	/* check for name collisions */
	declare @isNameCollision bit
	select @isNameCollision = dbo.IsCollision_fn(@pDestFolderId, @itemName)
	if (@isNameCollision = 1)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END
	end

	update dbo.RepositoryItem set RepositoryFolderId = @pDestFolderID
	where RepositoryItemId=@pItemID

	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
			  SELECT @sql_error_message = 'Move item to folder failed. '
			  GOTO ErrorHandler
	   END



end
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      
	SELECT @sql_error_message = @sql_error_message + '---'
			+ 'itemID = ' + CONVERT(varchar (20),@pItemID) + ' | '
		    + 'destination FolderID = ' + CONVERT(varchar (20),@pDestFolderID) + '---'
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


