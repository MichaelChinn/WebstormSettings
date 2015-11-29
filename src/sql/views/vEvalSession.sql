
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vEvalSession')
    DROP VIEW dbo.vEvalSession
GO

CREATE VIEW dbo.vEvalSession
AS 

SELECT es.EvalSessionID
	  ,es.SchoolCode
	  ,es.DistrictCode
	  ,ds_school.districtSchoolName AS School
	  ,ds_district.districtSchoolName AS District
	  ,es.EvaluateeUserID
	  ,es.EvaluatorUserID
	  ,es.EvaluationTypeID
	  ,es.EvaluationScoreTypeID
	  ,es.AnchorTypeID
	  ,es.EvalSessionLockStateID
	  ,es.Title
	  ,es.SchoolYear
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
	  ,es.ObserveNotes
	  ,es.PerformanceLevelID
	  ,es.IsSelfAssess
	  ,es.IsFocused
	  ,es.FocusedFrameworkNodeID
	  ,es.FocusedSGFrameworkNodeID
	  ,es.TrainingProtocolID
	  ,es.SessionKey
	  ,es.LockDateTime
	  ,es.IncludeInFinalReport
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
  LEFT OUTER JOIN dbo.SEDistrictSchool ds_school
	ON (es.SchoolCode=ds_school.SchoolCode AND es.DistrictCode=ds_school.districtCode)
  LEFT OUTER JOIN dbo.SEDistrictSchool ds_district
	ON es.DistrictCode=ds_district.DistrictCode
 WHERE (ds_district.IsSchool=0 OR ds_district.IsSchool IS NULL)




