IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPublicSiteTrainingProtocolsWithLabels') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPublicSiteTrainingProtocolsWithLabels.'
      DROP PROCEDURE dbo.GetPublicSiteTrainingProtocolsWithLabels
   END
GO
PRINT '.. Creating sproc GetPublicSiteTrainingProtocolsWithLabels.'
GO

CREATE PROCEDURE dbo.GetPublicSiteTrainingProtocolsWithLabels
	@pLabelsToMatch VARCHAR(MAX)

AS

SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vTrainingProtocol p
  JOIN dbo.SETrainingProtocolLabelAssignment ma ON p.TrainingProtocolID=ma.TrainingProtocolID
  JOIN dbo.SETrainingProtocolLabel l on ma.TrainingProtocolLabelID=l.TrainingProtocolLabelID
 WHERE l.TrainingProtocolLabelID=CONVERT(SMALLINT, @pLabelsToMatch)
   AND p.IncludeInPublicSite=1

  
  
