IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTeachersInMultipleSchoolsForAssignment') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTeachersInMultipleSchoolsForAssignment.'
      DROP PROCEDURE dbo.GetTeachersInMultipleSchoolsForAssignment
   END
GO
PRINT '.. Creating sproc GetTeachersInMultipleSchoolsForAssignment.'
GO

CREATE PROCEDURE dbo.GetTeachersInMultipleSchoolsForAssignment
	 @pDistrictCode	VARCHAR(20)
	 ,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

          
SELECT u.* 
  FROM dbo.vSEUser u (NOLOCK)
  JOIN dbo.aspnet_Users netu (NOLOCK)
    ON u.aspnetUserID=netu.UserID
  JOIN dbo.aspnet_UsersInRoles ur (NOLOCK)
    ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r (NOLOCK)
    ON ur.RoleID=r.RoleID
  JOIN dbo.SEEvaluation e (NOLOCK)
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=2 AND e.EvaluateeID=u.SEUserID)
  JOIN (SELECT DISTINCT SEUserID
          FROM dbo.SEUserDistrictSchool uds
          GROUP BY SEUserID
          HAVING COUNT(*) > 1) x ON u.SEUserID=x.SEUserID		  
 WHERE r.RoleName='SESchoolTeacher'
   AND u.DistrictCode=@pDistrictCode
   -- filter out teachers that have already been assigned to
   -- a district-wide evaluator
   AND u.SEUserID NOT IN
	   (SELECT EvaluateeID
		  FROM dbo.SEEvalAssignmentRequest (NOLOCK)
		 WHERE Status=2 -- Accepted
		   AND RequestTypeID=2 -- Assigned Evaluator
		   AND SchoolYear=@pSchoolYear
		   AND DistrictCode=@pDistrictCode
		   )

 ORDER BY u.LastName, u.FirstName

