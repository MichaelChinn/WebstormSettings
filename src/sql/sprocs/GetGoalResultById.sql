if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalResultById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalResultById.'
      drop procedure dbo.GetGoalResultById
   END
GO
PRINT '.. Creating sproc GetGoalResultById.'
GO
CREATE PROCEDURE GetGoalResultById
	 @pResultID BIGINT
AS
SET NOCOUNT ON 


SELECT *
  FROM vGoalTemplateResult
 WHERE GoalTemplateResultID=@pResultID

