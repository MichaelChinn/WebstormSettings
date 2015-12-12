
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vRowsInFramework')
    DROP VIEW dbo.vRowsInFramework
GO

CREATE VIEW dbo.vRowsInFramework
AS 

select fn.FrameworkID
	, fn.FrameworkNodeID
	, fn.Title as fnTitle
	, fn.Sequence as nodeSequence
	, fn.ShortName
	, rrfn.Sequence AS rrSequence
	, rr.* 
from seFrameworkNode fn
join seRubricRowFrameworkNode rrfn on rrfn.FrameworkNodeID = fn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
