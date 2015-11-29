IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolLabelsForGroup') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolLabelsForGroup.'
      DROP PROCEDURE dbo.GetTrainingProtocolLabelsForGroup
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolLabelsForGroup.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolLabelsForGroup
	@pGroupID BIGINT
AS

SET NOCOUNT ON 

SELECT TrainingProtocolLabelID
	  ,TrainingProtocolLabelGroupID
      ,Name
  FROM dbo.SETrainingProtocolLabel
 WHERE TrainingProtocolLabelGroupID=@pGroupID
 ORDER BY Sequence
  
  
