
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vEvaluation')
    DROP VIEW dbo.vEvaluation
GO

CREATE VIEW dbo.vEvaluation
AS 

SELECT EvaluationID,
		EvaluateeID,
		EvaluatorID,
		EvaluationTypeID,
		PerformanceLevelID,
		HasBeenSubmitted,
		SubmissionDate,
		SchoolYear,
		Complete,
		EvaluateePlanTypeID,
		ShowOnlyAssignedReflectionPrompts,
		ShowOnlyAssignedGoalPrompts,
		DistrictCode,
		FocusedFrameworkNodeID,
		FocusedSGFrameworkNodeID,
		WfStateID,
		NextYearEvaluateePlanTypeID,
		NextYearFocusedFrameworkNodeID,
		NextYearFocusedSGFrameworkNodeID,
		ByPassSGScores,
		SGScoreOverrideComment,
		VisibleToEvaluatee,
		AutoSubmitAfterReceipt,
		ByPassReceipt,
		ByPassReceiptOverrideComment,
		DropToPaper,
		DropToPaperOverrideComment,
		MarkedFinalDateTime,
		FinalReportRepositoryItemID,
		EvaluateeReflectionsIsPublic,
		SubmissionCount
  FROM dbo.SEEvaluation
  



