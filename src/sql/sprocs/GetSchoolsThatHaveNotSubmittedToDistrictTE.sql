IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSchoolsThatHaveNotSubmittedToDistrictTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSchoolsThatHaveNotSubmittedToDistrictTE.'
      DROP PROCEDURE dbo.GetSchoolsThatHaveNotSubmittedToDistrictTE
   END
GO
PRINT '.. Creating sproc GetSchoolsThatHaveNotSubmittedToDistrictTE.'
GO

CREATE PROCEDURE dbo.GetSchoolsThatHaveNotSubmittedToDistrictTE
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 


SELECT s.SchoolName, s.schoolCode
  FROM dbo.vSchoolName s
  JOIN dbo.SESchoolConfiguration sc
	ON s.SchoolCode=sc.SchoolCode
 WHERE sc.HasBeenSubmittedToDistrictTE=0
   AND sc.DistrictCode=@pDistrictCode
   AND sc.SchoolYear=@pSchoolYear
 ORDER BY s.SchoolName
