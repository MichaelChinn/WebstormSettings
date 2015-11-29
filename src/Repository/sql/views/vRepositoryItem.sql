IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRepositoryItem')
   BEGIN
      PRINT '.. Dropping View vRepositoryItem.'
	  DROP VIEW dbo.vRepositoryItem
   END
GO
PRINT '.. Creating View vRepositoryItem.'
GO
CREATE VIEW dbo.vRepositoryItem
AS 

SELECT
  r.[RepositoryItemId]                                                                                                                                                                
  ,r.[ItemName]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  ,r.[OwnerID]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  ,r.[Description] AS ItemDescription                                                                                                                                                                                                                                                                                                                                                                      
  ,r.[Keywords]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  ,r.[VerifiedByStudent]                                                                                                                        
  ,r.[RepositoryFolderId]                                                                                
  ,r.[WithdrawnFlag]
,r.IsImmutable                                                                                                                                                                                                        
  ,b.[BundleId]
  ,b.[PrimaryBitstreamId]
  ,sum(bs.size) AS [size]

  
  FROM RepositoryItem r
  left outer JOIN dbo.bundle b on b.repositoryItemID = r.repositoryItemID
  left outer Join dbo.Bitstream bs on bs.bundleId = b.bundleId

  group by 
   r.[RepositoryItemId]                                                                                                                                                                
  ,r.[ItemName]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  ,r.[OwnerID]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  ,r.Description                                                                                                                                                                                                                                                                                                                                                                   
  ,r.[Keywords]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  ,r.[VerifiedByStudent]                                                                                                                        
  ,r.[RepositoryFolderId]                                                                                
  ,r.[WithdrawnFlag]    
,r.IsImmutable                                                                                                                                                                                                    
  ,b.[BundleId]
  ,b.[PrimaryBitstreamId]


