/*
1) restore RepoSubset from f:/dev/david/repo/RepoSubset_start.bak
2) edit the insert statement below to include user repos wanted
3) run this script

Result is in the database RepoSubset
*/
--drop table #owners
CREATE Table #Owners (OwnerID bigint)
INSERT #Owners (OwnerID) values (823555)



SET IDENTITY_INSERT RepoSubset.dbo.RepositoryFolder ON
INSERT RepoSubset.dbo.RepositoryFolder
(
	[RepositoryFolderId]
	,[FolderName]
	,[LeftOrdinal]
	,[RightOrdinal]
	,[ParentNodeId]
	,[OwnerId]
)
SELECT 
	[RepositoryFolderId]
	,[FolderName]
	,[LeftOrdinal]
	,[RightOrdinal]
	,[ParentNodeId]
	,[OwnerId]
FROM efoliolite_repository.dbo.RepositoryFolder
WHERE OwnerID in (SELECT OwnerID from #Owners)
SET IDENTITY_INSERT RepoSubset.dbo.RepositoryFolder OFF


SET IDENTITY_INSERT RepoSubset.dbo.RepositoryItem ON
INSERT RepoSubset.dbo.RepositoryItem
(
	[RepositoryItemId]
	,[OwnerID]
	,[ItemName]
	,[Description]
	,[Keywords]
	,[VerifiedByStudent]
	,[RepositoryFolderId]
	,[WithdrawnFlag]
	,[IsImmutable]
)
SELECT
	[RepositoryItemId]
	,[OwnerID]
	,[ItemName]
	,[Description]
	,[Keywords]
	,[VerifiedByStudent]
	,[RepositoryFolderId]
	,[WithdrawnFlag]
	,[IsImmutable]
FROM efoliolite_repository.dbo.RepositoryItem
WHERE OwnerID in (SELECT OwnerID from #Owners)
SET IDENTITY_INSERT RepoSubset.dbo.RepositoryItem OFF


INSERT RepoSubset.[dbo].[AppUsageCount]
(
	[ApplicationString]
	,[RepositoryItemId]
	,[ReferenceCount]
	,[ImmutabilityCount]
)
SELECT 
	[ApplicationString]
	,[RepositoryItemId]
	,[ReferenceCount]
	,[ImmutabilityCount]
FROM efoliolite_repository.dbo.AppUsageCount
WHERE RepositoryItemID in (Select RepositoryItemID from RepoSubset.dbo.RepositoryItem)


SET IDENTITY_INSERT RepoSubset.dbo.Bundle ON
INSERT RepoSubset.dbo.[Bundle]
(
	[BundleID]
	,[RepositoryItemID] 
 )
SELECT
	[BundleID]
	,[RepositoryItemID] 
FROM efoliolite_repository.dbo.Bundle
WHERE RepositoryItemID in (Select RepositoryItemID from RepoSubset.dbo.RepositoryItem)
SET IDENTITY_INSERT RepoSubset.dbo.Bundle OFF


SET IDENTITY_INSERT RepoSubset.dbo.Bitstream ON
INSERT RepoSubset.[dbo].[Bitstream]
(
	[BitstreamID]
	,[BundleID]
	,[Bitstream]
	,[URL]
	,[Name]
	,[Ext]
	,[ContentType]
	,[Description]
	,[Size]
	,[InitialUpload]
	,[LastUpload]
	,[OwnerId]
	,[OldRepoPath]
)
SELECT
	[BitstreamID]
	,[BundleID]
	,[Bitstream]
	,[URL]
	,[Name]
	,[Ext]
	,[ContentType]
	,[Description]
	,[Size]
	,[InitialUpload]
	,[LastUpload]
	,[OwnerId]
	,[OldRepoPath]
FROM efoliolite_repository.dbo.Bitstream
WHERE OwnerID in (SELECT OwnerID from #Owners)
SET IDENTITY_INSERT RepoSubset.dbo.Bitstream OFF

UPDATE RepoSubset.dbo.Bundle
SET PrimaryBitstreamID =s.PrimaryBitstreamID
FROM RepoSubset.dbo.Bundle r
JOIN efoliolite_repository.dbo.Bundle s on s.bundleID = r.bundleID

SET IDENTITY_INSERT RepoSubset.dbo.UserRepoContext ON
INSERT RepoSubset.[dbo].[UserRepoContext]
(
	[UserRepoContextID]
	,[OwnerID]
	,[DiskQuota]
	,[DiskUsage]
	,[MaxFileSize]
)
SELECT
	[UserRepoContextID]
	,[OwnerID]
	,[DiskQuota]
	,[DiskUsage]
	,[MaxFileSize]
FROM efoliolite_repository.dbo.UserRepoContext
WHERE OwnerID in (SELECT OwnerID from #Owners)
SET IDENTITY_INSERT RepoSubset.dbo.UserRepoContext OFF


SET IDENTITY_INSERT RepoSubset.dbo.ImageType ON
INSERT RepoSubset.[dbo].[ImageType]
(
	[ImageTypeID]
	,[Extension]
	,[ImageType]
)
SELECT
	[ImageTypeID]
	,[Extension]
	,[ImageType]
FROM efoliolite_repository.dbo.ImageType
SET IDENTITY_INSERT RepoSubset.dbo.ImageType OFF

