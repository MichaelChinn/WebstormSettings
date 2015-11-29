IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolLabelsForTrainingProtocol') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolLabelsForTrainingProtocol.'
      DROP PROCEDURE dbo.GetTrainingProtocolLabelsForTrainingProtocol
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolLabelsForTrainingProtocol.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolLabelsForTrainingProtocol
   @pProtocolID BIGINT
  ,@pGroupID BIGINT = NULL
AS

SET NOCOUNT ON 

SELECT l.TrainingProtocolLabelID
	  ,l.TrainingProtocolLabelGroupID
      ,l.Name
  FROM dbo.SETrainingProtocolLabel l
  JOIN dbo.SETrainingProtocolLabelAssignment la ON l.TrainingProtocolLabelID=la.TrainingProtocolLabelID
 WHERE (@pGroupID IS NULL OR TrainingProtocolLabelGroupID=@pGroupID)
   AND la.TrainingProtocolID=@pProtocolID
 ORDER BY Sequence
  
  
