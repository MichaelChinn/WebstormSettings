IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDTEEvaluateesForAssignedEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDTEEvaluateesForAssignedEvaluator.'
      DROP PROCEDURE dbo.GetDTEEvaluateesForAssignedEvaluator
   END
GO
PRINT '.. Creating sproc GetDTEEvaluateesForAssignedEvaluator.'
GO

CREATE PROCEDURE dbo.GetDTEEvaluateesForAssignedEvaluator
	@pEvaluatorID BIGINT
	,@pSchoolYear SMALLINT
	,@pSubmittedOnly BIT = 0
	,@pRequestType SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT u.*
  FROM dbo.vSEUser u
  JOIN dbo.SEEvalAssignmentRequest e
    ON e.EvaluateeID=u.SEUserID
  JOIN dbo.SEEvaluation eval
    ON u.SEUserID=eval.EvaluateeID
 WHERE e.EvaluatorID=@pEvaluatorID
   AND eval.EvaluatorID=@pEvaluatorID
   AND e.SchoolYear=@pSchoolYear
   AND e.DistrictCode=@pDistrictCode
   AND e.Status=2 -- Accepted
   AND e.RequestTypeID=@pRequestType
   AND (@pSubmitted=0 OR eval.HasBeenSubmitted)
   AND eval.EvaluateeID=e.EvaluateeID
   AND eval.SchoolYear=@pSchoolYear
   AND eval.DistrictCode=@pDistrictCode
 ORDER BY u.LastName, u.FirstName
 
 /*
 select * from seevalassignmentrequeststatustype
 select * from seevalassignmentrequesttype
 */


