IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluationDataForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationDataForEvaluatee.'
      DROP PROCEDURE dbo.GetEvaluationDataForEvaluatee
   END
GO
PRINT '.. Creating sproc GetEvaluationDataForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetEvaluationDataForEvaluatee
	@pEvaluateeId	BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT = NULL
	,@pRequireRoles BIT = 0
AS

SET NOCOUNT ON 


IF (@pRequireRoles=0)
BEGIN

SELECT e.* 
  FROM dbo.vEvaluation e
  JOIN dbo.SEUser u ON e.EvaluateeID=u.SEUserID
 WHERE e.EvaluateeID=@pEvaluateeID
   AND e.DistrictCode=@pDistrictCode
   AND (@pSchoolYear IS NULL OR e.SchoolYear=@pSchoolYear)
END
ELSE
BEGIN

SELECT e.* 
  FROM dbo.vEvaluation e
  JOIN dbo.SEUser u ON e.EvaluateeID=u.SEUserID
  LEFT OUTER JOIN dbo.aspnet_UsersInRoles ur ON u.aspnetUserID=ur.UserID
  LEFT OUTER JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
 WHERE e.EvaluateeID=@pEvaluateeID
   AND e.DistrictCode=@pDistrictCode
   AND (@pSchoolYear IS NULL OR e.SchoolYear=@pSchoolYear)
   AND (r.RoleName IN ('SESchoolPrincipal', 'SESchoolTeacher')
   AND ((r.RoleName='SESchoolPrincipal' AND  e.EvaluationTypeID=1) OR
		(r.RoleName='SESchoolTeacher' AND e.EvaluationTypeID=2)))
			
END
   

