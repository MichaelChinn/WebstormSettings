
declare @oldFW bigint
select @oldFw = frameworkID /*there's only one for anacortes*/
from SEFramework where Name like 'ana%'
--drop table #oldRR
create table #oldRR (rubricRowId bigint)
insert #oldRR 
select rubricRowID from SERubricRowFrameworkNode rrfn
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
join SEFramework f on f.FrameworkID = fn.FrameworkID
where f.Name like 'ana%'

delete SERubricRowFrameworkNode where RubricRowID in (select RubricRowID from #oldRR)
delete SERubricRow where RubricRowID in (select RubricRowID from #oldRR)
delete SEFrameworkNode where FrameworkID in 
(select frameworkID from SEFramework where Name like 'ana%')
delete SEFramework where FrameworkID in 
(select frameworkID from SEFramework where Name like 'ana%')



DECLARE @IfwFwid bigint    INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('AnaTeachIFW', '', '29103', 2012, 2, 1, null, 0, 1, 1)  SELECT @IFWFwid = SCOPE_IDENTITY()
DECLARE @StateFwid bigint  INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('AnaTeachState', '', '29103', 2012, 1, 1, null, 0, 1, 1)  SELECT @StateFwid = SCOPE_IDENTITY()

INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('AnaPrinIFW', '', '29103', 2012, 3, 1, null, 0, 1, 1)  
INSERT SEFramework(Name, Description, DistrictCode, SchoolYear, FrameworkTypeID, IsPrototype, DerivedFromFrameworkID, HasBeenModified, HasBeenApproved, IFWTypeID) VALUES('AnaPrinState', '', '29103', 2012, 3, 1, null, 0, 1, 1) 



--the rubric rows just go in
insert SERubricRow(Title, Description,PL1Descriptor
, PL2Descriptor,PL3Descriptor,PL4Descriptor, BelongsToDistrict)
select  rrtitle, rrdesc, p1, p2, p3, p4,'29103'
from stateeval_prepro.dbo.anaTeach_stateandifw_rr

--the frameworknodes go in by framework
insert seframeworknode (frameworkId, parentNodeID, shortname
, sequence, isLeafnode, title, description) 
select distinct @IfwFwid, null, nShortname,       nSequence, 1, nTitle, nDescription
from stateeval_prepro.dbo.anaTeach_stateandifw_fwn 
where isStateFw = 0 order by nsequence

insert seframeworknode (frameworkId, parentNodeID, shortname
, sequence, isLeafnode, title, description) 
select distinct @StateFwid, null, nShortname,       nSequence, 1, nTitle, nDescription
from stateeval_prepro.dbo.anaTeach_stateandifw_fwn 
where isStateFw = 1 order by nsequence

insert SERubricRowFrameworkNode (FrameworkNodeID, RubricRowID, sequence)
select FrameworkNodeid, rr.RubricRowID, prefn.rrSequence
from seFrameworkNode proFN 
join stateeval_prepro.dbo.anaTeach_stateandifw_fwn preFN on preFN.nShortname = proFN.shortname
join SERubricRow rr on rr.Title = prefn.rrTitle
where proFN.FrameworkID in (@IfwFwid, @StateFwid)
