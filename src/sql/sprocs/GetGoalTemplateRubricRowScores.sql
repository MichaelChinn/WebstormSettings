IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetGoalTemplateRubricRowScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateRubricRowScores.'
      DROP PROCEDURE dbo.GetGoalTemplateRubricRowScores
   END
GO
PRINT '.. Creating sproc GetGoalTemplateRubricRowScores.'
GO

CREATE PROCEDURE dbo.GetGoalTemplateRubricRowScores
	@pGoalTemplateID	BIGINT
AS

SET NOCOUNT ON 

SELECT rrs.GoalTemplateRubricRowScoreID
	  ,rrs.RubricRowID
	  ,rrs.GoalTemplateID
	  ,rrs.UserID
	  ,rrs.PerformanceLevelID
  FROM dbo.SEGoalTemplateRubricRowScore rrs
  JOIN dbo.SERubricRow rr ON rrs.RubricRowID=rr.RubricRowID
 WHERE rrs.GoalTemplateID=@pGoalTemplateID



