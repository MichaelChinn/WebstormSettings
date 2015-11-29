IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolById.'
      DROP PROCEDURE dbo.GetTrainingProtocolById
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolById.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolById
	@pProtocolID BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vTrainingProtocol
 WHERE TrainingProtocolID=@pProtocolID
