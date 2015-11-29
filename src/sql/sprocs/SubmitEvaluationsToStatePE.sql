IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.SubmitEvaluationsToStatePE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SubmitEvaluationsToStatePE.'
      DROP PROCEDURE dbo.SubmitEvaluationsToStatePE
   END
GO
PRINT '.. Creating sproc SubmitEvaluationsToStatePE.'
GO

CREATE PROCEDURE dbo.SubmitEvaluationsToStatePE
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

UPDATE SEDistrictConfiguration 
   SET HasBeenSubmittedToStatePE=1
	  ,SubmissionToStateDatePE=getdate()
 WHERE DistrictCode=@pDistrictCode
   AND EvaluationTypeID=1
   AND SchoolYear=@pSchoolYear
