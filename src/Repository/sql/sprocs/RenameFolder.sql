if exists (select * from sysobjects 
where id = object_id('dbo.RenameFolder') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RenameFolder.'
      drop procedure dbo.RenameFolder
   END
GO
PRINT '.. Creating sproc RenameFolder.'
GO
CREATE PROCEDURE RenameFolder
	 @pFolderId bigint
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
	if not exists (select RepositoryFolderId 
		from dbo.RepositoryFolder where RepositoryFolderId = @pFolderId)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Cannot find node to rename.'
			  GOTO ErrorHandler
		   END
	end


/*********/
	declare @parentFolderId varchar(512), @ownerID bigint
		, @isNameCollision bit, @left bigint, @right bigint
	select @left= leftOrdinal, @right=RightOrdinal, @ownerID = OwnerID, @parentFolderID=parentNodeId
      from dbo.RepositoryFolder
	 WHERE RepositoryFolderID = @pFolderID

	if (@left=0)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'You may not rename the root.'
			  GOTO ErrorHandler
		   END
	end

	select @isNameCollision = dbo.IsCollision_fn(@parentFolderId, @pNewName)
	if (@isNameCollision=1)
	SELECT @sql_error = -1
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Item or folder with same name currently exists in destination folder.'
		  GOTO ErrorHandler
	   END
	
	update dbo.RepositoryFolder
		set FolderName = @pNewName
		where RepositoryFolderId = @pFolderId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not rename item.' 
		  GOTO ErrorHandler
	   END

	select * from dbo.vRepositoryFolder where RepositoryFolderID= @pFolderId

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
      	  '-- FolderID = ' + convert(varchar(20), ISNULL(@pFolderId, '')) + 
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