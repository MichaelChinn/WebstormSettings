IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolsWithLabels') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolsWithLabels.'
      DROP PROCEDURE dbo.GetTrainingProtocolsWithLabels
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolsWithLabels.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolsWithLabels
	@pLabelsToMatch VARCHAR(MAX)
	,@pIncludeInVideoLibrary BIT
	,@pIncludeInPublicSite BIT

AS

SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vTrainingProtocol p
  JOIN dbo.SETrainingProtocolLabelAssignment ma ON p.TrainingProtocolID=ma.TrainingProtocolID
  JOIN dbo.SETrainingProtocolLabel l on ma.TrainingProtocolLabelID=l.TrainingProtocolLabelID
 WHERE l.TrainingProtocolLabelID=CONVERT(SMALLINT, @pLabelsToMatch)
   AND (@pIncludeInPublicSite=0 OR p.IncludeInPublicSite=1)
   AND (@pIncludeInVideoLibrary=0 OR p.IncludeInVideoLibrary=1)

  
  
