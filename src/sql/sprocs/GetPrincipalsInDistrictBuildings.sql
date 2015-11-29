IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPrincipalsInDistrictBuildings') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPrincipalsInDistrictBuildings.'
      DROP PROCEDURE dbo.GetPrincipalsInDistrictBuildings
   END
GO
PRINT '.. Creating sproc GetPrincipalsInDistrictBuildings.'
GO

CREATE PROCEDURE dbo.GetPrincipalsInDistrictBuildings
	 @pDistrictCode	VARCHAR(20)
	,@pSchoolYear	SMALLINT
	 ,@pAssignedOnly BIT = 0
	 ,@pSubmissionRetrievalType SMALLINT
	 ,@pEvaluatorID BIGINT = NULL
	 ,@pWfStateID BIGINT = 0
AS

SET NOCOUNT ON 

SELECT DISTINCT u.* 
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
  JOIN dbo.aspnet_UsersInRoles ur
    ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r
    ON ur.RoleID=r.RoleID
  JOIN dbo.SEUserDistrictSchool uds
	ON u.SEUserID=uds.SEUserID
  JOIN dbo.SEEvaluation e
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=1 AND e.EvaluateeID=u.SEUserID)
 WHERE r.RoleName='SESchoolPrincipal'
   AND uds.DistrictCode=@pDistrictCode
   AND uds.SchoolCode<>''
   AND (@pAssignedOnly = 0 OR (e.EvaluatorID=@pEvaluatorID))
   AND (@pSubmissionRetrievalType = 3 OR (@pSubmissionRetrievalType = 1 AND e.HasBeenSubmitted=1) OR (@pSubmissionRetrievalType = 2 AND e.HasBeenSubmitted=0))
   AND (@pWfStateID=0 OR e.WfStateID=@pWfStateID)
 ORDER BY u.SchoolName, u.LastName, u.FirstName

