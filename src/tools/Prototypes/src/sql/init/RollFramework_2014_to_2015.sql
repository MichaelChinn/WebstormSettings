INSERT  dbo.SEFramework
        ( Name ,
          Description ,
          DistrictCode ,
          SchoolYear ,
          FrameworkTypeID ,
          IFWTypeID ,
          IsPrototype ,
          DerivedFromFrameworkId ,
          HasBeenModified ,
          HasBeenApproved ,
          XferID ,
          StickyID
        )
        SELECT  Name ,
                Description ,
                DistrictCode ,
                2015 ,
                FrameworkTypeID ,
                IFWTypeID ,
                IsPrototype ,
                DerivedFromFrameworkId ,
                HasBeenModified ,
                HasBeenApproved ,
                XferId ,
                StickyID
        FROM    seframework
        WHERE   schoolyear = 2014
        ORDER BY frameworkID


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
        WHERE   frameworkid > 43
        ORDER BY SEFrameworkPerformanceLevelID



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
        SELECT  FrameworkID + 10 ,
                ParentNodeID ,
                Title ,
                ShortName ,
                Description ,
                Sequence ,
                IsLeafNode ,
                XferId ,
                StickyID
        FROM    seFrameworkNode
        WHERE   FrameworkId BETWEEN 44 AND 53
        ORDER BY FrameworkNodeID

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
          Shortname ,
          StickyID
        )
        SELECT DISTINCT
                Title ,
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
                Shortname ,
                StickyID
        FROM    seRubricRow rr
                JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.RubricRowID = rr.RubricRowID
        WHERE   rr.rubricrowid IN (
                SELECT  rubricrowid
                FROM    dbo.SERubricRowFrameworknode
                WHERE   frameworknodeid BETWEEN 469 AND 537 )  


CREATE TABLE #xLink
    (
      fnX UNIQUEIDENTIFIER ,
      rrX UNIQUEIDENTIFIER ,
      seq INT ,
      fnId BIGINT ,
      rrid BIGINT ,
      fwId BIGINT
    )
INSERT  #xlink
        ( fnX ,
          rrX ,
          seq ,
          fwid
        )
        SELECT  fn.XferID ,
                rr.xferid ,
                rrfn.Sequence ,
                fw.frameworkid
        FROM    seRubricRow rr
                JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID = rrfn.RubricRowID
                JOIN dbo.SEFrameworkNode fn ON fn.FrameworkNodeID = rrfn.frameworkNodeID
                JOIN dbo.SEFramework fw ON fw.FrameworkID = fn.FrameworkID
        WHERE   fw.SchoolYear = 2014
        ORDER BY fw.frameworkid ,
                fn.frameworkNodeid ,
                rrfn.sequence

UPDATE  #xlink
SET     fnId = fn.frameworkNodeid
FROM    seFrameworknode fn
        JOIN #xlink x ON x.fnX = fn.XferID
WHERE   FrameworkID > 53

UPDATE  #xlink
SET     rrid = rr.rubricRowId
FROM    seRubricRow rr
        JOIN #xlink x ON x.rrX = rr.XferID
WHERE   RubricRowID > 1588
	
INSERT  dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
	    )
        SELECT  fnId ,
                rrId ,
                seq
        FROM    #xlink