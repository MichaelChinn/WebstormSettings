IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStudentGrowthRubricRowsWithSessionInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStudentGrowthRubricRowsWithSessionInfo.'
      DROP PROCEDURE dbo.GetStudentGrowthRubricRowsWithSessionInfo
   END
GO
PRINT '.. Creating sproc GetStudentGrowthRubricRowsWithSessionInfo.'
GO

CREATE PROCEDURE dbo.GetStudentGrowthRubricRowsWithSessionInfo
	@pSessionID	BIGINT
	,@pFrameworkNodeID BIGINT
	,@pEvaluatorID BIGINT
	,@pEvaluateeID BIGINT
	,@pFocusOnly BIT
AS

SET NOCOUNT ON 

-- Evaluator and Evaluatee descriptor text, first setup as default value
-- and then see if there is an override
CREATE TABLE #RubricRows(RubricRowID BIGINT
	  ,PL4Descriptor VARCHAR(MAX)
	  ,PL3Descriptor VARCHAR(MAX)
	  ,PL2Descriptor VARCHAR(MAX)
	  ,PL1Descriptor VARCHAR(MAX)
	  ,PL4DescriptorTEE VARCHAR(MAX)
	  ,PL3DescriptorTEE VARCHAR(MAX)
	  ,PL2DescriptorTEE VARCHAR(MAX)
	  ,PL1DescriptorTEE VARCHAR(MAX)
	  ,Sequence SMALLINT
	  )
	  
INSERT INTO #RubricRows(RubricRowID
	  ,PL4Descriptor
	  ,PL3Descriptor
	  ,PL2Descriptor
	  ,PL1Descriptor
	  ,PL4DescriptorTEE
	  ,PL3DescriptorTEE
	  ,PL2DescriptorTEE
	  ,PL1DescriptorTEE
	  ,Sequence)
SELECT rr.RubricRowID
	  ,rr.PL4Descriptor
	  ,rr.PL3Descriptor
	  ,rr.PL2Descriptor
	  ,rr.PL1Descriptor
	  ,rr.PL4Descriptor
	  ,rr.PL3Descriptor
	  ,rr.PL2Descriptor
	  ,rr.PL1Descriptor
	  ,rrfn.Sequence
 FROM dbo.SERubricRow rr
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn 
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
WHERE rr.IsStudentGrowthAligned=1
  AND fn.FrameworkNodeID=@pFrameworkNodeID
 
UPDATE #RubricRows
   SET PL1Descriptor=o.PL1DescriptorText
      ,PL2Descriptor=o.PL2DescriptorText
      ,PL3Descriptor=o.PL3DescriptorText
      ,PL4Descriptor=o.PL4DescriptorText
  FROM dbo.SERubricPLDTextOverride o
  JOIN #RubricRows rr on o.RubricRowID=rr.RubricRowID
 WHERE o.EvalSessionID=@pSessionID
   AND o.UserID=@pEvaluatorID
 
 UPDATE #RubricRows
   SET PL1DescriptorTEE=o.PL1DescriptorText
      ,PL2DescriptorTEE=o.PL2DescriptorText
      ,PL3DescriptorTEE=o.PL3DescriptorText
      ,PL4DescriptorTEE=o.PL4DescriptorText
  FROM dbo.SERubricPLDTextOverride o
  JOIN #RubricRows rr on o.RubricRowID=rr.RubricRowID
 WHERE o.EvalSessionID=@pSessionID
   AND o.UserID=@pEvaluateeID  
   
IF (@pFocusOnly = 1)
BEGIN
SELECT rr.RubricRowID
	  ,rr.Title
	  ,rr.Description
	  ,rr.IsStudentGrowthAligned
	  ,rro.PL4Descriptor
	  ,rro.PL3Descriptor
	  ,rro.PL2Descriptor
	  ,rro.PL1Descriptor
	  ,rro.PL4DescriptorTEE
	  ,rro.PL3DescriptorTEE
	  ,rro.PL2DescriptorTEE
	  ,rro.PL1DescriptorTEE
	  ,rr.IsStateAligned
	  ,rr.PL4Descriptor AS PL4DescriptorOrig
	  ,rr.PL3Descriptor AS PL3DescriptorOrig
	  ,rr.PL2Descriptor AS PL2DescriptorOrig
	  ,rr.PL1Descriptor AS PL1DescriptorOrig
	  ,1 AS HasFocus
	  ,rr.ShortName
  FROM dbo.vRubricRow rr
  JOIN dbo.#RubricRows rro 
    ON rr.RubricRowID=rro.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEEvalSessionRubricRowFocus esrrf
    ON (rr.RubricRowID=esrrf.RubricRowID AND esrrf.EvalSessionID=@pSessionId)
 WHERE esrrf.EvaluationRoleTypeID=1
   AND fn.FrameworkNodeID=@pFrameworkNodeID
 ORDER BY rrfn.Sequence
 END
 ELSE
 BEGIN
 
 SELECT rr.RubricRowID
	  ,rr.Title
	  ,rr.Description
	  ,rr.IsStudentGrowthAligned
	  ,rro.PL4Descriptor
	  ,rro.PL3Descriptor
	  ,rro.PL2Descriptor
	  ,rro.PL1Descriptor
	  ,rro.PL4DescriptorTEE
	  ,rro.PL3DescriptorTEE
	  ,rro.PL2DescriptorTEE
	  ,rro.PL1DescriptorTEE
	  ,rr.IsStateAligned
	  ,rr.PL4Descriptor AS PL4DescriptorOrig
	  ,rr.PL3Descriptor AS PL3DescriptorOrig
	  ,rr.PL2Descriptor AS PL2DescriptorOrig
	  ,rr.PL1Descriptor AS PL1DescriptorOrig
	  ,CASE WHEN (esrrf.RubricRowID IS NULL) THEN 0 ELSE 1 END AS HasFocus
	  ,rr.ShortName
  FROM dbo.vRubricRow rr
  JOIN dbo.#RubricRows rro 
    ON rr.RubricRowID=rro.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn
	ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn
    ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  LEFT OUTER JOIN dbo.SEEvalSessionRubricRowFocus esrrf
    ON (rr.RubricRowID=esrrf.RubricRowID AND esrrf.EvalSessionID=@pSessionId AND esrrf.EvaluationRoleTypeID=1)
 WHERE fn.FrameworkNodeID=@pFrameworkNodeID
 ORDER BY rrfn.Sequence
 END


