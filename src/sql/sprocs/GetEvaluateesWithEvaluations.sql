IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateesWithEvaluations') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateesWithEvaluations.'
      DROP PROCEDURE dbo.GetEvaluateesWithEvaluations
   END
GO
PRINT '.. Creating sproc GetEvaluateesWithEvaluations.'
GO

CREATE PROCEDURE dbo.GetEvaluateesWithEvaluations
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
	,@pEvaluationTypeID SMALLINT
AS

SET NOCOUNT ON 

SELECT DISTINCT u.* 
  FROM dbo.vSEUser u
  JOIN dbo.SEUserDistrictSchool uds ON u.SEUserID=uds.SEUserID
  JOIN dbo.SEEvaluation e
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=@pEvaluationTypeID AND e.EvaluateeID=u.SEUserID)
 WHERE uds.DistrictCode=@pDistrictCode
 ORDER BY u.LastName, u.FirstName

