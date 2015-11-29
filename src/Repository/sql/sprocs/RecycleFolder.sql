if exists (select * from sysobjects 
where id = object_id('dbo.RecycleFolder') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RecycleFolder.'
      drop procedure dbo.RecycleFolder
   END
GO
PRINT '.. Creating sproc RecycleFolder.'
GO
CREATE PROCEDURE RecycleFolder
		 @pFolderId bigint

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
	if not exists (select RepositoryFolderId from dbo.RepositoryFolder where @pFolderId = RepositoryFolderId )
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Could not find node requested. ' 
			  GOTO ErrorHandler
		   END
	end

	declare @ownerId bigint, @left int, @FolderName varchar(512)
			, @right int, @parentId bigint
	select @ownerId = ownerId 
		,@left = leftOrdinal
		,@right = rightOrdinal
		,@parentID = parentNodeId
		,@folderName = folderName
	from dbo.RepositoryFolder 
	where @pFolderId = RepositoryFolderId

	if (@left=0)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'You cannot recycle the root node. '
			  GOTO ErrorHandler
		   END
	end

	if (@FolderName='_Recycle Bin')
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'You cannot recycle the recycle bin node. '
			  GOTO ErrorHandler
		   END
	end


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

-- new name collision processing...

	declare @isCollision bit
	select @isCollision = dbo.IsCollision_fn(@RecycleId, @folderName)
	if (@isCollision = 1)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item or Folder with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END
	end

--****************************************************--
	DECLARE @rc int
	exec @rc = MoveSubTree @pFolderId, @RecycleID

	SELECT @sql_error = @rc
	IF @sql_error <> 0
	   BEGIN
			  SELECT @sql_error_message = 'Move subtree to recycle bin failed. '
			  GOTO ErrorHandler
	   END
end

/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
			SELECT @sql_error_message = @sql_error_message + 
				'-- RepositoryFolderId = ' + convert(varchar(20), ISNULL(@pFolderId, '')) + 
				'-- userId = ' + convert(varchar(20), ISNULL(@ownerId, '')) + 
                '.  In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
            ROLLBACK TRANSACTION
         END
      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
   BEGIN
      COMMIT TRANSACTION
   END

RETURN(@sql_error)

GO

