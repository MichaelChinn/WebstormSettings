
IF EXISTS (SELECT TABLE_NAME 
	   FROM   INFORMATION_SCHEMA.VIEWS 
	   WHERE  TABLE_NAME = N'vFrameworkRows')
    DROP VIEW dbo.vFrameworkRows
GO

CREATE VIEW dbo.vFrameworkRows
AS 

select f.frameworkID, f.name,  fn.FrameworkNodeID
	, fn.Title as nodeTitle, fn.shortname, fn.description
	, rr.shortname AS rrShortname, rr.RubricRowID,rr.title as rowTitle , rr.Description AS rowDesc, rrfn.sequence
	, rr.BelongsToDistrict, rr.IsStudentGrowthAligned
	, f.StickyID AS fSticky, fn.StickyID AS fnSticky, rr.StickyID AS rrSticky
from dbo.seframeworknode fn
join dbo.serubricrowframeworknode rrfn on rrfn.frameworknodeid=fn.frameworknodeid
join dbo.serubricrow rr on rr.rubricrowID =rrfn.rubricrowID
join dbo.SEFramework f on f.frameworkId = fn.FrameworkID




