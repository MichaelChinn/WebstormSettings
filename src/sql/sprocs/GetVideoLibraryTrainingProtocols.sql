IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetVideoLibraryTrainingProtocols') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetVideoLibraryTrainingProtocols.'
      DROP PROCEDURE dbo.GetVideoLibraryTrainingProtocols
   END
GO
PRINT '.. Creating sproc GetVideoLibraryTrainingProtocols.'
GO

CREATE PROCEDURE dbo.GetVideoLibraryTrainingProtocols
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vTrainingProtocol
 WHERE Published=1
   AND Retired=0
   AND IncludeInVideoLibrary=1
 ORDER BY Title

