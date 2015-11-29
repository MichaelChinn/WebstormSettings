if exists (select * from sysobjects 
where id = object_id('dbo.AddFolder') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddFolder.'
      drop procedure dbo.AddFolder
   END
GO
PRINT '.. Creating sproc AddFolder.'
GO
CREATE PROCEDURE AddFolder
		@pParentNodeID bigint
		,@pName	varchar (512)
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

	declare @newNodeId bigint

	declare @treeOwner bigint, @rc int, @startLeft int, @IsFolder bit, @parentName varchar(512)
	select 
		@treeOwner = ownerID
		,@startLeft= LeftOrdinal
		,@parentName = folderName
	  from dbo.RepositoryFolder 
     where RepositoryFolderID =@pParentNodeID

	/* check for folder name collisions... do this separately, because
		we want to just return if a folder of the same name already exists
   */
	declare @extantFolderID bigint

	if exists (
		select RepositoryFOlderId  from RepositoryFolder
		 Where FolderName = @pName
		   and ParentNodeID = @pParentNodeID)

	begin
/*	
		--this next bit was commented out.  It was here in the first place for 
		--the migration, as the scripts creating items might want to create a folder
		--again, but not have anything fail.  After the migration, it's desirable to know
		--when the user makes this mistake.

		select @extantFolderID = RepositoryFOlderId from RepositoryFolder
		     Where FolderName = @pName
		       and ParentNodeID = @pParentNodeID

			select * from dbo.vRepositoryFolder where repositoryFolderID = @ExtantFolderID
			GOTO ProcEnd
*/
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Folder with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END

	end

	if exists (
		select RepositoryItemID from RepositoryItem
		 where RepositoryFolderID = @pParentNodeID
		   and ItemName = @pName
	)

	begin
		SELECT @sql_error = -1
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Item with same name currently exists in destination folder.'
			GOTO ErrorHandler
		END
	end


	/* adjust the ordinals of all the nodes to the right */
	update dbo.RepositoryFolder
		set LeftOrdinal = LeftOrdinal + 2 
		where LeftOrdinal > @startLeft
		and ownerId = @treeOwner

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to update leftOrdinals prior to insert: '
		  GOTO ErrorHandler
	   END

	update dbo.RepositoryFolder 		   
		set RightOrdinal = RightOrdinal + 2
		where RightOrdinal > @startLeft
		and ownerID = @treeOwner

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem trying to update rightordinals prior to insert: ' 
		  GOTO ErrorHandler
	   END

	insert dbo.RepositoryFolder (folderName, leftOrdinal, rightOrdinal, ownerID, parentNodeId)
	values (@pName, @startLeft+1, @startLeft+2, @treeOwner, @pParentNodeId)

	select @newNodeid = scope_identity()
		,@sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert a new recycle node: ' 
		  GOTO ErrorHandler
	   END

	select * from dbo.vRepositoryFolder where repositoryFolderID = @newNodeId




END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
	  select @sql_error_message = @sql_error_message + '...'
			+ 'parentNodeID = ' + CONVERT(varchar(20), @pParentNodeID) + ' | '
			+ 'Name = ' + @pName + ' | '
			+ 'treeOwner = ' + Convert(varchar(20),@treeOwner) + ' | '
			+ 'startLeft = ' + Convert(varchar(20),@startLeft) + ' | '
			+ 'parentName = ' + @parentName + ' | '
			+ 'In:' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')

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


