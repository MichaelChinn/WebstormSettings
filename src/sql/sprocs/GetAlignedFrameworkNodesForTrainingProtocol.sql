IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedFrameworkNodesForTrainingProtocol') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedFrameworkNodesForTrainingProtocol.'
      DROP PROCEDURE dbo.GetAlignedFrameworkNodesForTrainingProtocol
   END
GO
PRINT '.. Creating sproc GetAlignedFrameworkNodesForTrainingProtocol.'
GO

CREATE PROCEDURE dbo.GetAlignedFrameworkNodesForTrainingProtocol
	@pProtocolID BIGINT
	,@pIsStateAligned BIT
AS

SET NOCOUNT ON 

SELECT DISTINCT fn.*
  FROM dbo.SETrainingProtocolFrameworkNodeAlignment fna
  JOIN dbo.SEFrameworkNode fn on fna.FrameworkNodeID=fn.FrameworkNodeID
 WHERE TrainingProtocolID=@pProtocolID
   AND fna.IsStateAlignment=@pIsStateAligned
