IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkAllStudentGrowthRubricRows') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkAllStudentGrowthRubricRows.'
      DROP PROCEDURE dbo.GetFrameworkAllStudentGrowthRubricRows
   END
GO
PRINT '.. Creating sproc GetFrameworkAllStudentGrowthRubricRows.'
GO

CREATE PROCEDURE dbo.GetFrameworkAllStudentGrowthRubricRows
	@pFrameworkID BIGINT
AS

SET NOCOUNT ON 


SELECT DISTINCT rr.*, fn.ParentNodeID
  FROM dbo.vRubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE fn.FrameworkID=@pFrameworkID
   AND rr.IsStudentGrowthAligned=1
 ORDER BY fn.ParentNodeID
 



