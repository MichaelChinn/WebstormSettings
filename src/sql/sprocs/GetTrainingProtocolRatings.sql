IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolRatings') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolRatings.'
      DROP PROCEDURE dbo.GetTrainingProtocolRatings
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolRatings.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolRatings
   @pProtocolID BIGINT = NULL
   ,@pIsAnnonymous BIT = NULL
   ,@pStatus SMALLINT = NULL
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vTrainingProtocolRating
 WHERE (@pProtocolID IS NULL OR TrainingProtocolID=@pProtocolID)
   AND (@pIsAnnonymous IS NULL OR IsAnnonymous=@pIsAnnonymous)
   AND (@pStatus IS NULL OR Status=@pStatus)
 ORDER BY TrainingProtocolRatingID DESC
  
  
