IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.IsTrainingProtocolOnPlaylist') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc IsTrainingProtocolOnPlaylist.'
      DROP PROCEDURE dbo.IsTrainingProtocolOnPlaylist
   END
GO
PRINT '.. Creating sproc IsTrainingProtocolOnPlaylist.'
GO

CREATE PROCEDURE dbo.IsTrainingProtocolOnPlaylist
	@pProtocolID BIGINT
	,@pUserID BIGINT
AS

SET NOCOUNT ON 

IF NOT EXISTS (SELECT TrainingProtocolID FROM dbo.SETrainingProtocolPlaylist WHERE TrainingProtocolID=@pProtocolID AND UserID=@pUserID)
BEGIN
SELECT Result=0
END
ELSE
SELECT Result=1

