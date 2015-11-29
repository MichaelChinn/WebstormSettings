IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalAssignmentRequestsForSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalAssignmentRequestsForSchool.'
      DROP PROCEDURE dbo.GetEvalAssignmentRequestsForSchool
   END
GO
PRINT '.. Creating sproc GetEvalAssignmentRequestsForSchool.'
GO

CREATE PROCEDURE dbo.GetEvalAssignmentRequestsForSchool
	@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON  
  
  SELECT request.* 
  FROM dbo.vEvalAssignmentRequest request
  JOIN dbo.SEUser u ON request.EvaluateeID=u.SEUserID
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
  JOIN dbo.aspnet_UsersInRoles ur
    ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r
    ON ur.RoleID=r.RoleID
 WHERE EvaluateeSchoolCode=@pSchoolCode
   AND request.SchoolYear=@pSchoolYear
   AND r.RoleName='SESchoolTeacher'
 ORDER BY request.EvaluateeDisplayName
 
   

