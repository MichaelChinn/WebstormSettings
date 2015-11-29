if exists (select * from sysobjects 
where id = object_id('dbo.GetUsedRepositoryItems') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUsedRepositoryItems.'
      drop procedure dbo.GetUsedRepositoryItems
   END
GO
PRINT '.. Creating sproc GetUsedRepositoryItems.'
GO
CREATE PROCEDURE GetUsedRepositoryItems
	 @pOwnerId bigint = -1
	,@pFolderId bigint = -1
AS
SET NOCOUNT ON 


/***********************************************************************************/
BEGIN
	
	if (@pOwnerId <> -1)
	BEGIN
		select ri.* from dbo.vRepositoryItem ri
		join dbo.AppUsageCount auc on auc.RepositoryItemID = ri.RepositoryItemID
		where ri.ownerId = @pOwnerId
			and ((auc.ImmutabilityCount>0) or (auc.ReferenceCount > 0))
		order by  ItemName
	END

	ELSE IF (@pFolderID <> -1)
	BEGIN
		DECLARE @l bigint, @r bigint
		SELECT @l = leftOrdinal, @r=rightOrdinal, @pOwnerId = ownerId
		FROM dbo.RepositoryFolder where RepositoryFolderID = @pFolderID
		
		create table #folders (RepositoryFolderID bigint)
		insert #folders
		select RepositoryFolderID from dbo.RepositoryFolder
		where @l <= LeftOrdinal  and RightOrdinal <= @r
			and ownerId = @pOwnerId

		select ri.* from dbo.vRepositoryItem ri
		join dbo.AppUsageCount auc on auc.RepositoryItemID = ri.RepositoryItemID
		join #folders f on f.RepositoryFolderID = ri.RepositoryFolderID
		where ((auc.ImmutabilityCount>0) or (auc.ReferenceCount > 0))
	END

END
