IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolLabelGroups') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolLabelGroups.'
      DROP PROCEDURE dbo.GetTrainingProtocolLabelGroups
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolLabelGroups.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolLabelGroups
AS

SET NOCOUNT ON 

SELECT TrainingProtocolLabelGroupID
      ,Name
  FROM dbo.SETrainingProtocolLabelGroup
  
  
