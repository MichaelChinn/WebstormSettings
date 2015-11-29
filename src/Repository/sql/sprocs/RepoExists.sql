if exists (select * from sysobjects 
where id = object_id('dbo.RepoExists') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RepoExists.'
      drop procedure dbo.RepoExists
   END
GO
PRINT '.. Creating sproc RepoExists.'
GO
CREATE PROCEDURE RepoExists
		@pOwnerId bigint
AS
SET NOCOUNT ON 



/***********************************************************************************/
BEGIN

	declare @folderID bigint
	select @folderID = RepositoryFolderID 
	from RepositoryFolder 
	where ownerId = @pOwnerID and LeftOrdinal = 0

	if (@folderId is null)
		select -1
	else select @folderId
END

GO


