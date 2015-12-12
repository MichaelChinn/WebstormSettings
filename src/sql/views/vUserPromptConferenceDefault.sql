
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vUserPromptConferenceDefault')
    DROP VIEW dbo.vUserPromptConferenceDefault
GO

CREATE VIEW dbo.vUserPromptConferenceDefault
AS 

SELECT d.EvaluateeID 
      ,d.UserPromptID
      ,d.UserPromptTypeID
      ,p.CreatedByUserID
      ,p.EvaluationTypeID
      ,p.Title
      ,p.Prompt
      ,p.PromptTypeID
      ,p.SchoolCode
      ,p.SchoolYear
	  ,p.CreatedAsAdmin
	  ,p.Private
	  ,d.DistrictCode
	  ,d.SEUserPromptConferenceDefaultID
  FROM dbo.SEUserPromptConferenceDefault d
  JOIN dbo.SEUserPrompt p on d.UserPromptID=p.UserPromptID





