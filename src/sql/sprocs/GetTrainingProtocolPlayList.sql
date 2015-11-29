IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolPlaylist') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolPlaylist.'
      DROP PROCEDURE dbo.GetTrainingProtocolPlaylist
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolPlaylist.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolPlaylist
	@pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vTrainingProtocol p
  JOIN dbo.SETrainingProtocolPlaylist pl ON p.TrainingProtocolID=pl.TrainingProtocolID
 WHERE p.Published=1
   AND p.Retired=0
   AND pl.UserID=@pUserID

