IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthRubricRowsForFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthRubricRowsForFrameworkNode.'
      DROP PROCEDURE dbo.GetStudentGrowthRubricRowsForFrameworkNode
   END
GO
PRINT '.. Creating sproc GetStudentGrowthRubricRowsForFrameworkNode.'
GO

CREATE PROCEDURE dbo.GetStudentGrowthRubricRowsForFrameworkNode
	@pFrameworkNodeID	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vRubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
 WHERE rrfn.FrameworkNodeID=@pFrameworkNodeID
   AND rr.IsStudentGrowthAligned=1
 ORDER BY rrfn.Sequence

