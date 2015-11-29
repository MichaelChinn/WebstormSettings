if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalProcessStepById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalProcessStepById.'
      drop procedure dbo.GetGoalProcessStepById
   END
GO
PRINT '.. Creating sproc GetGoalProcessStepById.'
GO
CREATE PROCEDURE GetGoalProcessStepById
	 @pStepID BIGINT
AS
SET NOCOUNT ON 


SELECT s.*
  FROM vGoalTemplateProcessStep s
 WHERE GoalTemplateProcessStepID=@pStepID

