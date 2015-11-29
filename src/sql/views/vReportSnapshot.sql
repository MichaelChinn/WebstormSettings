
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vReportSnapshot')
    DROP VIEW dbo.vReportSnapshot
GO

CREATE VIEW dbo.vReportSnapshot
AS 

SELECT ReportSnapshotID
	  ,SchoolYear
	  ,DistrictCode
	  ,ReportTypeID
	  ,IsPublic
	  ,ri.RepositoryItemID
	  ,ri.ItemName
	  ,ri.Description
	  ,ri.OwnerID AS SEUserID
	  ,bs.BitstreamID
	  ,bs.Ext
	  ,bs.ContentType
	  ,bs.Name AS FileName
	  ,bs.InitialUpload
 FROM dbo.SEReportSnapshot s
 JOIN $(RepoDatabaseName).dbo.RepositoryItem ri
   ON ri.RepositoryItemID=s.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bundle b
   ON ri.RepositoryItemID=b.RepositoryItemID
 JOIN $(RepoDatabaseName).dbo.Bitstream bs
   ON b.PrimaryBitstreamID=bs.BitstreamID




