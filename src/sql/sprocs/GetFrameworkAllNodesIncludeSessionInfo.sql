IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkAllNodesIncludeSessionInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkAllNodesIncludeSessionInfo.'
      DROP PROCEDURE dbo.GetFrameworkAllNodesIncludeSessionInfo
   END
GO
PRINT '.. Creating sproc GetFrameworkAllNodesIncludeSessionInfo.'
GO

CREATE PROCEDURE dbo.GetFrameworkAllNodesIncludeSessionInfo
	@pFrameworkID BIGINT
	,@pSessionID BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Nodes(FrameworkNodeID BIGINT, FocusRowCount INT)
INSERT INTO #Nodes(FrameworkNodeID, FocusRowCount)
SELECT fn.FrameworkNodeID, 0
  FROM dbo.SEFrameworkNode fn
 WHERE fn.FrameworkID=@pFrameworkID
 
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
 



