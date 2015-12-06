INSERT  dbo.SEFramework
        ( Name ,
          DistrictCode ,
          SchoolYear ,
          IsPrototype ,
          DerivedFromFrameworkId ,
          HasBeenModified ,
          HasBeenApproved ,
          XferID ,
          StickyID
        )
        SELECT  'TLIB_' + Name ,
                'TLIBR' ,
                2016,
                IsPrototype ,
                DerivedFromFrameworkId ,
                HasBeenModified ,
                HasBeenApproved ,
                XferId ,
                StickyID
        FROM    seframework
        WHERE   frameworkid IN (34, 35)
        ORDER BY frameworkID


INSERT  dbo.SEFrameworkPerformanceLevel
        ( FrameworkID ,
          PerformanceLevelID ,
          Shortname ,
          FullName ,
          Description
        )
        SELECT  FrameworkID + 40 ,
                PerformanceLevelID ,
                Shortname ,
                FullName ,
                Description
        FROM    dbo.SEFrameworkPerformanceLevel
        WHERE   frameworkid IN (34, 35)
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
        SELECT  FrameworkID + 40 ,
                ParentNodeID ,
                Title ,
                ShortName ,
                Description ,
                Sequence ,
                IsLeafNode ,
                XferId ,
                StickyID
        FROM    seFrameworkNode
        WHERE   FrameworkId IN (34, 35)
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
                'TLIBR' ,
                IsStudentGrowthAligned ,
                TitleToolTip ,
                Shortname ,
                StickyID
        FROM    seRubricRow rr
                JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.RubricRowID = rr.RubricRowID
        WHERE   rr.rubricrowid IN (
                SELECT  rubricrowid
                FROM    dbo.SERubricRowFrameworknode
                WHERE   frameworknodeid BETWEEN 400 AND 411 )  


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
        WHERE   fw.FrameworkID IN (34,35)
        ORDER BY fw.frameworkid ,
                fn.frameworkNodeid ,
                rrfn.sequence


UPDATE  #xlink
SET     fnId = fn.frameworkNodeid
FROM    seFrameworknode fn
        JOIN #xlink x ON x.fnX = fn.XferID
WHERE   FrameworkID IN (74, 75)

UPDATE  #xlink
SET     rrid = rr.rubricRowId
FROM    seRubricRow rr
        JOIN #xlink x ON x.rrX = rr.XferID
WHERE   RubricRowID > 1968
	
INSERT  dbo.SERubricRowFrameworkNode
        ( FrameworkNodeID ,
          RubricRowID ,
          Sequence
	    )
        SELECT  fnId ,
                rrId ,
                seq
        FROM    #xlink


INSERT dbo.SEFrameworkContext
        ( Name ,
          SchoolYear ,
          EvaluationTypeID ,
          StateFrameworkID ,
          InstructionalFrameworkID
        )
VALUES  ( 'Test Librarian Framework' , -- Name - varchar(200)
          2016 , -- SchoolYear - smallint
          3 , -- EvaluationTypeID - smallint
          74 , -- StateFrameworkID - bigint
          75  -- InstructionalFrameworkID - bigint
        )