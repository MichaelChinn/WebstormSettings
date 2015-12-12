
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserPromptResponseEntry')
    DROP VIEW dbo.vUserPromptResponseEntry
GO

CREATE VIEW dbo.vUserPromptResponseEntry
AS 

SELECT  p.UserPromptID,
	    p.PromptTypeID,
		p.Title,
		pr.UserPromptResponseID,
		p.Prompt,
		pr.EvaluateeID,
		pr.EvalSessionID,
		pre.Response,
		pre.CreationDateTime,
		pre.UserPromptResponseEntryID,
		u.FirstName + ' ' + u.LastName AS DisplayName,
		pre.UserID
 FROM dbo.SEUserPromptResponseEntry pre (NOLOCK)
 JOIN dbo.SEUserPromptResponse pr (NOLOCK) ON pre.UserPromptResponseID=pr.UserPromptResponseID
 JOIN dbo.SEUserPrompt p (NOLOCK) ON pr.UserPromptID=p.UserPromptID
 JOIN dbo.SEUser u (NOLOCK) ON pre.UserID=u.SEUserID 






