IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowsForFrameworkSet') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowsForFrameworkSet.'
      DROP PROCEDURE dbo.GetRubricRowsForFrameworkSet
   END
GO
PRINT '.. Creating sproc GetRubricRowsForFrameworkSet.'
GO

CREATE PROCEDURE dbo.GetRubricRowsForFrameworkSet
	@pDistrictCode VARCHAR(20),
	@pEvalTypeID SMALLINT,
	@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 


SELECT DISTINCT rr.*
  FROM dbo.vRubricRow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f on fn.FrameworkID=f.FrameworkID
 WHERE f.DistrictCode=@pDistrictCode
   AND f.EvaluationTypeID=@pEvalTypeID
   AND f.SchoolYear=@pSchoolYear
ORDER BY rr.RubricRowID

 



