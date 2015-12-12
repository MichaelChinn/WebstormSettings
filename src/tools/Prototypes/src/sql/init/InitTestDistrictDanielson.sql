
DECLARE @FrameworkID BIGINT

DECLARE @FrameworkTypeID SMALLINT,  @FrameworkViewTypeID SMALLINT
DECLARE @RubricRowID BIGINT

SELECT @FrameworkTypeID = FrameworkTypeID FROM dbo.SEFrameworkType WHERE Name='Danielson'
SELECT @FrameworkViewTypeID = FrameworkViewTypeID FROM dbo.SEFrameworkViewType WHERE Name='Instructional Framework Default'

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, FrameworkViewTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved) 
VALUES('Aberdeen Sample', 'Full Danielson Framework', '14005', 2012, @FrameworkTypeID, @FrameworkViewTypeID
			, 1, null, 0, 1)
SELECT @FrameworkID = SCOPE_IDENTITY()

-- Domains
DECLARE @Domain1NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, shortname, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Planning and Preparation', '', 1, 'Planning and Preparation', 0)
SELECT @Domain1NodeId = SCOPE_IDENTITY()

DECLARE @Domain2NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, shortname, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'The Classroom Environment', '', 2, 'The Classroom Environment', 0)
SELECT @Domain2NodeId = SCOPE_IDENTITY()

DECLARE @Domain3NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, shortname, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Instruction', '', 3, 'Instruction', 0)
SELECT @Domain3NodeId = SCOPE_IDENTITY()

DECLARE @Domain4NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, shortname, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Professional Responsibilities', '', 4, 'Professional Responsibilities', 0)
SELECT @Domain4NodeId = SCOPE_IDENTITY()

--before we load stuff up, set up new uniq ids in the danielson table
update stateEval_staging.dbo.danielson set XferID = newId();

INSERT SEFrameworkNode ( FrameworkID, Title, description, Sequence, shortname, IsLeafNode)
select distinct @frameworkId, component, '', 1, substring(component, 11, 2), 0  from stateEval_staging.dbo.danielson

UPDATE SEFrameworkNode set ParentNodeID = @Domain1NodeId, description='' WHERE Title like 'Component 1%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain2NodeId, description='' WHERE Title like 'Component 2%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain3NodeId, description='' WHERE Title like 'Component 3%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain4NodeId, description='' WHERE Title like 'Component 4%' AND FrameworkID=@frameworkID

-- this bit sets up the xfer ids in the frameworkNode
--drop table #componentGuid
CREATE Table #ComponentGuid (xferId UniqueIdentifier, component varchar (200))
insert #ComponentGuid (xferId, component)
select xferID, d.component
from stateEval_staging.dbo.danielson d
join (
	select  min (rownum) as rowNum, component 
	from stateEval_staging.dbo.danielson
	group by component
) d2 on d.rowNum=d2.rowNum

update SEFrameworkNode set xferID = x.XferId
from SEFrameworkNode fn
join #ComponentGuid x on x.component = fn.title
where fn.FrameworkId = @frameworkId

-- now we can set up the fwn sequence numbers
UPDATE SEFrameworkNode
SET Sequence = seqNo
FROM SEFrameworkNode fn
join stateEval_staging.dbo.danielson d on d.xferId = fn.xferID
join 
(
	select FrameworkNodeID,
	ROW_NUMBER() OVER (partition by parentNodeID ORDER BY FrameworkNodeID) AS seqNo
	, Title
	from SEFrameworkNode fn
	join stateEval_staging.dbo.danielson d on d.xferID = fn.xferID
) X on x.FrameworkNodeID = fn.FrameworkNodeID


-- now for the rubric rows
INSERT SERubricRow(title, pl4DEscriptor, pl3Descriptor, pl2Descriptor, pl1Descriptor, FrameworkSequence, Description, xferId)
SELECT Element, l3, l2, l1, l0, rownum, '', xferId from StateEval_staging.dbo.danielson

UPDATE seRubricRow set FrameworkSequence = x.SeqNo
from seRubricRow rr
join stateEval_staging.dbo.Danielson d on rr.xferID = d.xferID
join 
(
select xferId, 
row_number() over (partition by component order by rownum) as SeqNo
 from stateEval_staging.dbo.Danielson	
) X on x.xferID = rr.xferId

insert SERubricRowFrameworkNode (RubricRowId, FrameworkNodeID, Sequence)
select  rr.RubricRowId, fn.frameworkNodeId, rr.frameworkSequence 
from SERubricRow rr
join stateEval_staging.dbo.danielson d on d.xferID = rr.xferID
join #ComponentGuid c on c.component = d.component
join seframeworkNode fn on fn.xferId = c.xferID

-- set IsLeafNode on framework nodes that have rubrics
update dbo.SEFrameworkNode
   set IsLeafNode=1 
  from dbo.SEFrameworkNode n
  join SERubricRowFrameworkNode rrfn on n.FrameworkNodeID=rrfn.FrameworkNodeID

drop table #ComponentGuid
update dbo.seRubricRow set xferID=null
update dbo.seFrameworkNode set xferID=null
