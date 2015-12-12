DECLARE @danState BIGINT, @danIFW BIGINT, @celState BIGINT, @celIFW BIGINT, @marState BIGINT, @marIFW bigint
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Dan, StateView', 'BDAN',2013, 1, 1, 1, NULL, 0, 1)
SELECT @danState = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Dan, IFW View',  'BDAN' ,2013, 2, 1, 1, NULL, 0, 1)
SELECT @danIFW = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('CEL, StateView', 'BCEL',2013, 1, 3, 1, NULL, 0, 1)
SELECT @celState = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('CEL, IFW View',  'BCEL' ,2013, 2, 3, 1, NULL, 0, 1)
SELECT @celIFW = SCOPE_IDENTITY()
/*
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Mar, StateView', 'BMZSV',2013, 1, 2, 1, NULL, 0, 1)
SELECT @marState = SCOPE_IDENTITY()
INSERT seFramework (Name, districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype
,DerivedFromFrameworkID, hasBeenModified, hasBeenApproved)
VALUES ('Mar, IFW View',  'BMAR' ,2013, 2, 2, 1, NULL, 0, 1)
SELECT @marIFW = SCOPE_IDENTITY()
*/


INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @danState, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =1 AND fwcode = 'ste'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @danIFW, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =2 AND fwcode = 'dan'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @celState, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =1 AND fwcode = 'ste'

INSERT seFrameworkNode (frameworkId,ParentNOdeId, title, shortname, description,sequence, isLeafNode )
SELECT @celIFW, NULL, [text], idx, '', id, 1 
FROM stateeval_prePro.dbo.bFrameworkNodes WHERE fwType =2 AND fwcode = 'cel'

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BDAN','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bDanx

INSERT seRubricRow (title, IsStateAligned, BelongsToDistrict
, Description, PL1Descriptor, PL2Descriptor, PL3Descriptor, PL4Descriptor)
SELECT rowTitle, 1, 'BCEL','', [Level 1], [Level 2], [Level 3], [Level 4] FROM StateEval_PrePro.dbo.bCEL

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, bdx.Sequence FROM seFrameworkNode fn
JOIN stateeval_prepro.dbo.bdanx bdx ON bdx.criteria = fn.title
JOIN seRubricRow rr ON rr.title = bdx.RowTitle
WHERE fn.FrameworkID = @danState AND rr.BelongsToDistrict = 'bdan'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 1,2)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = CONVERT(VARCHAR(5), bfn.idx)
WHERE fn.FrameworkID = @danIFW AND bfn.fwcode = 'dan' AND rr.BelongsToDistrict = 'bdan' 
 ORDER BY SUBSTRING(rr.title, 1,2)
 
 


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, bdx.sequence
FROM seFrameworkNode fn
JOIN stateeval_prepro.dbo.bcel bdx ON bdx.critshortname = fn.ShortName
JOIN seRubricRow rr ON bdx.RowTitle = rr.title
WHERE fn.frameworkID = @celState


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT  fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 2, 1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = CONVERT(VARCHAR(5), bfn.idx)
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'p_:%'


INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
SELECT fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 3,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 2) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'se_:%'




INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 3,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 2) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND rr.title LIKE 'cp_:%' AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' 



INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 2,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 1) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'a_:%'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 4,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 3) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'cec_:%'

INSERT dbo.SERubricRowFrameworkNode(FrameworkNodeID, RubricRowID, Sequence        )
select fn.FrameworkNodeID, rr.RubricRowID, ROW_NUMBER() OVER (ORDER BY SUBSTRING(rr.title, 4,1)) 
from seFrameworkNode fn
JOIN stateeval_prepro.dbo.bFrameworkNodes bfn ON bfn.Text = fn.title
JOIN seRubricRow rr ON SUBSTRING(rr.title, 1, 3) = bfn.idx
WHERE fn.FrameworkID = @celIFW AND bfn.fwcode = 'cel' AND rr.BelongsToDistrict = 'bcel' AND rr.title LIKE 'pcc_:%'




insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danState, 4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@danIFW,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CELState, 4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')

insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   1,'UNS',LTRIM('Unsatisfactory'),'Consistently does not meet expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   2,'BAS',LTRIM('Basic         '),'Occasionally meets expected  levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   3,'PRO',LTRIM('Proficient    '),'Consistently meets expected levels of performance')
insert seFrameworkPerformanceLevel(frameworkID, performanceLevelID, shortname, fullname, description)values (@CelIFW,   4,'DIS',LTRIM('Distinguished '),'Clearly and consistently exceeds expected levels of performance')
