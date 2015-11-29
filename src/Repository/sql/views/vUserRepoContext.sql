IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserRepoContext')
   BEGIN
      PRINT '.. Dropping View vUserRepoContext.'
	  DROP VIEW dbo.vUserRepoContext
   END
GO
PRINT '.. Creating View vUserRepoContext.'
GO
CREATE VIEW dbo.vUserRepoContext
AS 


SELECT
	 ur.DiskQuota
	,ur.DiskUsage
	,ur.MaxFileSize
	,f.*
  FROM dbo.UserRepoContext ur
  JOIN vRepositoryFolder f on f.OwnerID = ur.OwnerId
 WHERE f.LeftOrdinal = 0

  