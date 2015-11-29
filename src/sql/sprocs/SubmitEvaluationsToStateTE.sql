IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.SubmitEvaluationsToStateTE') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SubmitEvaluationsToStateTE.'
      DROP PROCEDURE dbo.SubmitEvaluationsToStateTE
   END
GO
PRINT '.. Creating sproc SubmitEvaluationsToStateTE.'
GO

CREATE PROCEDURE dbo.SubmitEvaluationsToStateTE
	@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

UPDATE SEDistrictConfiguration 
   SET HasBeenSubmittedToStateTE=1
	  ,SubmissionToStateDateTE=getdate()
 WHERE DistrictCode=@pDistrictCode
   AND SchoolYear=@pSchoolYear
