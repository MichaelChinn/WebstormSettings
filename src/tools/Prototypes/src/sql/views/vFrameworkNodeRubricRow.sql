
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFrameworkNodeRubricRow')
    DROP VIEW dbo.vFrameworkNodeRubricRow
GO

CREATE VIEW dbo.vFrameworkNodeRubricRow
AS 

SELECT rr.RubricRowID
	  ,rr.Title
	  ,rr.Description
	  ,rr.PL4Descriptor
	  ,rr.PL3Descriptor
	  ,rr.PL2Descriptor
	  ,rr.PL1Descriptor
	  ,rr.IsStateAligned
	  ,rrfn.FrameworkNodeID
	  ,rrfn.Sequence
 FROM dbo.SERubricRow rr
 JOIN dbo.SERubricRowFrameworkNode rrfn on rr.rubricRowID=rrfn.rubricRowId




