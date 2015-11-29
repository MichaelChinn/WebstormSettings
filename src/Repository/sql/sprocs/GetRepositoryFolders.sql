if exists (select * from sysobjects 
where id = object_id('dbo.GetRepositoryFolders') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRepositoryFolders.'
      drop procedure dbo.GetRepositoryFolders
   END
GO
PRINT '.. Creating sproc GetRepositoryFolders.'
GO
CREATE PROCEDURE GetRepositoryFolders
	 @pOwnerId bigint
AS
SET NOCOUNT ON 


/***********************************************************************************/
BEGIN

	select * from dbo.vRepositoryFolder
	where ownerId = @pOwnerId
	order by ParentNodeId, folderName


END
