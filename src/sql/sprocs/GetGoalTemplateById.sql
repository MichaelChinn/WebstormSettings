if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateById.'
      drop procedure dbo.GetGoalTemplateById
   END
GO
PRINT '.. Creating sproc GetGoalTemplateById.'
GO
CREATE PROCEDURE GetGoalTemplateById
	 @pGoalTemplateId BIGINT
AS
SET NOCOUNT ON 


SELECT *
  FROM vGoalTemplate
 WHERE GoalTemplateId=@pGoalTemplateId

