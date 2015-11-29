IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vBundle')
   BEGIN
      PRINT '.. Dropping View vBundle.'
	  DROP VIEW dbo.vBundle
   END
GO
PRINT '.. Creating View vBundle.'
GO
CREATE VIEW dbo.vBundle
AS 


SELECT
  b.[BundleID]
  ,b.[PrimaryBitstreamID]
  ,b.[RepositoryItemID]

  FROM bundle b 
  