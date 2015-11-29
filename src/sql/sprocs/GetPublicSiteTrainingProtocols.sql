IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPublicSiteTrainingProtocols') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPublicSiteTrainingProtocols.'
      DROP PROCEDURE dbo.GetPublicSiteTrainingProtocols
   END
GO
PRINT '.. Creating sproc GetPublicSiteTrainingProtocols.'
GO

CREATE PROCEDURE dbo.GetPublicSiteTrainingProtocols
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vTrainingProtocol
 WHERE Published=1
   AND Retired=0
   AND IncludeInPublicSite=1
 ORDER BY Title

