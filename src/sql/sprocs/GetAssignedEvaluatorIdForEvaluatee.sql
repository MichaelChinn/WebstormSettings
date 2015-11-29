IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAssignedEvaluatorIdForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAssignedEvaluatorIdForEvaluatee.'
      DROP PROCEDURE dbo.GetAssignedEvaluatorIdForEvaluatee
   END
GO
PRINT '.. Creating sproc GetAssignedEvaluatorIdForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetAssignedEvaluatorIdForEvaluatee
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
	,@pEvaluateeID BIGINT
AS

SET NOCOUNT ON  
  

SELECT ISNULL(e.EvaluatorID, -1) AS EvaluatorID
  FROM dbo.vEvaluation e
  JOIN dbo.SEUser u ON e.EvaluateeID=u.SEUserID
  JOIN dbo.aspnet_UsersInRoles ur ON u.aspnetUserID=ur.UserID
  JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
 WHERE e.EvaluateeID=@pEvaluateeID
   AND e.DistrictCode=@pDistrictCode
   AND (@pSchoolYear IS NULL OR e.SchoolYear=@pSchoolYear)
   AND r.RoleName IN ('SESchoolPrincipal', 'SESchoolTeacher')
   AND ((r.RoleName='SESchoolPrincipal' AND  e.EvaluationTypeID=1) OR
        (r.RoleName='SESchoolTeacher' AND e.EvaluationTypeID=2))

