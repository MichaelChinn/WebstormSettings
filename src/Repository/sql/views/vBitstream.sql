IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vBitstream')
   BEGIN
      PRINT '.. Dropping View vBitstream.'
	  DROP VIEW dbo.vBitstream
   END
GO
PRINT '.. Creating View vBitstream.'
GO
CREATE VIEW dbo.vBitstream
AS 


SELECT
  bs.[BitstreamID]
  ,bs.[ContentType]
  ,bs.[BundleID]
  ,bs.[URL]
  ,bs.[Name]
  ,bs.[Ext]
  ,bs.[Description]
  ,bs.[Size]
  ,bs.[InitialUpload]
  ,bs.[LastUpload]
  ,b.[RepositoryItemID]
  ,bs.[OldRepoPath]
  ,bs.[OwnerId]
  ,CASE
		WHEN (b.PrimaryBitstreamID = bs.BitstreamID) THEN 1
		ELSE 0
   END AS IsPrimaryBitstream
  FROM bitstream bs
  JOIN bundle b on b.bundleID = bs.bundleID

  