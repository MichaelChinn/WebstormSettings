if exists (select * from sysobjects 
where id = object_id('dbo.GetRepositoryItems') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRepositoryItems.'
      drop procedure dbo.GetRepositoryItems
   END
GO
PRINT '.. Creating sproc GetRepositoryItems.'
GO
CREATE PROCEDURE GetRepositoryItems
	 @pOwnerId bigint
AS
SET NOCOUNT ON 


/***********************************************************************************/
BEGIN

	select * from dbo.vRepositoryItem
	where ownerId = @pOwnerId
	order by RepositoryFolderId, ItemName


END
