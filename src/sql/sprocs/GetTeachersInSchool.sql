IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTeachersInSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTeachersInSchool.'
      DROP PROCEDURE dbo.GetTeachersInSchool
   END
GO
PRINT '.. Creating sproc GetTeachersInSchool.'
GO

CREATE PROCEDURE dbo.GetTeachersInSchool
	  @pSchoolCode	VARCHAR(20)
	 ,@pDistrictCode VARCHAR(20)
	 ,@pSchoolYear	SMALLINT
	 ,@pAssignedOnly BIT = 0
	 ,@pSubmissionRetrievalType SMALLINT
	 ,@pEvaluatorID BIGINT = NULL
	 ,@pWfStateID BIGINT = 0
AS

SET NOCOUNT ON 


SELECT u.* 
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
    ON (e.DistrictCode=@pDistrictCode AND e.SchoolYear=@pSchoolYear AND e.EvaluationTypeID=2 AND e.EvaluateeID=u.SEUserID)
 WHERE r.RoleName='SESchoolTeacher'
   AND (@pAssignedOnly = 0 OR (e.EvaluatorID=@pEvaluatorID))
   AND (@pSubmissionRetrievalType = 3 OR (@pSubmissionRetrievalType = 1 AND e.HasBeenSubmitted=1) OR (@pSubmissionRetrievalType = 2 AND e.HasBeenSubmitted=0))
   AND uds.SchoolCode=@pSchoolCode
   AND (@pWfStateID=0 OR e.WfStateID=@pWfStateID)
 ORDER BY u.LastName, u.FirstName
