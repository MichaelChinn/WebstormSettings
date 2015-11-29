if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateResult') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateResult.'
      drop procedure dbo.GetGoalTemplateResult
   END
GO
PRINT '.. Creating sproc GetGoalTemplateResult.'
GO
CREATE PROCEDURE GetGoalTemplateResult
	 @pGoalTemplateID BIGINT
	,@pRubricRowID BIGINT
AS
SET NOCOUNT ON 


SELECT *
  FROM vGoalTemplateResult
 WHERE GoalTemplateID=@pGoalTemplateID
   AND RubricRowID=@pRubricRowID

