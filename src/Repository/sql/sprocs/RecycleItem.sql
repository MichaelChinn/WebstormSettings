if exists (select * from sysobjects 
where id = object_id('dbo.RecycleItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RecycleItem.'
      drop procedure dbo.RecycleItem
   END
GO
PRINT '.. Creating sproc RecycleItem.'
GO
CREATE PROCEDURE RecycleItem
		 @pItemId bigint

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
	
	declare @ownerID bigint, @itemName varchar(512)
	select @ownerID = ownerId 
		, @itemName = itemName
	from dbo.RepositoryItem where RepositoryItemId = @pItemId

	declare @RecycleID int
	select @RecycleID=RepositoryFolderId from dbo.RepositoryFolder
		where FolderName='_Recycle Bin' and ownerID = @ownerId

	if (@RecycleID is Null)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Could not find recycle folder. ' 
			  GOTO ErrorHandler
		   END
	end


	/* check for name collisions */
	declare @isNameCollision bit
	select @isNameCollision = dbo.IsCollision_fn(@recycleId, @ItemName)

	if (@isNameCollision = 1)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item or folder with same name currently exists in Recycle Bin; empty bin first. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
			GOTO ErrorHandler
		END
	end

	update dbo.RepositoryItem set RepositoryFolderId = @RecycleID
	where RepositoryitemId = @pItemid

	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
			  SELECT @sql_error_message = 'Move subtree to recycle bin failed. ' 
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
      SELECT @sql_error_message = @sql_error_message + 
      	  '-- RepositoryItemId = ' + convert(varchar(20), ISNULL(@pItemId, '')) + 
	      '-- userId = ' + convert(varchar(20), ISNULL(@ownerId, '')) + 
          '.  In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')

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


