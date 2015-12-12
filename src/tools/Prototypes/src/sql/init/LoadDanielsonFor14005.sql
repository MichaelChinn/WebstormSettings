
DECLARE @FrameworkID BIGINT, @IFWTypeID smallint
DECLARE @FrameworkTypeID SMALLINT,  @FrameworkViewTypeID SMALLINT
DECLARE @RubricRowID BIGINT

SELECT @FrameworkTypeID = FrameworkTypeID FROM dbo.SEFrameworkType WHERE Name='Instructional'
SELECT @FrameworkViewTypeID = FrameworkViewTypeID FROM dbo.SEFrameworkViewType WHERE Name='Instructional Framework Default'
SELECT @IFWTypeID = IFWTypeID from dbo.SEIFWType where Name = 'Danielson'

INSERT SEFramework(FrameworkTypeID, IFWTypeID
	, Name, Description
	, IsPrototype, districtCode, schoolYear, HasBeenModified, HasBeenApproved) 
VALUES(@FrameworkTypeID, @IFWTypeID
	, 'Aberdeen', 'Full Danielson Framework'	
	, 1, '14005', 2011, 0, 1)
SELECT @FrameworkID = SCOPE_IDENTITY()

INSERT SEDistrictConfiguration (districtCode, frameworkViewTypeID)
VALUES ('14005', @FrameworkViewTypeID)


-- Domains
DECLARE @Domain1NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, ShortName, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Planning and Preparation', '', 1, 'Planning and Preparation', 0)
SELECT @Domain1NodeId = SCOPE_IDENTITY()

DECLARE @Domain2NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, ShortName, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'The Classroom Environment', '', 1, 'The Classroom Environment', 0)
SELECT @Domain2NodeId = SCOPE_IDENTITY()

DECLARE @Domain3NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, ShortName, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Instruction', '', 1, 'Instruction', 0)
SELECT @Domain3NodeId = SCOPE_IDENTITY()

DECLARE @Domain4NodeId bigint
INSERT SEFrameworkNode(FrameworkID, ParentNodeID, Title, Description, Sequence, ShortName, IsLeafNode) 
VALUES(@FrameworkID, NULL, 'Professional Responsibilities', '', 1, 'ProfessionalResponsibilities', 0)
SELECT @Domain4NodeId = SCOPE_IDENTITY()

UPDATE stateEval_staging.dbo.DanRR set XferID = newId()
UPDATE stateEval_staging.dbo.DanCOMP set XferID = newId()


INSERT SEFrameworkNode (FrameworkID, Title, description, xferId, ShortName, sequence, IsLeafNode)
select @FrameworkID,   
component, component, xferID, substring(component, 1,1) +  substring(component,11, 2) as shortname
	,ROW_NUMBER() OVER (partition by substring (component, 1, 11) ORDER BY danCompID) AS 'seq', 1
from StateEval_staging.dbo.danComp
order by dancompID

select @frameworkID, @domain1NodeID
select * from stateeval_staging.dbo.dancomp
select * from seFrameworkNode


UPDATE SEFrameworkNode set ParentNodeID = @Domain1NodeId, description='' WHERE ShortName like 'c1%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain2NodeId, description='' WHERE ShortName like 'c2%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain3NodeId, description='' WHERE ShortName like 'c3%' AND FrameworkID=@frameworkID
UPDATE SEFrameworkNode set ParentNodeID = @Domain4NodeId, description='' WHERE ShortName like 'c4%' AND FrameworkID=@frameworkID

--bring over the danielson rubric rows
INSERT SERubricRow(title, Description
	, pl4DEscriptor, pl3Descriptor, pl2Descriptor, pl1Descriptor
	, FrameworkSequence, XferID, IsStateAligned)
SELECT Element, '', l3, l2, l1, l0,  seq, XferID, 0 
from StateEval_staging.dbo.DanRR

--link up the rubric rows with the framework nodes
insert dbo.SERubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence)
select rr.RubricRowID, fn.FrameworkNodeID, rr.FrameworkSequence
from StateEval_staging.dbo.DanComp sc
join StateEval_staging.dbo.DanRR a on a.DanCompId = sc.DanCompID
join dbo.SERubricRow rr on rr.XferID = a.xferID
join dbo.SEFrameworkNode fn on fn.xferID = sc.xferID


--now do the same for state
UPDATE stateEval_staging.dbo.StateCriteria set XferID = newId()

INSERT SEFramework(FrameworkTypeID, IFWTypeID
	, Name, Description
	, IsPrototype, districtCode, schoolYear, HasBeenModified, HasBeenApproved) 
VALUES(1, @IFWTypeID
	, 'Aberdeen', 'Danielson mapping to StateCriteria'	
	, 1, '14005', 2011, 0, 1)
SELECT @FrameworkID = SCOPE_IDENTITY()

INSERT SEFrameworkNode (FrameworkID, Title, description, xferId, ShortName, sequence, IsLeafNode)
select @FrameworkID, name, description, xferID, shortname, sequence, 1
from StateEval_staging.dbo.StateCriteria
order by sequence

INSERT SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, Sequence)

SELECT fn.FrameworkNodeID, rr.RubricRowID, d2sStage.seq
from seFrameworkNode fn
JOIN stateEval_staging.dbo.StateCriteria scStage on scStage.xferID = fn.xferID
JOIN stateEval_staging.dbo.DanRRtoStateCriteria d2sStage 
	on d2sStage.StateCriteriaId = scStage.StateCriteriaID
join stateEval_staging.dbo.DanRR dRRStage on dRRStage.DanRRID = d2sStage.DanRRID
join seRubricRow rr on rr.xferID = dRRStage.xferID
order by fn.shortname, d2sStage.seq

update SERubricRow set IsStateAligned = 1
from SERubricRow rr
join seRubricRowFrameworkNode rrfn on rrfn.RubricRowID = rr.RubricRowID
join seFrameworkNode fn on fn.frameworkNodeID = rrfn.frameworkNodeID
where frameworkID = @FrameworkID

update seFrameworkNode set xferID=null where xferID is not null
update seRubricRow set xferID=null where xferID is not null

/*

select * from seFrameworkNode fn
join seRubricRowFrameworkNode rrfn on rrfn.frameworkNodeID = fn.frameworkNodeID
join seRubricRow rr on rr.rubricrowID = rrfn.rubricrowID
where frameworkID = 2



select * from seframework
*/
