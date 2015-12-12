
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRubricRowAnnotation')
    DROP VIEW dbo.vRubricRowAnnotation
GO

CREATE VIEW dbo.vRubricRowAnnotation
AS 

SELECT rr.RubricRowID
	  ,rra.Annotation
	  ,rrfn.FrameworkNodeID
	  ,rrfn.Sequence AS RRSequence
	  ,fn.FrameworkID
	  ,fn.ShortName AS NodeShortName
	  ,FN.Sequence AS FNSequence
	  ,rr.Title AS RubricRowTitle
	  ,rr.IsStudentGrowthAligned
	  ,es.EvalSessionID
	  ,es.Title AS SessionTitle
	  ,es.ObserveStartTime
	  ,es.EvaluateeUserId
	  ,evaluator.FirstName + ' ' + evaluator.LastName AS EvaluatorDisplayName
	  ,es.EvaluationTypeID
	  ,es.IsSelfAssess
	  ,es.ObserveIsPublic
	  ,es.EvaluationScoreTypeID
	  ,rra.UserID
	  ,rra_owner.FirstName + ' ' + rra_owner.LastName AS OwnerDisplayName
  FROM dbo.SERubricRowAnnotation rra
  JOIN dbo.SERubricRowFrameworkNode rrfn
    ON rrfn.RubricRowID = rra.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SERubricRow rr
    ON rra.RubricRowID = rr.RubricRowID
  JOIN dbo.SEEvalSession es
	ON rra.EvalSessionID=es.EvalSessionID
  JOIN dbo.SEUser evaluator
	ON es.EvaluatorUserID=evaluator.SEUserID
  JOIN dbo.SEUser rra_owner
    ON rra.UserID=rra_owner.SEUserID

 






