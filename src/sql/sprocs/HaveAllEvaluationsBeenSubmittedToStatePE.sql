IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.HaveAllEvaluationsBeenSubmittedToStatePE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc HaveAllEvaluationsBeenSubmittedToStatePE.'
      DROP PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToStatePE
   END
GO
PRINT '.. Creating sproc HaveAllEvaluationsBeenSubmittedToStatePE.'
GO

CREATE PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToStatePE(
	@pSchoolYear SMALLINT
	)
AS

SET NOCOUNT ON 

IF EXISTS (SELECT DistrictConfigurationID
      FROM dbo.SEDistrictConfiguration
     WHERE HasBeenSubmittedToStatePE=0
       AND EvaluationTypeID=1
       AND SchoolYear=@pSchoolYear)
BEGIN
	SELECT Result=0
END
ELSE
BEGIN
	SELECT Result=1
END

