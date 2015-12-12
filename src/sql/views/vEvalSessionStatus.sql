
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vEvalSessionStatus')
    DROP VIEW dbo.vEvalSessionStatus
GO

CREATE VIEW dbo.vEvalSessionStatus
AS 

SELECT es.EvalSessionID
	  ,es.EvaluatorUserID
	  ,es.EvaluateeUserID
	  ,es.EvaluationScoreTypeID
	  ,es.EvaluationTypeID
	  ,es.IsSelfAssess
	  ,es.Title
	  ,es.ObserveIsPublic
	  ,es.PreConfIsPublic
	  ,es.PostConfIsPublic
	  ,es.ObserveIsComplete
	  ,es.PreConfIsComplete
	  ,es.PostConfIsComplete
	  ,es.ObserveStartTime
	  ,es.PreConfStartTime
	  ,es.PostConfStartTime
	  ,es.ObserveEndTime
	  ,es.PreConfEndTime
	  ,es.PostConfEndTime
	  ,es.ObserveLocation
	  ,es.PreConfLocation
	  ,es.PostConfLocation
	  ,es.EvalSessionLockStateID
	  ,es.SchoolYear
	  ,es.DistrictCode
	  ,es.SessionKey
	  ,es.LockDateTime
	  ,es.isFormalObs
	  ,CASE 
	   WHEN (evaluator.FirstName IS NOT NULL) THEN evaluator.FirstName + ' ' + evaluator.LastName
	   ELSE ''
	   END  AS EvaluatorDisplayName
	  ,CASE 
	   WHEN (evaluatee.FirstName IS NOT NULL) THEN evaluatee.FirstName + ' ' + evaluatee.LastName
	   ELSE ''
	   END AS EvaluateeDisplayName

  FROM dbo.SEEvalSession es
  LEFT OUTER JOIN dbo.SEUser evaluator
	ON es.EvaluatorUserID=evaluator.SEUserID
  LEFT OUTER JOIN dbo.SEUser evaluatee
	ON es.EvaluateeUserID=evaluatee.SEUserID



