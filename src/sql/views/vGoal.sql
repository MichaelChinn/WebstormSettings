
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vGoal')
    DROP VIEW dbo.vGoal
GO

CREATE VIEW dbo.vGoal
AS 

SELECT g.GoalID
	  ,g.EvaluateeUserID
	  ,fs.EvaluatorID As EvaluatorUserID
	  ,Notes
	  ,CASE 
	   WHEN (evaluator.FirstName IS NOT NULL) THEN evaluator.FirstName + ' ' + evaluator.LastName
	   ELSE ''
	   END  AS EvaluatorDisplayName
	  ,CASE 
	   WHEN (evaluatee.FirstName IS NOT NULL) THEN evaluatee.FirstName + ' ' + evaluatee.LastName
	   ELSE ''
	   END AS EvaluateeDisplayName
  FROM dbo.SEGoal g
  LEFT OUTER JOIN dbo.SEUser evaluatee
	ON g.EvaluateeUserID=evaluatee.SEUserID
  LEFT OUTER JOIN dbo.SEFinalScore fs
    ON g.EvaluateeUserID=fs.EvaluateeID
  LEFT OUTER JOIN dbo.SEUser evaluator
    ON fs.EvaluatorID=evaluator.SEUserID
 



