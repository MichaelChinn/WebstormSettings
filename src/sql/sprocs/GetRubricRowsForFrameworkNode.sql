IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowsForFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowsForFrameworkNode.'
      DROP PROCEDURE dbo.GetRubricRowsForFrameworkNode
   END
GO
PRINT '.. Creating sproc GetRubricRowsForFrameworkNode.'
GO

CREATE PROCEDURE dbo.GetRubricRowsForFrameworkNode
	@pFrameworkNodeID	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vRubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
 WHERE rrfn.FrameworkNodeID=@pFrameworkNodeID
 ORDER BY rrfn.Sequence

