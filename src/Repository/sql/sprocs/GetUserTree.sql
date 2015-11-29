if exists (select * from sysobjects 
where id = object_id('dbo.GetUserTree') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserTree.'
      drop procedure dbo.GetUserTree
   END
GO
PRINT '.. Creating sproc GetUserTree.'
GO
CREATE PROCEDURE GetUserTree
	 @pOwnerId bigint
AS
BEGIN

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

	select 
		  r1.RepositoryFolderID
		, r1.FolderName
		, r1.leftOrdinal
		, r1.rightOrdinal
		, r1.ownerId
		, r1.parentNodeID
		, count (r2.RepositoryFolderID)-1 As Indentation
		, ',new RepositoryFolder (' 
			+ convert (varchar(20), r1.RepositoryFolderID)
			+ ',"' +  r1.FolderName + '"'
			+ ',' +  convert (varchar(20), r1.leftOrdinal)
			+ ',' +  convert (varchar(20), r1.rightOrdinal)
			+ ',' +  convert (varchar(20), r1.ownerId)
			+ ',' +  case when r1.parentNodeId is null then convert(varchar(20), -1) else convert (varchar(20),r1.parentNodeID) end
			+ ',' +  convert (varchar(20), count (r2.RepositoryFolderID)-1 )
			+ ')' AS TestText
		,case count(r2.RepositoryFolderID)-1
			when 0 then ''
			when 1 then '|===|'
			when 2 then '|===||===|'
			when 3 then '|===||===||===|'
			when 4 then '|===||===||===||===|'
			when 5 then '|===||===||===||===||===|'
			when 6 then '|===||===||===||===||===||===|'
			when 7 then '|===||===||===||===||===||===||===|'
			when 8 then '|===||===||===||===||===||===||===||===|'
			when 9 then '|===||===||===||===||===||===||===||===||===|'
			else 'too deep...' end
		+ r1.FolderName as htmlTestText


	from dbo.RepositoryFOlder r1, dbo.repositoryFolder r2
	where r1.leftOrdinal between r2.leftOrdinal and r2.rightOrdinal
		and r1.OwnerID = @pOwnerID and r2.OwnerId=@pOwnerId
	group by
		  r1.RepositoryFolderID
		, r1.FolderName
		, r1.leftOrdinal
		, r1.rightOrdinal
		, r1.ownerId
		, r1.parentNodeID

	order by r1.leftOrdinal

END
	
	
