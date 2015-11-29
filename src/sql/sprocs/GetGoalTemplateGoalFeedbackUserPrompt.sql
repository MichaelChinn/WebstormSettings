if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateGoalFeedbackUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateGoalFeedbackUserPrompt.'
      drop procedure dbo.GetGoalTemplateGoalFeedbackUserPrompt
   END
GO
PRINT '.. Creating sproc GetGoalTemplateGoalFeedbackUserPrompt.'
GO
CREATE PROCEDURE GetGoalTemplateGoalFeedbackUserPrompt
	 @pGoalTemplateGoalID BIGINT
	 ,@pUserPromptID BIGINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.UserPromptID=@pUserPromptID
   AND r.GoalTemplateGoalID=@pGoalTemplateGoalID

   
