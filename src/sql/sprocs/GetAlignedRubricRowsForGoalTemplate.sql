IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetAlignedRubricRowsForGoalTemplate') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedRubricRowsForGoalTemplate.'
      DROP PROCEDURE dbo.GetAlignedRubricRowsForGoalTemplate
   END
GO
PRINT '.. Creating sproc GetAlignedRubricRowsForGoalTemplate.'
GO

CREATE PROCEDURE dbo.GetAlignedRubricRowsForGoalTemplate
	@pFrameworkID BIGINT
	,@pGoalTemplateID BIGINT
AS

SET NOCOUNT ON 

SELECT rr.*
  FROM dbo.SEGoalTemplateRubricRowAlignment trr
  JOIN dbo.vRubricRow rr ON trr.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE trr.GoalTemplateID=@pGoalTemplateID




