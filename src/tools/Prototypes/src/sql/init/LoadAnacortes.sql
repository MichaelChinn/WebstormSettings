
DECLARE @FrameworkTypeID SMALLINT,  @FrameworkViewTypeID SMALLINT, @FrameworkID bigint
DECLARE @RubricRowID BIGINT, @IFWTypeID smallint

--need a new framework
SELECT @FrameworkTypeID = FrameworkTypeID FROM dbo.SEFrameworkType WHERE Name='State'
SELECT @FrameworkViewTypeID = FrameworkViewTypeID FROM dbo.SEFrameworkViewType WHERE Name='State Framework Only'
SELECT @IFWTypeID = IFWTypeID from dbo.SEIFWType where Name = 'UW 5 Dimensions'

INSERT SEDistrictConfiguration (districtCode, frameworkViewTypeID)
VALUES ('29103', @FrameworkViewTypeID)

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID
		, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) 
VALUES('Anacortes', 'State view only, 5d Based', '29103', 2012, @FrameworkTypeID
			, 1, null, 0, 1, @IFWTypeID)
SELECT @FrameworkID = SCOPE_IDENTITY()

--before we load stuff up, set up new uniq ids in the state criteria and anacortes
-- tables, so we can make sure we can work with what we think we should be
update stateEval_staging.dbo.StateCriteria set XferID = newId();
update stateEval_staging.dbo.Anacortes set XferID = newId();

--for the state criteria, the sequence number is the rownum is the row id...
INSERT SEFrameworkNode (FrameworkID, ParentNodeID, Title, ShortName, Description, Sequence, XferID, IsLeafNode)
select @FrameworkId, null, name, shortname, description, sequence, XferId, 1
from StateEval_staging.dbo.StateCriteria

--bring over the anacortes rubric rows
INSERT SERubricRow(title, Description
	, pl4DEscriptor, pl3Descriptor, pl2Descriptor, pl1Descriptor
	, FrameworkSequence, XferID, IsStateAligned)
SELECT Element, '', l3, l2, l1, l0, seq, XferID, 0 from StateEval_staging.dbo.Anacortes

/*
--sequence numbers
UPDATE seRubricRow set FrameworkSequence = x.seq
from seRubricRow rr 
join stateEval_staging.dbo.anacortes a on a.XferID = rr.XferID
join 
(select anacortesID, StateCriteriaID, element,
row_number() over (partition by StateCriteriaID order by AnacortesID) as SEQ
 from stateEval_staging.dbo.anacortes
) X on x.element = rr.title
*/
--link up the rubric rows with the framework nodes
insert dbo.SERubricRowFrameworkNode (rubricRowID, frameworkNodeID, sequence)
select rr.RubricRowID, fn.FrameworkNodeID, rr.FrameworkSequence
from StateEval_staging.dbo.stateCriteria sc
join StateEval_staging.dbo.anacortes a on a.stateCriteriaID = sc.rowNum
join dbo.SERubricRow rr on rr.XferID = a.xferID
join dbo.SEFrameworkNode fn on fn.xferID = sc.xferID

update dbo.SERubricRow set xferID = null
update dbo.SEFrameworkNode set xferID = null
