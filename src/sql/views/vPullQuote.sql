IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vPullQuote')
   BEGIN
      PRINT '.. Dropping View vPullQuote.'
	  DROP VIEW dbo.vPullQuote
   END
GO
PRINT '.. Creating View vPullQuote.'
GO
CREATE VIEW dbo.vPullQuote
AS 
	SELECT
		pq.*
		,fn.shortname as NodeShortName
		,fn.Sequence AS NodeSequence
		,fn.FrameworkID
		,es.EvaluationTypeID
		,es.IsSelfAssess
	  ,CASE 
	   WHEN (evaluator.FirstName IS NOT NULL) THEN evaluator.FirstName + ' ' + evaluator.LastName
	   ELSE ''
	   END  AS EvaluatorDisplayName
	FROM dbo.SEPullQuote pq
    JOIN dbo.SEEvalSession es ON pq.EvalSessionID=es.EvalSessionID
     LEFT OUTER JOIN dbo.SEUser evaluator ON es.EvaluatorUserID=evaluator.SEUserID
	JOIN dbo.SEFrameworkNode fn ON fn.frameworkNodeID = pq.frameworkNodeID




	
