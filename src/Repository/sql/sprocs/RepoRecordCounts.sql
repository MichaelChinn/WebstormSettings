

if exists (select * from sysobjects 
where id = object_id('dbo.RepoRecordCounts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RepoRecordCounts.'
      drop procedure dbo.RepoRecordCounts
   END
GO
PRINT '.. Creating sproc RepoRecordCounts.'
GO

CREATE PROCEDURE dbo.RepoRecordCounts @pUserId bigint = null
AS
SET NOCOUNT ON 
begin
	
 
--drop table #allcounts

create table #AllCounts 
(
	userID bigint
	,appUsageCountCount bigint
	,BitstreamCount bigint
	,bundleCount bigint
	,ImageTypeCount bigint
	,RepositoryItemCOunt bigint
	,RepositoryFolder bigint
	,UserRepoContextCount bigint
)


insert #AllCounts (userID, appUsageCountCount) select 0, count(*) from AppUsageCount au
update #allCounts set BitstreamCount = (select count (*) from BitStream) where userID = 0
update #allCounts set bundleCount = (select count (*) from bundle) where userID = 0
update #allCounts set ImageTypeCount = (select count (*) from ImageType) where userID = 0
update #allCounts set RepositoryItemCOunt = (select count (*) from RepositoryItem) where userID = 0
update #allCounts set RepositoryFolder = (select count (*) from RepositoryFolder) where userID = 0
update #allCounts set UserRepoContextCount = (select count (*) from UserRepoContext) where userID = 0
 
insert #AllCounts (userID, appUsageCountCount) select @pUserId, count(*) from AppUsageCount au  where repositoryItemId in (select distinct repositoryitemID from bitstream where ownerID = @pUserId)
update #AllCounts set BitstreamCount = (select count (*) from BitStream where ownerID = @pUserId) where userID = @pUserId

update #AllCounts set bundleCount = (select count (*) from bundle 
where bundleID in (select bundleID from bitstream where ownerID = @pUserID)) where userID = @pUserId

update #AllCounts set ImageTypeCount = (select count (*) from ImageType) where userID = @pUserId
update #AllCounts set RepositoryItemCOunt = (select count (*) from RepositoryItem where ownerID = @pUserId) where userID = @pUserId
update #AllCounts set RepositoryFolder = (select count (*) from RepositoryFolder where ownerID = @pUserId) where userID = @pUserId
update #AllCounts set UserRepoContextCount = (select count (*) from UserRepoContext where ownerID = @pUserId) where userID = @pUserId


select * from #allCounts

END