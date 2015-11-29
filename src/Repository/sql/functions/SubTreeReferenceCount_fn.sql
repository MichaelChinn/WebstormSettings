IF OBJECT_ID ('dbo.SubTreeReferenceCount_fn ') IS NOT NULL
   BEGIN
      PRINT '.. Dropping function dbo.SubTreeReferenceCount_fn .'
      DROP FUNCTION dbo.SubTreeReferenceCount_fn 
   END
GO
PRINT '.. Creating function dbo.SubTreeReferenceCount_fn .'
GO


CREATE FUNCTION dbo.SubTreeReferenceCount_fn (@parentFolder bigint, @ownerId bigint)
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @hasNoReferences bit, @left bigint, @right bigint, @references int
	 	 
	select @references = sum(referenceCount) from dbo.RepositoryItem
	where RepositoryFolderId in 
		(select RepositoryFolderId from dbo.RepositoryFolder
		where (@ownerId = ownerId) and (@left <= leftOrdinal and rightOrdinal <=@right)
		)

     RETURN(@references)
END;
