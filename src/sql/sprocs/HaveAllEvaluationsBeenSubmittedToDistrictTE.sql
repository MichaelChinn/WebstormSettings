IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.HaveAllEvaluationsBeenSubmittedToDistrictTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc HaveAllEvaluationsBeenSubmittedToDistrictTE.'
      DROP PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToDistrictTE
   END
GO
PRINT '.. Creating sproc HaveAllEvaluationsBeenSubmittedToDistrictTE.'
GO

CREATE PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToDistrictTE
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

IF EXISTS (SELECT SchoolConfigurationID
      FROM dbo.SESchoolConfiguration
     WHERE HasBeenSubmittedToDistrictTE=0
       AND DistrictCode=@pDistrictCode
       AND SchoolYear=@pSchoolYear)
BEGIN
	SELECT Result=0
END
ELSE
BEGIN
	SELECT Result=1
END

