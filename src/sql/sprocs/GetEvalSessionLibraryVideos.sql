IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionLibraryVideos') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionLibraryVideos.'
      DROP PROCEDURE dbo.GetEvalSessionLibraryVideos
   END
GO
PRINT '.. Creating sproc GetEvalSessionLibraryVideos.'
GO

CREATE PROCEDURE dbo.GetEvalSessionLibraryVideos
AS

SET NOCOUNT ON 

SELECT EvalSessionLibraryVideoID
	  ,Title
	  ,DESCRIPTION
	  ,VideoName
	  ,Retired
 FROM dbo.SEEvalSessionLibraryVideo
 



