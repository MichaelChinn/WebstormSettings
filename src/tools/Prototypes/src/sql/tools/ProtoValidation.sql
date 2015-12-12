select * from SEFramework f
join SEFrameworkNode fn on fn.FrameworkID = f.frameworkID
join SERubricRowFrameworkNode rrfn on rrfn.FrameworkNodeID = fn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
join SEFrameworkPerformanceLevel fpl on fpl.FrameworkID = f.FrameworkID
order by f.FrameworkID, fn.Sequence, rrfn.Sequence, fpl.PerformanceLevelID