IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictWideTeacherEvaluatorsToImpersonateForDistrictViewer') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictWideTeacherEvaluatorsToImpersonateForDistrictViewer.'
      DROP PROCEDURE dbo.GetDistrictWideTeacherEvaluatorsToImpersonateForDistrictViewer
   END
GO
PRINT '.. Creating sproc GetDistrictWideTeacherEvaluatorsToImpersonateForDistrictViewer.'
GO

CREATE PROCEDURE dbo.GetDistrictWideTeacherEvaluatorsToImpersonateForDistrictViewer
	@pDistrictCode	VARCHAR(20)
	,@pSchoolYear	SMALLINT
	,@pDistrictUserID BIGINT
AS

SET NOCOUNT ON 

SELECT u_tor.*
  FROM dbo.SEEvalAssignmentRequest r
  JOIN dbo.vSEUser u_tor
	ON r.EvaluatorID=u_tor.SEUserID
  JOIN dbo.SEUser u_tee
    ON r.EvaluateeID=u_tee.SEUserID
  JOIN SEDistrictPRViewing v
    ON u_tee.SchoolCode=v.SchoolCode
   JOIN dbo.SEDistrictSchool ds
    ON ds.SchoolCode=u_tee.SchoolCode AND ds.IsSchool=1
 WHERE u_tor.DistrictCode=@pDistrictCode
   AND r.SchoolYear=@pSchoolYear
   AND r.DistrictCode=@pDistrictCode
   AND r.DistrictCode=u_tor.DistrictCode
   AND r.Status = 2 -- Accepted 
 ORDER BY ds.DistrictSchoolName, u_tor.LastName, u_tor.FirstName


