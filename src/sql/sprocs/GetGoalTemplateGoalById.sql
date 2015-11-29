if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateGoalById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateGoalById.'
      drop procedure dbo.GetGoalTemplateGoalById
   END
GO
PRINT '.. Creating sproc GetGoalTemplateGoalById.'
GO
CREATE PROCEDURE GetGoalTemplateGoalById
	 @pGoalTemplateGoalID BIGINT
AS
SET NOCOUNT ON 


SELECT *
  FROM vGoalTemplateGoal
 WHERE GoalTemplateGoalID=@pGoalTemplateGoalID

