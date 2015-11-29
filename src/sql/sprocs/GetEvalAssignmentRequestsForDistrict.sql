IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalAssignmentRequestsForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalAssignmentRequestsForDistrict.'
      DROP PROCEDURE dbo.GetEvalAssignmentRequestsForDistrict
   END
GO
PRINT '.. Creating sproc GetEvalAssignmentRequestsForDistrict.'
GO

CREATE PROCEDURE dbo.GetEvalAssignmentRequestsForDistrict
	@pDistrictCode VARCHAR(20)
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
 WHERE request.DistrictCode=@pDistrictCode
   AND request.SchoolYear=@pSchoolYear
   AND r.RoleName='SESchoolTeacher'
 ORDER BY request.EvaluateeDisplayName
   

