/*

use this script by determining the relevant values of the table ids, and using these
to add the proper offsets when inserting new values into the tables:
 - seFramework
 - seFrameworkNode
 - seRubricRow
 - seFrameworkPerformanceLevel


SELECT * from information_schema.columns where table_name = 'seframework'
select * from information_schema.columns where table_name = 'seFrameworkNode'
select * from information_schema.columns where table_name = 'seRubricRow'

SELECT  * FROM dbo.vFrameworkRows fr
JOIN seframework f ON f.FrameworkID = fr.frameworkID
WHERE f.schoolyear = 2015

SELECT * FROM seframework WHERE schoolyear = 2015

--frameworks: 54 - 63
SELECT MIN(FrameworkId), MAX(frameworkId) FROM seframework WHERE schoolYear = 2015  --frameworks: 54 - 63 (10)
SELECT MIN(frameworkNodeId), MAX(frameworkNodeID) FROM seFrameworkNode WHERE frameworkId BETWEEN 54 AND 63 --538-606 (69)
SELECT min(rubricrowid), max (rubricRowId)	--1589-1778  (190)
FROM dbo.SERubricRowFrameworkNode
WHERE FrameworkNodeID BETWEEN 538 AND 606



--setup for verification...
DROP TABLE #vOld
CREATE TABLE #vOld (ft VARCHAR (50), cs bigint)

INSERT #vOld (ft, cs)
SELECT f.name, CHECKSUM(fn.title, rr.title)
FROM seframework f
JOIN dbo.SEFrameworkNode fn ON fn.frameworkid = f.FrameworkID
JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.FrameworkNodeID = fn.FrameworkNodeID
JOIN dbo.SERubricRow rr ON rr.RubricRowID = rrfn.RubricRowID
WHERE schoolyear = 2015

*/

set identity_insert seFramework on
insert seFramework
(
FrameworkID
,Name
,Description
,DistrictCode
,SchoolYear
,FrameworkTypeID
,IFWTypeID
,IsPrototype
,DerivedFromFrameworkId
,HasBeenModified
,HasBeenApproved
,XferID
,StickyID        
)

select
FrameworkID + 10
,Name
,Description
,DistrictCode
,2016
,FrameworkTypeID
,IFWTypeID
,IsPrototype
,DerivedFromFrameworkId
,HasBeenModified
,HasBeenApproved
,null
,StickyID
from seFramework where
frameworkid between 54 and 63
set identity_Insert seFramework off




set identity_insert seFrameworkNode on

insert seframeworkNode
(
FrameworkNodeID
,FrameworkID
,ParentNodeID
,Title
,ShortName
,Description
,Sequence
,IsLeafNode
,XferID
,StickyID
)

select
FrameworkNodeID + 69
,FrameworkID + 10
,ParentNodeID
,Title
,ShortName
,Description
,Sequence
,IsLeafNode
,Null
,StickyID
from seFrameworkNode
where frameworkid between 54 and 63

set identity_insert seFrameworkNode off


set identity_insert seRubricRow on

insert seRubricRow 
(
RubricRowID
,Title
,Description
,PL1Descriptor
,PL2Descriptor
,PL3Descriptor
,PL4Descriptor
,ev1
,ev2
,ev3
,ev4
,XferID
,IsStateAligned
,BelongsToDistrict
,IsStudentGrowthAligned
,TitleToolTip
,Shortname
,StickyID
)

select
RubricRowID + 190
,Title
,Description
,PL1Descriptor
,PL2Descriptor
,PL3Descriptor
,PL4Descriptor
,ev1
,ev2
,ev3
,ev4
,null
,IsStateAligned
,BelongsToDistrict
,IsStudentGrowthAligned
,TitleToolTip
,Shortname
,StickyID
from seRubricRow where rubricRowId between 1589 and 1778

set identity_insert seRubricRow OFF


INSERT dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID,
          RubricRowID ,
          Sequence
        )

SELECT  FrameworkNodeID  +69,
        RubricRowID +190 ,
        Sequence
FROM    dbo.SERubricRowFrameworkNode
WHERE   FrameworkNodeID BETWEEN 538 AND 606;



--don't forget...

INSERT  dbo.SEFrameworkPerformanceLevel
        ( FrameworkID ,
          PerformanceLevelID ,
          Shortname ,
          FullName ,
          Description
        )
        SELECT  FrameworkID + 10 ,
                PerformanceLevelID ,
                Shortname ,
                FullName ,
                Description
        FROM    dbo.SEFrameworkPerformanceLevel
        WHERE   frameworkid > 53
        ORDER BY SEFrameworkPerformanceLevelID
/*
DROP TABLE #vNew
CREATE TABLE #vNew (ft VARCHAR (50), cs bigint)

INSERT #vNew (ft, cs)
SELECT f.name, CHECKSUM(fn.title, rr.title)
FROM seframework f
JOIN dbo.SEFrameworkNode fn ON fn.frameworkid = f.FrameworkID
JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.FrameworkNodeID = fn.FrameworkNodeID
JOIN dbo.SERubricRow rr ON rr.RubricRowID = rrfn.RubricRowID
WHERE schoolyear = 2016

SELECT distinct * FROM #vNew n
JOIN #vOld o ON o.ft = n.ft AND o.cs = n.cs


SELECT * FROM seFramework WHERE schoolyear = 2016


--make sure everything in the new records points to somewhere in the new record range...

SELECT MIN(FrameworkId), MAX(frameworkId) FROM seframeworknode WHERE FrameworkNodeID > 606
SELECT MIN(RubricRowFrameworkNodeID) FROM dbo.SERubricRowFrameworkNode WHERE frameworknodeid> 606

SELECT MIN(rubricrowid), MIN(frameworkNodeId) FROM dbo.SERubricRowFrameworkNode WHERE RubricRowFrameworkNodeID > 1618
 

*/