IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkAllStudentGrowthNodes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkAllStudentGrowthNodes.'
      DROP PROCEDURE dbo.GetFrameworkAllStudentGrowthNodes
   END
GO
PRINT '.. Creating sproc GetFrameworkAllStudentGrowthNodes.'
GO

CREATE PROCEDURE dbo.GetFrameworkAllStudentGrowthNodes
	@pFrameworkID BIGINT
AS

SET NOCOUNT ON 


SELECT DISTINCT fn.*
  FROM dbo.vFrameworkNode fn
  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
  JOIN dbo.SERubricRow rr on rrfn.RubricRowID = rr.RubricRowID
 WHERE fn.FrameworkID=@pFrameworkID
   AND rr.IsStudentGrowthAligned=1
 ORDER BY fn.ParentNodeID
 



