IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.SubmitEvaluationsToDistrictTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SubmitEvaluationsToDistrictTE.'
      DROP PROCEDURE dbo.SubmitEvaluationsToDistrictTE
   END
GO
PRINT '.. Creating sproc SubmitEvaluationsToDistrictTE.'
GO

CREATE PROCEDURE dbo.SubmitEvaluationsToDistrictTE
	@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

UPDATE SESchoolConfiguration 
   SET HasBeenSubmittedToDistrictTE=1
	  ,SubmissionToDistrictDateTE=getdate()
 WHERE SchoolCode=@pSchoolCode
   AND SchoolYear=@pSchoolYear
