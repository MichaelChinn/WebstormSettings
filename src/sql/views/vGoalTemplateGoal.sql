
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vGoalTemplateGoal')
    DROP VIEW dbo.vGoalTemplateGoal
GO

CREATE VIEW dbo.vGoalTemplateGoal
AS 

SELECT 	
	g.GoalTemplateGoalID,
    g.GoalTemplateID,
    g.GoalStatement,
	g.RubricRowID,
	g.Outcome,
	g.Reflection,
	t.GoalTemplateTypeID
  FROM dbo.SEGoalTemplateGoal g
  JOIN dbo.SEGoalTemplate t ON g.GoalTemplateID=t.GoalTemplateID




