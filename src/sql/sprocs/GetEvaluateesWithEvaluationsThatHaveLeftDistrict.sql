IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateesWithEvaluationsThatHaveLeftDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateesWithEvaluationsThatHaveLeftDistrict.'
      DROP PROCEDURE dbo.GetEvaluateesWithEvaluationsThatHaveLeftDistrict
   END
GO
PRINT '.. Creating sproc GetEvaluateesWithEvaluationsThatHaveLeftDistrict.'
GO

CREATE PROCEDURE dbo.GetEvaluateesWithEvaluationsThatHaveLeftDistrict
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
	,@pEvaluationTypeID SMALLINT
AS

SET NOCOUNT ON 

SELECT DISTINCT u.* 
  FROM dbo.vSEUser u
  LEFT OUTER JOIN dbo.SEUserDistrictSchool uds ON u.SEUserID=uds.SEUserID
  JOIN dbo.SEEvaluation e
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=@pEvaluationTypeID AND e.EvaluateeID=u.SEUserID)
 WHERE (uds.DistrictCode IS NULL OR uds.DistrictCode<>@pDistrictCode)
 ORDER BY u.LastName, u.FirstName
