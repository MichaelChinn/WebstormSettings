IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateesForDTEEvaluator') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateesForDTEEvaluator.'
      DROP PROCEDURE dbo.GetEvaluateesForDTEEvaluator
   END
GO
PRINT '.. Creating sproc GetEvaluateesForDTEEvaluator.'
GO

CREATE PROCEDURE dbo.GetEvaluateesForDTEEvaluator
	@pEvaluatorID BIGINT
	,@pSchoolYear SMALLINT
	,@pSubmissionRetrievalType SMALLINT
	,@pRequestType SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pWfStateID BIGINT = 0
AS

SET NOCOUNT ON 

SELECT u.*
  FROM dbo.vSEUser u
  JOIN dbo.aspnet_Users netu
    ON u.aspnetUserID=netu.UserID
  JOIN dbo.aspnet_UsersInRoles ur
    ON netu.UserID=ur.UserID
  JOIN dbo.aspnet_Roles r
    ON ur.RoleID=r.RoleID
  JOIN dbo.SEEvalAssignmentRequest e
    ON e.EvaluateeID=u.SEUserID
  JOIN dbo.SEEvaluation eval
    ON u.SEUserID=eval.EvaluateeID
 WHERE e.EvaluatorID=@pEvaluatorID
   AND (@pRequestType = 1 OR (e.RequestTypeID=2 AND eval.EvaluatorID=@pEvaluatorID))
   AND e.SchoolYear=@pSchoolYear
   AND e.DistrictCode=@pDistrictCode
   AND e.Status=2 -- Accepted
   AND r.RoleName='SESchoolTeacher'
   -- if it's observation_only then we return them all for the evaluator dashboard
   AND (@pRequestType = 1 OR (e.RequestTypeID=@pRequestType))
   AND (@pSubmissionRetrievalType = 3 OR (@pSubmissionRetrievalType = 1 AND eval.HasBeenSubmitted=1) OR (@pSubmissionRetrievalType = 2 AND eval.HasBeenSubmitted=0))
   AND eval.EvaluateeID=e.EvaluateeID
   AND eval.SchoolYear=@pSchoolYear
   AND eval.DistrictCode=@pDistrictCode
   AND (@pRequestType=1 OR e.EvaluatorID=@pEvaluatorID)
   AND (@pWfStateID=0 OR eval.WfStateID=@pWfStateID)
 ORDER BY u.LastName, u.FirstName
 
 /*
 select * from seevalassignmentrequeststatustype
 select * from seevalassignmentrequesttype
 */


