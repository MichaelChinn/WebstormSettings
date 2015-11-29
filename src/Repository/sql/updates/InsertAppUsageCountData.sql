--Run this script to insert data into the AppUsageCount table.
--Only run this one time

if exists (select RepositoryItemID from dbo.AppUsageCount)
	return

INSERT dbo.AppUsageCount (ApplicationString, RepositoryItemID, ReferenceCount, ImmutabilityCount)
SELECT 'EFOLIO'
		, dt.RepositoryItemID
		, (SELECT count(*) FROM efoliolite.dbo.PortfolioNodeData pnd 
			WHERE pnd.RepositoryItemID = dt.RepositoryItemID)
		, (SELECT count(*) FROM efoliolite.dbo.PortfolioNodeData pnd 
			WHERE pnd.RepositoryItemID = dt.RepositoryItemID)
--		, (SELECT count(*) FROM RepositoryItem ri
--			WHERE IsImmutable = 1 
--			AND ri.RepositoryItemID = dt.RepositoryItemID)
FROM (SELECT DISTINCT RepositoryItemID 
		FROM efoliolite.dbo.PortfolioNodeData) AS dt 
WHERE dt.RepositoryItemID IS NOT NULL
GO

