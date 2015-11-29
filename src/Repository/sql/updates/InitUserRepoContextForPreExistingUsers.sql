
DECLARE @nUsers bigint
select @nUsers= count (distinct ownerId) from bitstream
If exists (select UserRepoContextId from UserRepoContext)
	return

if (@nUsers = 0)
	return

insert UserRepoContext (OwnerId, DiskUsage, DiskQuota, MaxFileSize)
(
	select ownerId
		, sum(size)/1024/1024 as diskUsage
		, 250 as diskQuota
		, 30 as MaxFileSize 
	  from bitstream  
	 group by ownerId
)

/* 
select * from userRepoContext order by DiskUSage desc
select sum(size) from bitstream where ownerId = 715372
*/

