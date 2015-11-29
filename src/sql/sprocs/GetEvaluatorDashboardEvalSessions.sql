IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvaluatorDashboardEvalSessions') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluatorDashboardEvalSessions.'
      DROP PROCEDURE dbo.GetEvaluatorDashboardEvalSessions
   END
GO
PRINT '.. Creating sproc GetEvaluatorDashboardEvalSessions.'
GO

CREATE PROCEDURE dbo.GetEvaluatorDashboardEvalSessions
	 @pEvaluatorUserId	BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

IF (@pDistrictCode = '17001')
BEGIN
SELECT es.* 
  FROM dbo.vEvalSessionStatus es
 WHERE es.EvaluatorUserID=@pEvaluatorUserID
   AND es.EvaluationScoreTypeID=1 -- Standard
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND es.SchoolYear = @pSchoolYear
   AND es.DistrictCode = @pDistrictCode
   AND es.IsSelfAssess=0
 ORDER BY es.EvaluatorUserID
         ,es.SessionKey ASC
 END
 ELSE
 BEGIN
 SELECT es.* 
  FROM dbo.vEvalSessionStatus es
 WHERE es.EvaluatorUserID=@pEvaluatorUserID
   AND es.EvaluationScoreTypeID=1 -- Standard
   AND es.EvaluationTypeID=@pEvaluationTypeID
   AND es.SchoolYear = @pSchoolYear
   AND es.DistrictCode = @pDistrictCode
   AND es.IsSelfAssess=0
 ORDER BY es.EvaluatorUserID
         ,es.ObserveStartTime ASC
 END





