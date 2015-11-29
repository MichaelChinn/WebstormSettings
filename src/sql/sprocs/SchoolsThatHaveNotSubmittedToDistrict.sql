IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.SchoolsThatHaveNotSubmittedToDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SchoolsThatHaveNotSubmittedToDistrict.'
      DROP PROCEDURE dbo.SchoolsThatHaveNotSubmittedToDistrict
   END
GO
PRINT '.. Creating sproc SchoolsThatHaveNotSubmittedToDistrict.'
GO

CREATE PROCEDURE dbo.SchoolsThatHaveNotSubmittedToDistrict
	@pDistrictCode VARCHAR(20)
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 


SELECT s.SchoolName
  FROM dbo.vSchoolName s
  JOIN dbo.SESchoolConfiguration sc
	ON s.SchoolCode=sc.SchoolCode
 WHERE sc.HasBeenSubmittedToDistrictTE=0
   AND sc.DistrictCode=@pDistrictCode
   AND sc.SchoolYear=@pSchoolYear
 ORDER BY s.SchoolName
