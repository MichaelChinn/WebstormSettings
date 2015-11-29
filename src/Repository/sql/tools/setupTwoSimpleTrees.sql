truncate table repositoryItem

insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('0', 0,13, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.1', 1,2, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.1', 4,5, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.2', 6,7, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.3', 8,9, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.4', 10,11, 1, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.1', 3,12, 1, 1, 0, Convert(varBinary, ''))

insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('0',   0,13,  2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.1', 1,2,   2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.2', 3,4,   2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.3', 5,8,   2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('2.1', 6,7,   2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.4', 9,10,  2, 1, 0, Convert(varBinary, ''))
insert RepositoryItem (nodeName, leftOrdinal, rightOrdinal, ownerId, isFolder, referenceCount, data) values ('1.5', 11,12, 2, 1, 0, Convert(varBinary, ''))


select * from repositoryItem order by leftOrdinal

/*
	SELECT COUNT(P2.emp) AS indentation, P1.emp
   	FROM Personnel AS P1, Personnel AS P2
  	WHERE P1.lft BETWEEN P2.lft AND P2.rgt
  	GROUP BY P1.emp
  	ORDER BY P1.lft;

	think of it like... how many times is the value of a left
	ordinal contained between the left and right ordinals of a node?
*/

	declare @ownerId bigint
	select @ownerID=2

	select count (r2.nodeID)-1 AS indentation
		, r1.LeftOrdinal
		, r1.NodeId
		, r1.NodeName
		, r1.OwnerId
		, r1.IsFolder
		, r1.ReferenceCount
	from dbo.RepositoryItem r1, dbo.repositoryItem r2
	where r1.leftOrdinal between r2.leftOrdinal and r2.rightOrdinal
		and r1.OwnerID = @ownerID and r2.OwnerId=@ownerId
	group by
		  r1.LeftOrdinal
		, r1.NodeId
		, r1.NodeName
		, r1.OwnerId
		, r1.IsFolder
		, r1.ReferenceCount

	order by r1.leftOrdinal


