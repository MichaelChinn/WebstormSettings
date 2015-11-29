
/*
0) refresh the xferid fields
a) insert the framework record for the frameworks, and then change the dates to 2014
b) insert the frameworknode records
c) insert the rubric row records
d) select xferids of all the linkd fn/rr for 2013 frameworks into temp table
e) remove xferids for all rr, fn for !2014 frameworks
f) link up fn/rr according to xfer id mapping
*/

INSERT  seframework
        ( name ,
          districtcode ,
          schoolyear ,
          frameworktypeID ,
          ifwtypeid ,
          isPrototype ,
          derivedfromframeworkID ,
          HasBeenModified ,
          HasBeenApproved ,
          xferid,
          StickyID
        )
        SELECT  name ,
                districtcode ,
                2014 ,
                frameworktypeid ,
                ifwtypeid ,
                isprototype ,
                derivedfromframeworkid ,
                hasbeenmodified ,
                hasbeenapproved ,
                xferid,
                StickyID
        FROM    seframework
        WHERE   schoolyear = 2013

UPDATE  serubricrow
SET     XferID = NEWID()
UPDATE  seframeworknode
SET     xferid = NEWID()

CREATE TABLE #t
    (
      rrGuid UNIQUEIDENTIFIER ,
      fnGuid UNIQUEIDENTIFIER ,
      rubricRowID BIGINT ,
      frameworkNodeID BIGINT ,
      sequence INT
    )
INSERT  #t
        ( rubricRowID ,
          frameworkNodeID ,
          rrGuid ,
          fnGUid ,
          sequence
        )
        SELECT  rrfn.rubricRowID ,
                rrfn.frameworkNodeid ,
                rr.xferID ,
                fn.xferid ,
                rrfn.Sequence
        FROM    dbo.SERubricRowFrameworkNode rrfn
                JOIN seRubricRow rr ON rr.RubricRowID = rrfn.RubricRowID
                JOIN seFrameworkNode fn ON fn.FrameworkNodeid = rrfn.FrameworkNodeID
                JOIN seFramework fw ON fw.FrameworkID = fn.FrameworkID
        WHERE   fw.SchoolYear = 2013

DECLARE @maxRR BIGINT, @maxFn BIGINT
SELECT @maxRR = MAX(rubricrowid) FROM dbo.SERubricRow
SELECT @maxFN = MAX(frameworkNodeID) FROM dbo.SEFrameworkNode

INSERT  dbo.SERubricRow
        ( Title ,
          Description ,
          PL1Descriptor ,
          PL2Descriptor ,
          PL3Descriptor ,
          PL4Descriptor ,
          ev1 ,
          ev2 ,
          ev3 ,
          ev4 ,
          XferID ,
          IsStateAligned ,
          BelongsToDistrict ,
          IsStudentGrowthAligned ,
          TitleToolTip ,
          Shortname,
          StickyID
        )
        SELECT  Title ,
                rr.Description ,
                PL1Descriptor ,
                PL2Descriptor ,
                PL3Descriptor ,
                PL4Descriptor ,
                ev1 ,
                ev2 ,
                ev3 ,
                ev4 ,
                rr.XferID ,
                IsStateAligned ,
                rr.BelongsToDistrict ,
                rr.IsStudentGrowthAligned ,
                TitleToolTip ,
                rr.Shortname,
                rr.StickyID
        FROM    dbo.SERubricRow rr
                JOIN dbo.vFrameworkRows fr ON rr.RubricRowID = fr.RubricRowID
                JOIN dbo.SEFramework fw ON fw.frameworkid = fr.frameworkId
        WHERE   fw.schoolyear = 2013
        
       
INSERT  dbo.SEFrameworkNode
        ( FrameworkID ,
          ParentNodeID ,
          Title ,
          ShortName ,
          Description ,
          Sequence ,
          IsLeafNode ,
          XferID ,
          StickyID
        )
        SELECT  fn.FrameworkID + 10 ,
                ParentNodeID ,
                Title ,
                fn.ShortName ,
                fn.Description ,
                fn.Sequence ,
                IsLeafNode ,
                fn.XferID ,
                fn.StickyID
        FROM    dbo.SEFrameworkNode fn             
                JOIN dbo.SEFramework fw ON fw.frameworkid = fn.frameworkId
        WHERE   fw.schoolyear = 2013

UPDATE  serubricrow
SET     xferid = NULL
WHERE   rubricrowid <= @maxRR
UPDATE  seFrameworkNode
SET     xferid = NULL
WHERE   FrameworkNodeID <= @maxFN

UPDATE  #t
SET     rubricRowID = rr.rubricRowID
FROM    #t t
        JOIN seRubricRow rr ON rr.XferID = t.rrGuid
        
UPDATE  #t
SET     frameworkNodeID = fn.FrameworkNodeID
FROM    #t t
        JOIN dbo.SEFrameworkNode fn ON fn.XferID = t.fnGuid

INSERT  dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
        )
        SELECT  frameworkNodeID ,
                rubricRowID ,
                sequence
        FROM    #t
        
        
INSERT dbo.SEFrameworkPerformanceLevel
        ( FrameworkID ,
          PerformanceLevelID ,
          Shortname ,
          FullName ,
          Description
        )
        
        SELECT
        fw.FrameworkID  + 10,
          fpl.PerformanceLevelID ,
          fpl.Shortname ,
          fpl.FullName ,
          fpl.Description
          FROM dbo.SEFrameworkPerformanceLevel fpl
          JOIN dbo.SEFramework fw ON fw.frameworkID = fpl.FrameworkID
          WHERE fw.SchoolYear = 2013

/*
SELECT * FROM dbo.SEFrameworkNode WHERE frameworkid = 43
UPDATE seframeworknode SET frameworkid = frameworkID +10 WHERE frameworkNodeId > 468

SELECT * FROM seframeworkNode WHERE FrameworkNodeID > 468

*/

