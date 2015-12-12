
select * from SEFrameworkNode



insert SEFramework (Name, districtCode, SchoolYear, FrameworkTypeID, IFWTypeID, IsPrototype, HasBeenmodified, HasBeenApproved)
values ('Consortia TI Self**','', '2012', 4, 1, 1, 0, 1)


insert seFrameworkNode(frameworkID, shortname, sequence, isLeafNode, title, description) values (21,	'D1',1,1,'Planning and Preparation' ,'TPlanning and Preparation')
insert seFrameworkNode(frameworkID, shortname, sequence, isLeafNode, title, description) values (21,	'D2',2,1,'The Classroom Environment' ,'The Classroom Environment')
insert seFrameworkNode(frameworkID, shortname, sequence, isLeafNode, title, description) values (21,	'D3',3,1,'Instruction','Instruction')
insert seFrameworkNode(frameworkID, shortname, sequence, isLeafNode, title, description) values (21,	'D4',4,1,'Professional Responsibilities','Professional Responsibilities')
