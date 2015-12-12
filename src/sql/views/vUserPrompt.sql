
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserPrompt')
    DROP VIEW dbo.vUserPrompt
GO

CREATE VIEW dbo.vUserPrompt
AS 

SELECT p.UserPromptID,
		p.PromptTypeID,
		p.EvaluationTypeID,
		p.Title,
		p.Prompt,
		p.SchoolYear,
		p.DistrictCode,
		p.SchoolCode,
		p.CreatedByUserID,
		p.Published,
		p.PublishedDate,
		p.Retired,
		p.CreatedAsAdmin,
		p.Private,
		u.FirstName + ' ' + u.LastName AS CreatedByDisplayName,
		CASE WHEN (p.EvaluationTypeID = 1) THEN 'Principal Prompts' ELSE 'Teacher Prompts' END AS EvaluationType,
		p.Sequence
 FROM dbo.SEUserPrompt p (NOLOCK)
 JOIN dbo.SEUser u (NOLOCK) ON p.CreatedByUserID=u.SEUserID






