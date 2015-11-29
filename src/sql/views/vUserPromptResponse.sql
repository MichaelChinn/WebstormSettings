
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserPromptResponse')
    DROP VIEW dbo.vUserPromptResponse
GO

CREATE VIEW dbo.vUserPromptResponse
AS 

SELECT  p.UserPromptID,
	    p.PromptTypeID,
	    p.EvaluationTypeID,
		p.Title,
		p.Prompt,
		p.CreatedByUserID,
		p.CreatedAsAdmin,
	    p.Private,
	    -- pr.DistrictCode should always equal p.DistrictCode, except for the Notes prompts
	    -- that are defined by the state, which have a blank DistrictCode.
	    --p.DistrictCode,
	    p.SchoolCode,
	    p.Sequence,
		pr.UserPromptResponseID,
		pr.EvaluateeID,
		pr.EvalSessionID,
		pr.SchoolYear,
		pr.DistrictCode,
		pr.ArtifactID,
		pr.GoalTemplateGoalID
 FROM dbo.SEUserPromptResponse pr
 JOIN dbo.SEUserPrompt p ON pr.UserPromptID=p.UserPromptID






