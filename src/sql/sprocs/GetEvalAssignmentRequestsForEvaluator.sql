IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalAssignmentRequestsForEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalAssignmentRequestsForEvaluator.'
      DROP PROCEDURE dbo.GetEvalAssignmentRequestsForEvaluator
   END
GO
PRINT '.. Creating sproc GetEvalAssignmentRequestsForEvaluator.'
GO

CREATE PROCEDURE dbo.GetEvalAssignmentRequestsForEvaluator
	@pEvaluatorId	BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON  
  
SELECT * 
  FROM dbo.vEvalAssignmentRequest
 WHERE EvaluatorID=@pEvaluatorID
   AND DistrictCode=@pDistrictCode
   AND SchoolYear=@pSchoolYear
   

