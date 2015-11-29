IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetVideoLibraryTrainingProtocolsWithLabels') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetVideoLibraryTrainingProtocolsWithLabels.'
      DROP PROCEDURE dbo.GetVideoLibraryTrainingProtocolsWithLabels
   END
GO
PRINT '.. Creating sproc GetVideoLibraryTrainingProtocolsWithLabels.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolsWithLabels
	@pLabelsToMatch VARCHAR(MAX)

AS

SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vTrainingProtocol p
  JOIN dbo.SETrainingProtocolLabelAssignment ma ON p.TrainingProtocolID=ma.TrainingProtocolID
  JOIN dbo.SETrainingProtocolLabel l on ma.TrainingProtocolLabelID=l.TrainingProtocolLabelID
 WHERE l.TrainingProtocolLabelID=CONVERT(SMALLINT, @pLabelsToMatch)
   AND p.IncludeInVideoLibrary=1

  
  
