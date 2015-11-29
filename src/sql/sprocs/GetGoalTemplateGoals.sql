if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplateGoals') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateGoals.'
      drop procedure dbo.GetGoalTemplateGoals
   END
GO
PRINT '.. Creating sproc GetGoalTemplateGoals.'
GO

-- Only one of (templateId or NodeID) will come in as NULL
CREATE PROCEDURE GetGoalTemplateGoals
	 @pGoalTemplateID BIGINT = NULL
	 ,@pFrameworkNodeID BIGINT = NULL
	 ,@pUserID BIGINT = NULL
AS
SET NOCOUNT ON 

IF (@pFrameworkNodeID IS NULL)
BEGIN

SELECT *
  FROM vGoalTemplateGoal
 WHERE GoalTemplateID=@pGoalTemplateID
 
END
ELSE
BEGIN

SELECT g.*
  FROM vGoalTemplateGoal g
  JOIN dbo.SEGoalTemplate t ON g.GoalTemplateID=t.GoalTemplateID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON g.RubricRowID=rrfn.RubricRowID
 WHERE rrfn.FrameworkNodeID=@pFrameworkNodeID
   AND t.UserID=@pUserID
 ORDER BY t.GoalTemplateTypeID
 
END

