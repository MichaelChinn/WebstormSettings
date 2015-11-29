IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.HaveAllEvaluationsBeenSubmittedToStateTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc HaveAllEvaluationsBeenSubmittedToStateTE.'
      DROP PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToStateTE
   END
GO
PRINT '.. Creating sproc HaveAllEvaluationsBeenSubmittedToStateTE.'
GO

CREATE PROCEDURE dbo.HaveAllEvaluationsBeenSubmittedToStateTE(
					@pSchoolYear SMALLINT)
AS

SET NOCOUNT ON 

IF EXISTS (SELECT DistrictConfigurationID
      FROM dbo.SEDistrictConfiguration
     WHERE HasBeenSubmittedToStateTE=0
       AND SchoolYear=@pSchoolYear
       AND EvaluationTYpeID=2)
BEGIN
	SELECT Result=0
END
ELSE
BEGIN
	SELECT Result=1
END

