IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPotentialCalibrationParticipants') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPotentialCalibrationParticipants.'
      DROP PROCEDURE dbo.GetPotentialCalibrationParticipants
   END
GO
PRINT '.. Creating sproc GetPotentialCalibrationParticipants.'
GO

CREATE PROCEDURE dbo.GetPotentialCalibrationParticipants
	 @pAnchorSessionID BIGINT
	,@pEntityCode varchar (20) = ''
	,@pLastNameSearch VARCHAR(100)
	,@pDebug bit = 0
	,@pSearchType smallint = 0		-- 0 is search through everyone
									-- 1 is search through district
									-- 2 is search through school
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

if (@pDebug=1)
	select @lastNameMatch, @pEntityCode

CREATE TABLE dbo.#User(SEUserID BIGINT)

if (@pSearchType = 2)  -- search through school only
BEGIN

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
		 WHERE r.RoleName IN ('SESchoolTeacher', 'SESchoolPrincipal', 'SEPracticeParticipantGuest')
		   and uds.schoolCode = @pEntityCode
		   AND u.LastName LIKE @LastNameMatch
END
else if (@pSearchType = 1)  -- search through district only
BEGIN

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
		 WHERE r.RoleName IN ('SESchoolTeacher', 'SESchoolPrincipal', 'SETeacherEvaluator', 'SEDistrictEvaluator', 'SEPracticeParticipantGuest')
		   and uds.districtCode = @pEntityCode
		   AND u.LastName LIKE @LastNameMatch
END
ELSE						-- either not specified or some out of range value; search through everyone
BEGIN

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
		 WHERE r.RoleName IN ('SESchoolTeacher', 'SESchoolPrincipal', 'SETeacherEvaluator', 'SEDistrictEvaluator', 'SEPracticeParticipantGuest')
		   AND u.LastName LIKE @LastNameMatch
END


SELECT u.* 
  FROM dbo.vSEUser u
  JOIN dbo.#User u2
	ON u.SEUserID=u2.SEUserID
 WHERE u.SEUserID NOT IN
	   (SELECT EvaluatorUserID
		  FROM dbo.SEEvalSession s
		 WHERE AnchorSessionID=@pAnchorSessionID)

 ORDER BY u.LastName, u.FirstName




