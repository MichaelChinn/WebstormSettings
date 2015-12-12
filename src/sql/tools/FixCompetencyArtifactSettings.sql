update tCompetencyArtifactSettings
   set IsACtive=1
   
-- select * 
  from tCompetencyArtifactSettings cas
  join tCompetencyArtifacts ca on cas.CompetencyArtifactID=ca.CompetencyArtifactID
where cas.EntityID=1034
  and ca.GraduationYear=2015

select * from vEntity_SSI where EntityName like '%Renton%'

select c.Title, ca.Title, * from tCompetencyArtifactSettings cas
  join tCompetencyArtifacts ca on cas.CompetencyArtifactID=ca.CompetencyArtifactID
  join tCompetencies c on ca.CompetencyID=c.CompetencyID
where cas.EntityID=1503 
  and ca.GraduationYear=2014
  and c.Title like '%World%'
  and ca.Title like '%Written%'

9143	1503	1	1	1	9143	3819	NULL	2014	1434	C3B63280-E08D-432D-898F-EF75F37F6A55	OPTIONAL Written Sample		Student will upload an artifact that demonstrates completion of this competency.   	24606	2

delete tCompetencyArtifactSettings where EntityID=1496 and CompetencyArtifactID=9150

insert tCompetencyArtifactSettings(EntityID, SortOrder, IsPublished, IsActive, CompetencyARtifactID)
values(1496, 1,1,1,9150)

select c.EntityID, c.CompetencyID, m.*, * from CompetencySupportingMaterial csm
  join tCompetencies c on csm.CompetencyID=c.CompetencyID
  join tMaterials m on csm.MaterialID=m.MaterialID
 where c.GraduationYear=2014

