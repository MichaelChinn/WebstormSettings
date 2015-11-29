IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictConfiguration') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictConfiguration.'
      DROP PROCEDURE dbo.GetDistrictConfiguration
   END
GO
PRINT '.. Creating sproc GetDistrictConfiguration.'
GO

CREATE PROCEDURE dbo.GetDistrictConfiguration
	@pDistrictCode VARCHAR(20)
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vDistrictConfiguration
 WHERE DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID
   AND SchoolYear=@pSchoolYear






