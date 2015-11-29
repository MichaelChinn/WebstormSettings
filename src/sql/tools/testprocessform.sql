
/*
select * from seuser
select * from seframework
select * from sestudentgrowthgoalprocesstype
select * from seform
select * from sestudentGrowthprocesssettings
select * from seframeworknode where frameworkid=8 and shortname in ('C3', 'C6', 'C8')
*/

declare @formid bigint

-- create default form 
insert dbo.seform(districtCode, CreatedByUserId, EvaluationTypeID, Title, SchoolYear)
values('', 210, 2, 'Student Growth Planning Form', 2015)
select @formid = SCOPE_IDENTITY()

insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'TPEP Prompt #1', 0, 1)

insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'TPEP Prompt #2', 0, 2)


insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'TPEP Prompt #3', 0, 3)

insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('', 2, 2015, 'C3', 2, null, @formid)
insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('', 2, 2015, 'C6', 2, null, @formid)
insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('', 2, 2015, 'C8', 2, null, @formid)

insert dbo.seform(districtCode, CreatedByUserId, EvaluationTypeID, Title, SchoolYear)
values('34003', 210, 2, 'Student Growth Planning Form', 2015)
select @formid = SCOPE_IDENTITY()

insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'Prompt #1', 0, 1)

insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'Prompt #2', 0, 2)


insert dbo.seformprompt(formid, prompt, required, sequence)
values(@formid, 'Prompt #3', 0, 3)

insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('34003', 2, 2015, 'C3', 2, null, @formid)
insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('34003', 2, 2015, 'C6', 2, null, @formid)
insert dbo.sestudentgrowthprocesssettings(districtCode, evaluationTypeID, schoolYear, frameworkNodeShortName, processTypeID, offlineArtifactBundleID, InlineFormID)
values('34003', 2, 2015, 'C8', 2, null, @formid)

