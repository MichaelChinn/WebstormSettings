
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vGoalTemplate')
    DROP VIEW dbo.vGoalTemplate
GO

CREATE VIEW dbo.vGoalTemplate
AS 

SELECT 	[GoalTemplateID],
	[GoalTemplateTypeID],
	[UserID],
	[DistrictCode],
	[SchoolYear],
	[EvaluationTypeID],
	[Title],
	[CreationDateTime]
  FROM dbo.SEGoalTemplate




