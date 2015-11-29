if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateProcessSteps') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateProcessSteps.'
      drop procedure dbo.GetGoalTemplateProcessSteps
   END
GO
PRINT '.. Creating sproc GetGoalTemplateProcessSteps.'
GO
CREATE PROCEDURE GetGoalTemplateProcessSteps
	 @pGoalTemplateID BIGINT
	,@pRubricRowID BIGINT = -1
AS
SET NOCOUNT ON 


SELECT s.*
  FROM vGoalTemplateProcessStep s
 WHERE GoalTemplateID=@pGoalTemplateID
   AND (@pRubricRowID=-1 OR (RubricRowID=@pRubricRowID))
 ORDER BY s.Sequence

