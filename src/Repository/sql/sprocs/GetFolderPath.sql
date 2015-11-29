GO
IF OBJECT_ID ('dbo.GetFolderPath') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetFolderPath.'
      DROP PROCEDURE dbo.GetFolderPath
   END
GO
PRINT '.. Creating sproc GetFolderPath.'
GO
CREATE PROCEDURE dbo.GetFolderPath
(
	@pFolderId		BIGINT
)

AS
begin
	declare @left bigint, @right bigint, @ownerId bigint
	select @left=leftOrdinal, @right=rightOrdinal, @ownerid = f.ownerId
	from dbo.RepositoryFolder f 
	where RepositoryFOlderID = @pFolderID

	select FolderName, leftOrdinal from dbo.RepositoryFolder
	where (leftOrdinal <= @left and @right <= rightOrdinal)
	and ownerId = @ownerId
	order by leftOrdinal
end
