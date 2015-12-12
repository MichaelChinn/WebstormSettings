-- annie didn't realize that snohomish printed their rubrics with goodest first

select rr.* from seframeworknode fn
join seRubricRowFrameworkNode rrfn on  rrfn.frameworkNodeID = fn.frameworkNodeID
join seRubricRow rr on rr.rubricRowID = rrfn.rubricRowID
where frameworkId in (12,13)


create table #x (seRubricRowID bigint
	,pl4Descriptor text
	,pl3Descriptor text
	,pl2Descriptor text
	,pl1Descriptor text
	)
insert #x (seRubricRowID, pl4Descriptor, pl3Descriptor, pl2Descriptor, pl1Descriptor)
select rr.RubricRowID, pl4Descriptor, pl3Descriptor, pl2Descriptor, pl1Descriptor
from seframeworknode fn
join seRubricRowFrameworkNode rrfn on  rrfn.frameworkNodeID = fn.frameworkNodeID
join seRubricRow rr on rr.rubricRowID = rrfn.rubricRowID
where frameworkId in (12,13)

update serubricrow
set pl4Descriptor = x.pl1Descriptor
	,pl3Descriptor = x.pl2Descriptor
	,pl2Descriptor = x.pl3Descriptor
	,pl1Descriptor = x.pl4Descriptor
from seRubricRow rr
join #x x on x.serubricRowID = rr.rubricRowID
join  seRubricRowFrameworkNode rrfn on  rr.rubricRowID = rrfn.rubricRowID
join seFrameworkNode fn on rrfn.frameworkNodeID = fn.frameworkNodeID
where frameworkId in (12,13)

--fix kennewick pi so that their short names reflect something different

update seFrameworkNode set shortname='K1', title = 'K1' where frameworkNodeID = 25
update seFrameworkNode set shortname='K2', title = 'K2' where frameworkNodeID = 26
update seFrameworkNode set shortname='K3', title = 'K3' where frameworkNodeID = 27
update seFrameworkNode set shortname='K4', title = 'K4' where frameworkNodeID = 28
update seFrameworkNode set shortname='K5', title = 'K5' where frameworkNodeID = 29
update seFrameworkNode set shortname='K6', title = 'K6' where frameworkNodeID = 30
update seFrameworkNode set shortname='K7', title = 'K7' where frameworkNodeID = 31
update seFrameworkNode set shortname='K8', title = 'K8' where frameworkNodeID = 32

--fix north thurston so that the description is the longest string, and the title is a shorter string
update seFrameworkNode set description = title where frameworkID = 7
update seFrameworkNode set title = substring (title, 1, 12) where frameworkID = 7

--fix everyone else so that title looks like 'Domain N' or 'Criteria N', rather than Cn and Dn
select * from seFrameworkNode 
where title like '__'
order by frameworkID

update seFrameworkNode set title = 
case 
	when substring(title, 1,1) = 'd' then 'Domain ' + substring(title, 2,1)
	when substring(title, 1,1) = 'c' then 'Criteria ' + substring(title, 2,1)
	when substring(title, 1,1) = 'k' then 'Kennewick Criteria ' + substring(title, 2,1)
end
where title like '__'


-- fix up the north thurston titles to match up with danielson domain text
update seFrameworkNode set Description = 'Domain 1: Planning and Preparation'       where frameworkID = 7 and frameworkNodeID = 102
update seFrameworkNode set Description = 'Domain 2: The Classroom Environment'      where frameworkID = 7 and frameworkNodeID = 103
update seFrameworkNode set Description = 'Domain 3: Instruction'                    where frameworkID = 7 and frameworkNodeID = 104
update seFrameworkNode set Description = 'Domain 4: Professional Responsibilities'  where frameworkID = 7 and frameworkNodeID = 105



