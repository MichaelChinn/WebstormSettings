IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionLibraryVideoById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionLibraryVideoById.'
      DROP PROCEDURE dbo.GetEvalSessionLibraryVideoById
   END
GO
PRINT '.. Creating sproc GetEvalSessionLibraryVideoById.'
GO

CREATE PROCEDURE dbo.GetEvalSessionLibraryVideoById
	@pEvalSessionLibraryVideoID BIGINT
AS

SET NOCOUNT ON 

SELECT EvalSessionLibraryVideoID
	  ,Title
	  ,DESCRIPTION
	  ,VideoName
	  ,Retired
 FROM dbo.SEEvalSessionLibraryVideo
WHERE EvalSessionLibraryVideoID=@pEvalSessionLibraryVideoID
 



