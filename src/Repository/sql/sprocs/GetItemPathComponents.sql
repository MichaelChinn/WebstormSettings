GO
IF OBJECT_ID ('dbo.GetItemPathComponents') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetItemPathComponents.'
      DROP PROCEDURE dbo.GetItemPathComponents
   END
GO
PRINT '.. Creating sproc GetItemPathComponents.'
GO
CREATE PROCEDURE dbo.GetItemPathComponents
(
	@pItemId		BIGINT
)

AS
begin
	declare @left bigint, @right bigint, @ownerId bigint
	select @left=leftOrdinal, @right=rightOrdinal, @ownerid = f.ownerId
	from dbo.RepositoryFolder f 
	join dbo.RepositoryItem i on i.RepositoryFolderId = f.RepositoryFolderId
	where RepositoryItemId = @pItemId

	select FolderName, leftOrdinal from dbo.RepositoryFolder
	where (leftOrdinal <= @left and @right <= rightOrdinal)
	and ownerId = @ownerId
	order by leftOrdinal
end
