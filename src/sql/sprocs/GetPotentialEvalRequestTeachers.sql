IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPotentialEvalRequestTeachers') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPotentialEvalRequestTeachers.'
      DROP PROCEDURE dbo.GetPotentialEvalRequestTeachers
   END
GO
PRINT '.. Creating sproc GetPotentialEvalRequestTeachers.'
GO

CREATE PROCEDURE dbo.GetPotentialEvalRequestTeachers
	 @pEvaluatorId BIGINT
	,@pDistrictCode VARCHAR(100)
	,@pLastNameSearch VARCHAR(100)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

DECLARE @LastNameMatch VARCHAR(100), @FirstNameMatch VARCHAR(100)
IF (@pLastNameSearch = '')
BEGIN
	SELECT @LastNameMatch = '%'
END
ELSE
BEGIN
	SELECT @LastNameMatch = @pLastNameSearch + '%'
END

CREATE TABLE dbo.#User(SEUserID BIGINT)

INSERT INTO dbo.#User(SEUserID)
SELECT DISTINCT u.SEUserID
  FROM dbo.SEUser u
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
 WHERE r.RoleName IN ('SESchoolTeacher')
   and uds.DistrictCOde = u.DistrictCode
   AND u.LastName LIKE @LastNameMatch
   AND u.DistrictCode=@pDistrictCode

SELECT u.* 
  FROM dbo.vSEUser u
  JOIN dbo.#User u2
	ON u.SEUserID=u2.SEUserID
 WHERE u.SEUserID NOT IN
	   (SELECT EvaluateeID
		  FROM dbo.SEEvalAssignmentRequest r
		 WHERE EvaluatorId=@pEvaluatorId
		   AND SchoolYear=@pSchoolYear
		   AND DistrictCode=@pDistrictCode)
 ORDER BY u.LastName, u.FirstName




