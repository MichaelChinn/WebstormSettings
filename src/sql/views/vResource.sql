
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vResource')
    DROP VIEW dbo.vResource
GO

CREATE VIEW dbo.vResource
AS 

SELECT r.ResourceID
	  ,r.SchoolYear
	  ,r.DistrictCode
	  ,r.SchoolCode
	  ,r.Comments
	  ,ri.RepositoryItemID
	  ,ri.ItemName
	  ,ri.Description
	  ,ri.OwnerID AS SEUserID
	  ,bs.BitstreamID
	  ,bs.URL
	  ,bs.Ext
	  ,bs.ContentType
	  ,bs.Name AS FileName
	  ,bs.InitialUpload
	  ,bs.LastUpload
      ,CASE WHEN (bs.ContentType = 'URL') THEN 0 ELSE 1 END AS IsFile
	  ,Retired
	  ,ResourceTypeID
 FROM dbo.SEResource r
 JOIN $(RepoDatabaseName).dbo.RepositoryItem ri
   ON ri.RepositoryItemID=r.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bundle b
   ON ri.RepositoryItemID=b.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bitstream bs
   ON b.PrimaryBitstreamID=bs.BitstreamID




