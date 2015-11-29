IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAnchorSessionForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAnchorSessionForDistrict.'
      DROP PROCEDURE dbo.GetAnchorSessionForDistrict
   END
GO
PRINT '.. Creating sproc GetAnchorSessionForDistrict.'
GO

CREATE PROCEDURE dbo.GetAnchorSessionForDistrict
	@pDistrictCode VARCHAR(20),
	@pProtocolID BIGINT,
	@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT s.*
  FROM vEvalSession s
  JOIN dbo.SEDistrictTrainingProtocolAnchor a ON s.EvalSessionID=a.EvalSessionID
 WHERE a.DistrictCode=@pDistrictCode
   AND (@pProtocolID IS NULL OR a.TrainingProtocolID=@pProtocolID)
   AND a.SchoolYear=@pSchoolYear
   
