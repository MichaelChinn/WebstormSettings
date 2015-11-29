if exists (select * from sysobjects 
where id = object_id('dbo.GetNotesUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetNotesUserPrompt.'
      drop procedure dbo.GetNotesUserPrompt
   END
GO
PRINT '.. Creating sproc GetNotesUserPrompt.'
GO
CREATE PROCEDURE GetNotesUserPrompt
	 @pTitle VARCHAR(200)
	 ,@pEvaluationTypeID SMALLINT
AS
SET NOCOUNT ON 

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
		0 AS InUse, -- only for this query where we don't care and don't want to do the expensive left outer join
		u.FirstName + ' ' + u.LastName AS CreatedByDisplayName,
		CASE WHEN (p.EvaluationTypeID = 1) THEN 'Principal Prompts' ELSE 'Teacher Prompts' END AS EvaluationType,
		p.Sequence
 FROM dbo.SEUserPrompt p (NOLOCK)
 JOIN dbo.SEUser u (NOLOCK) ON p.CreatedByUserID=u.SEUserID
WHERE p.Title = @pTitle
  AND p.EvaluationTypeID = @pEvaluationTypeID

   
