if exists (select * from sysobjects 
where id = object_id('dbo.RenameRepositoryItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RenameRepositoryItem.'
      drop procedure dbo.RenameRepositoryItem
   END
GO
PRINT '.. Creating sproc RenameRepositoryItem.'
GO
CREATE PROCEDURE RenameRepositoryItem
	 @pItemId bigint
	,@pNewName varchar(512)
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
	if not exists (select RepositoryItemId 
		from dbo.RepositoryItem where RepositoryItemId = @pItemId)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Cannot find node to rename.'
			  GOTO ErrorHandler
		   END
	end

	declare @parentFolderId varchar(512), @isNameCollision bit, @isImmutable bit

	select @isImmutable=dbo.ItemIsImmutable_fn(@pItemId)

	IF (@isImmutable = 1)
	SELECT @sql_error = -1
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Item has been set immutable, and so cannot be changed.'
		  GOTO ErrorHandler
	   END

	select @parentFolderId = RepositoryFolderId 
	  from dbo.RepositoryItem
	where repositoryItemId = @pItemId

	select @isNameCollision = dbo.IsCollision_fn(@parentFolderId, @pNewName)
	if (@isNameCollision=1)
	SELECT @sql_error = -1
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
		  GOTO ErrorHandler
	   END
	
	update dbo.RepositoryItem
		set ItemName = @pNewName
		where RepositoryItemId = @pItemId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not rename item.'
		  GOTO ErrorHandler
	   END

	select * from dbo.vRepositoryItem where RepositoryItemID= @pItemId

END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + 
      	  '-- ItemId = ' + convert(varchar(20), ISNULL(@pItemId, '')) + 
	      '-- NewName = ' + convert(varchar(20), ISNULL(@pNewName, '')) + 
          '.  In: ' + @ProcName + '. ' 
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