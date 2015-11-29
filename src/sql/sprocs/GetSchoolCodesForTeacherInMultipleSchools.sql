IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSchoolCodesForTeacherInMultipleSchools') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolCodesForTeacherInMultipleSchools.'
      DROP PROCEDURE dbo.GetSchoolCodesForTeacherInMultipleSchools
   END
GO
PRINT '.. Creating sproc GetSchoolCodesForTeacherInMultipleSchools.'
GO

CREATE PROCEDURE dbo.GetSchoolCodesForTeacherInMultipleSchools
	 @pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT uds.SchoolCode
  FROM dbo.SEUserDistrictSchool uds
  WHERE uds.SEUserID=@pUserID
