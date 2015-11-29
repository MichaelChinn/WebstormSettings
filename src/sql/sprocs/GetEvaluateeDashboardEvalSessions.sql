IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluateeDashboardEvalSessions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluateeDashboardEvalSessions.'
      DROP PROCEDURE dbo.GetEvaluateeDashboardEvalSessions
   END
GO
PRINT '.. Creating sproc GetEvaluateeDashboardEvalSessions.'
GO

CREATE PROCEDURE dbo.GetEvaluateeDashboardEvalSessions
	 @pEvaluateeUserId	BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

IF (@pDistrictCode = '17001')
BEGIN
SELECT es.* 
  FROM dbo.vEvalSessionStatus es
 WHERE es.EvaluateeUserID=@pEvaluateeUserID
   AND es.EvaluationScoreTypeID=1 -- Standard
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND es.SchoolYear = @pSchoolYear
   AND es.DistrictCode = @pDistrictCode
   AND es.IsSelfAssess=0
   AND (es.ObserveIsPublic=1 OR es.PreConfIsPublic=1 OR es.PostConfIsPublic=1)
 ORDER BY es.SessionKey ASC
 END
 ELSE
 BEGIN
 
 SELECT es.* 
  FROM dbo.vEvalSessionStatus es
 WHERE es.EvaluateeUserID=@pEvaluateeUserID
   AND es.EvaluationScoreTypeID=1 -- Standard
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND es.SchoolYear = @pSchoolYear
   AND es.DistrictCode = @pDistrictCode
   AND es.IsSelfAssess=0
   AND (es.ObserveIsPublic=1 OR es.PreConfIsPublic=1 OR es.PostConfIsPublic=1)
 ORDER BY es.ObserveStartTime ASC
 
 END





