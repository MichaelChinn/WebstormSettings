select f.FrameworkID, f.name, f.description, f.districtCode, f.frameworkTypeID, fpl.FullName
, fpl.SEFrameworkPerformanceLevelID
,fn.title, fn.shortname, fn.description, fn.sequence, fn.FrameworkNodeID, rr.RubricRowID
,rr.title, rr.description, rr.isStateAligned, rr.BelongsToDistrict
from SEFramework f
join SEFrameworkNode fn on fn.FrameworkID = f.FrameworkID
join SERubricRowFrameworkNode rrfn on rrfn.FrameworkNodeID = fn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
join SEFrameworkPerformanceLevel fpl on fpl.frameworkID = f.frameworkID
order by  f.FrameworkID, fn.FrameworkNodeID, rr.RubricRowID, fpl.SEFrameworkPerformanceLevelID
