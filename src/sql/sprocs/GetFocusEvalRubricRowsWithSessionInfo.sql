IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFocusEvalRubricRowsWithSessionInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFocusEvalRubricRowsWithSessionInfo.'
      DROP PROCEDURE dbo.GetFocusEvalRubricRowsWithSessionInfo
   END
GO
PRINT '.. Creating sproc GetFocusEvalRubricRowsWithSessionInfo.'
GO

CREATE PROCEDURE dbo.GetFocusEvalRubricRowsWithSessionInfo
	 @pSessionID		BIGINT
	,@pFocusNodeID		BIGINT
	,@pSGFocusNodeID	BIGINT
	,@pEvaluatorID		BIGINT
	,@pEvaluateeID		BIGINT
AS

SET NOCOUNT ON 

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
WHERE rrfn.FrameworkNodeID = @pFocusNodeID
 
 IF (@pFocusNodeID <> @pSGFocusNodeID)
 BEGIN 
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
		  ,rrfn.Sequence + 20 -- make sure they are at the end
	 FROM dbo.SERubricRow rr
	 JOIN dbo.SERubricRowFrameworkNode rrfn
	   ON rr.RubricRowID=rrfn.RubricRowID
	WHERE rrfn.FrameworkNodeID=@pSGFocusNodeId
	  AND rr.IsStudentGrowthAligned=1
END 

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
    
 SELECT  
       rr.RubricRowID
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
	  ,rr.ShortName
	  ,1 AS HasFocus
  FROM dbo.vRubricRow rr
  JOIN dbo.#RubricRows rro 
    ON rr.RubricRowID=rro.RubricRowID
 ORDER BY rro.Sequence


