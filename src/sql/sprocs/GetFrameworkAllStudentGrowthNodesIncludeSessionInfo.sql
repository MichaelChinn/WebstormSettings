IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkAllStudentGrowthNodesIncludeSessionInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkAllStudentGrowthNodesIncludeSessionInfo.'
      DROP PROCEDURE dbo.GetFrameworkAllStudentGrowthNodesIncludeSessionInfo
   END
GO
PRINT '.. Creating sproc GetFrameworkAllStudentGrowthNodesIncludeSessionInfo.'
GO

CREATE PROCEDURE dbo.GetFrameworkAllStudentGrowthNodesIncludeSessionInfo
	@pFrameworkID BIGINT
	,@pSessionID BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Nodes(FrameworkNodeID BIGINT, FocusRowCount INT)
INSERT INTO #Nodes(FrameworkNodeID, FocusRowCount)
SELECT DISTINCT fn.FrameworkNodeID, 0
  FROM dbo.SEFrameworkNode fn
  JOIN dbo.SERubricRowFrameworkNode rrfn ON fn.FrameworkNodeID=rrfn.FrameworkNodeID
  JOIN dbo.SERubricRow rr on rrfn.RubricRowID = rr.RubricRowID
 WHERE rr.IsStudentGrowthAligned=1
   AND fn.FrameworkID=@pFrameworkID
 
 UPDATE #Nodes
    SET FocusRowCount=x.Count
   FROM (SELECT COUNT(rrf.RubricRowID) AS COUNT, rrfn.FrameworkNodeID
		   FROM dbo.SEEvalSessionRubricRowFocus rrf
		   JOIN dbo.SERubricRowFrameworkNode rrfn ON rrf.RubricRowID=rrfn.RubricRowID
		  WHERE rrf.EvaluationRoleTypeID=1
			AND rrf.EvalSessionID=@pSessionID
		  GROUP BY rrfn.FrameworkNodeID) x
 WHERE #Nodes.FrameworkNodeID = x.FrameworkNodeID

SELECT fn.*, CASE WHEN (n.FocusRowCount=0) THEN 0 ELSE 1 END AS HasFocus
  FROM dbo.#Nodes n
  JOIN dbo.vFrameworkNode fn ON n.FrameworkNodeID=fn.FrameworkNodeID
 ORDER BY fn.ParentNodeID, fn.Sequence



