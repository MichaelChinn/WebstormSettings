IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetArtifactsForGoalTemplateGoal') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetArtifactsForGoalTemplateGoal.'
      DROP PROCEDURE dbo.GetArtifactsForGoalTemplateGoal
   END
GO
PRINT '.. Creating sproc GetArtifactsForGoalTemplateGoal.'
GO

CREATE PROCEDURE dbo.GetArtifactsForGoalTemplateGoal
	@pGoalTemplateGoalID BIGINT
AS

SET NOCOUNT ON 


SELECT * 
  FROM dbo.vArtifact
 WHERE GoalTemplateGoalID=@pGoalTemplateGoalID
 ORDER BY LastUpload
 

