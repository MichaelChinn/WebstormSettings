if exists (select * from sysobjects 
where id = object_id('dbo.DumpFramework') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DumpFramework.'
      drop procedure dbo.DumpFramework
   END
GO
PRINT '.. Creating sproc DumpFramework.'
GO
CREATE PROCEDURE DumpFramework


AS
SET NOCOUNT ON 


select f.name,f.frameworkID, fn.Title, fn.ShortName, fn.description, fn.IsLeafNode
, rrfn.sequence, rr.title, rr.Title, rr.PL1Descriptor, rr.PL2Descriptor, IsStateAligned
from SEFrameworkNode fn
join SERubricRowFrameworkNode rrfn on rrfn.FrameworkNodeID = fn.FrameworkNodeID
join SERubricRow rr on rr.RubricRowID = rrfn.RubricRowID
join SEFramework f on f.FrameworkID = fn.FrameworkID
order by FrameworkID, fn.Sequence, rrfn.Sequence


GO

