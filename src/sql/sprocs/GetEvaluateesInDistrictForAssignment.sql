IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateesInDistrictForAssignment') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateesInDistrictForAssignment.'
      DROP PROCEDURE dbo.GetEvaluateesInDistrictForAssignment
   END
GO
PRINT '.. Creating sproc GetEvaluateesInDistrictForAssignment.'
GO

CREATE PROCEDURE dbo.GetEvaluateesInDistrictForAssignment
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT DISTINCT u.*
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
	ON u.aspnetUserID=netu.UserID
  JOIN dbo.SEUserDistrictSchool uds
	ON u.SEUserID=uds.SEUserID
  JOIN dbo.aspnet_UsersInRoles ur
	ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r
	ON ur.RoleID=r.RoleID
  JOIN dbo.SEEvaluation e
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=1 AND e.EvaluateeID=u.SEUserID)
 WHERE r.RoleName='SESchoolPrincipal'
   AND uds.DistrictCode=@pDistrictCode
   -- filter out principals that already have a head principal assigned as their evaluator
   AND u.SEUserID NOT IN
	   (SELECT tee.SEUserID
	      FROM dbo.SEUser tee
	      JOIN dbo.SEEvaluation e ON tee.SEUserID=e.EvaluateeID
	      JOIN dbo.SEUser tor ON tor.SEUserID=e.EvaluatorID
	      JOIN dbo.aspnet_UsersInRoles ur ON tor.ASPNetUserID=ur.UserID
	      JOIN dbo.aspnet_Roles r on ur.ROleID=r.RoleID
	     WHERE r.RoleName='SEPrincipalEvaluator'
	       AND e.SchoolYear=@pSchoolYear
	       AND tor.DistrictCode=@pDistrictCode
	       AND e.DistrictCode=@pDistrictCode
	       AND tor.SchoolCode<>'')
 ORDER BY u.LastName, u.FirstName


