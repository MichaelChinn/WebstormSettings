
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vGoalTemplateProcessStep')
    DROP VIEW dbo.vGoalTemplateProcessStep
GO

CREATE VIEW dbo.vGoalTemplateProcessStep
AS 

SELECT GoalTemplateProcessStepID
	  ,GoalTemplateID
	  ,RubricRowID
	  ,GoalProcessStepTypeID
	  ,Response
	  ,Sequence
  FROM dbo.SEGoalTemplateProcessStep




