IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAnchorSessionsForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAnchorSessionsForDistrict.'
      DROP PROCEDURE dbo.GetAnchorSessionsForDistrict
   END
GO
PRINT '.. Creating sproc GetAnchorSessionsForDistrict.'
GO

CREATE PROCEDURE dbo.GetAnchorSessionsForDistrict
	@pDistrictCode VARCHAR(20),
	@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT s.*
  FROM vEvalSession s
  JOIN dbo.SEDistrictTrainingProtocolAnchor a ON s.EvalSessionID=a.EvalSessionID
 WHERE a.DistrictCode=@pDistrictCode
   AND a.SchoolYear=@pSchoolYear
   
