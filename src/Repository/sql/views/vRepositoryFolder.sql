IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRepositoryFolder')
   BEGIN
      PRINT '.. Dropping View vRepositoryFolder.'
	  DROP VIEW dbo.vRepositoryFolder
   END
GO
PRINT '.. Creating View vRepositoryFolder.'
GO
CREATE VIEW dbo.vRepositoryFolder
AS 

SELECT
		RepositoryFolderId
		, FolderName
		, OwnerId
		, LeftOrdinal
		, RightOrdinal
		, ParentNodeId
		, -1 AS Indentation
		

FROM RepositoryFolder

