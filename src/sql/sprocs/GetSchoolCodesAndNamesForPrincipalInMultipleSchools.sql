IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSchoolCodesAndNamesForPrincipalInMultipleSchools') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolCodesAndNamesForPrincipalInMultipleSchools.'
      DROP PROCEDURE dbo.GetSchoolCodesAndNamesForPrincipalInMultipleSchools
   END
GO
PRINT '.. Creating sproc GetSchoolCodesAndNamesForPrincipalInMultipleSchools.'
GO

CREATE PROCEDURE dbo.GetSchoolCodesAndNamesForPrincipalInMultipleSchools
	 @pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT uds.SchoolCode, ds.districtSchoolName
  FROM dbo.SEUserDistrictSchool uds
  JOIN dbo.SEDistrictSchool ds ON uds.DistrictCode=ds.DistrictCode AND uds.SchoolCode=ds.SchoolCode
 WHERE uds.SEUserID=@pUserID
   AND ds.isSchool=1
