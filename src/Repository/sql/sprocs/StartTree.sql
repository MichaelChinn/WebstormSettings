if exists (select * from sysobjects 
where id = object_id('dbo.StartTree') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc StartTree.'
      drop procedure dbo.StartTree
   END
GO
PRINT '.. Creating sproc StartTree.'
GO
CREATE PROCEDURE StartTree
		@pOwnerID	bigint
		,@pMaxFileSize bigint = 30
		,@pDiskQuota  bigint = 250

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

	/*a new root to be started
			then have to check to see if user has repostior already
			(disallow multiple repositories for a user)
	
*/
	if exists (select ownerID from dbo.repositoryFolder where ownerId=@pOwnerId)
	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'New repository root requested for user that already has one.'
			  GOTO ErrorHandler
		   END
	end

	--new repository root.  insert recycle bin as first child of new root

	insert dbo.RepositoryFolder (FolderName, leftOrdinal, rightOrdinal, ownerID,  parentNodeId)
	values ('root', 0, 3, @pOwnerID,  null)

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert a new root node'
		  GOTO ErrorHandler
	   END
	
	declare @rootId bigint
	select @rootId = Scope_Identity()
	insert dbo.RepositoryFolder (FolderName, leftOrdinal, rightOrdinal, ownerID,  parentNodeId)
	values ('_Recycle Bin', 1, 2, @pOwnerID, @rootID)

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  ROLLBACK TRANSACTION
		  SELECT @sql_error_message = 'Problem trying to insert a new recycle node.'
		  GOTO ErrorHandler
	   END

	INSERT dbo.UserRepoContext (DiskUsage, DiskQUOTA, MaxFileSize, OwnerId)
	VALUES (0, @pDiskQuota, @pMaxFileSize, @pOwnerId)

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  ROLLBACK TRANSACTION
		  SELECT @sql_error_message = 'Problem setting user repo context.'
		  GOTO ErrorHandler
	   END
	
	select * from dbo.vRepositoryFolder where RepositoryFolderID=@rootId


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
      	  '-- OwnerId = ' + convert(varchar(20), ISNULL(@pOwnerId, '')) + 
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


