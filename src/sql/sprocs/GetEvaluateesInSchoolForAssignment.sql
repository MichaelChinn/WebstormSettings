IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateesInSchoolForAssignment') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateesInSchoolForAssignment.'
      DROP PROCEDURE dbo.GetEvaluateesInSchoolForAssignment
   END
GO
PRINT '.. Creating sproc GetEvaluateesInSchoolForAssignment.'
GO

CREATE PROCEDURE dbo.GetEvaluateesInSchoolForAssignment
	@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pRoleName VARCHAR(50)
AS

SET NOCOUNT ON 

IF (@pRoleName='SESchoolTeacher')
BEGIN

SELECT u.*
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
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=2 AND e.EvaluateeID=u.SEUserID)
 WHERE r.RoleName=@pRoleName
   AND uds.SchoolCode=@pSchoolCode
   AND u.SEUserID NOT IN
	   (SELECT EvaluateeID
		  FROM dbo.SEEvalAssignmentRequest
		 WHERE Status=2 -- Accepted
		   AND RequestTypeID=2 -- Assigned Evaluator
		   AND SchoolYear=@pSchoolYear
		   AND DistrictCode=@pDistrictCode
		   )
  -- filter out teachers that are in more than one school
  -- they are assigned in a different place
  AND u.SEUserID NOT IN
	   (SELECT uds.SEUserID
	      FROM dbo.SEUserDistrictSchool uds
	     WHERE uds.DistrictCode=@pDistrictCode
	      GROUP BY uds.SEUserID
	      HAVING COUNT(uds.SEUserID) > 1)
 ORDER BY u.LastName, u.FirstName
 
 END
 ELSE
 BEGIN
 
  -- only get principals that are not head principals
 SELECT u.*
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
 WHERE r.RoleName=@pRoleName
 /*
   AND u.SEUserID NOT IN
	   (SELECT u.SEUserID
	      FROM dbo.SEUser u
	      JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserID
	      JOIN dbo.aspnet_Roles r on ur.RoleID=r.RoleID
	     WHERE u.SchoolCode=@pSchoolCode
	       AND r.RoleName='SEPrincipalEvaluator')
*/
   AND uds.SchoolCode=@pSchoolCode
 ORDER BY u.LastName, u.FirstName


 END


