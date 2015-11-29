IF OBJECT_ID ('dbo.IsCollision_fn ') IS NOT NULL
   BEGIN
      PRINT '.. Dropping function dbo.IsCollision_fn .'
      DROP FUNCTION dbo.IsCollision_fn 
   END
GO
PRINT '.. Creating function dbo.IsCollision_fn .'
GO


CREATE FUNCTION dbo.IsCollision_fn (@ContainingFolderId bigint, @testName varchar(512))
RETURNS bit
--WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @isCollision bit
	select @isCollision = 0

	if exists (
		select RepositoryFolderID from RepositoryFolder
		 where ParentNodeID = @ContainingFolderId
		   and folderName = @testName
	)
	select @isCollision=1

	if exists (
		select RepositoryItemID from RepositoryItem
		 where RepositoryFolderID = @ContainingFolderID
		   and ItemName = @testName
	)
	select @isCollision=1

		
     RETURN(@isCollision)
END