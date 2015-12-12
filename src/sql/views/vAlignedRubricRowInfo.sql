
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vAlignedRubricRowInfo')
    DROP VIEW dbo.vAlignedRubricRowInfo
GO

CREATE VIEW dbo.vAlignedRubricRowInfo
AS 

SELECT prr.UserPromptID, 
	   prr.RubricRowID, 
	   rr.Title, 
	   fn.ShortName, 
	   fn.FrameworkNodeID, 
	   fn.FrameworkID 
  FROM dbo.SEUserPromptRubricRowAlignment prr
  JOIN dbo.SERubricRow rr ON prr.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID






