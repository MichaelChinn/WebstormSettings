DECLARE @StickyId1 UNIQUEIDENTIFIER
DECLARE @StickyId2 UNIQUEIDENTIFIER
DECLARE @DistrictCode VARCHAR(10)
DECLARE @RubicRowID BIGINT
DECLARE @FrameworkNodeID BIGINT

SELECT  @StickyId1 = NEWID()
SELECT  @StickyId2 = NEWID()

DECLARE @district VARCHAR(10)
SELECT  @district = 'bprin'
PRINT @DistrictCode
	
INSERT  INTO [dbo].[SERubricRow]
        ( [Title] ,
          [Description] ,
          [PL4Descriptor] ,
          [PL3Descriptor] ,
          [PL2Descriptor] ,
          [PL1Descriptor] ,
          [IsStateAligned] ,
          [BelongsToDistrict] ,
          [IsStudentGrowthAligned] ,
          [ShortName] ,
          [StickyID]
        )
VALUES  ( 'SG 3.5 Provides evidence of student growth that results from the school improvement planning process' ,
          '' ,
          'School improvement planning process results in significant improvement in student academic growth' ,
          'School improvement planning process results in measurable improvement in student academic growth' ,
          'School improvement planning process results in minimal improvement in student academic growth' ,
          'School improvement planning process results in no improvement in student academic growth' ,
          1 ,
          @DistrictCode ,
          1 ,
          'SG 3.5' ,
          @StickyId1
        )
			   
SELECT  @RubicRowID = SCOPE_IDENTITY()
	
SELECT  @FrameworkNodeID = sefn.FrameworkNodeID 
FROM    SEFrameworkNode sefn
        INNER JOIN SEFramework sef ON sef.FrameworkID = sefn.FrameworkID
WHERE   sef.FrameworkID = 49
        AND sefn.ShortName = 'C3'
	
INSERT  INTO [dbo].[SERubricRowFrameworkNode]
        ( [FrameworkNodeID] ,
          [RubricRowID] ,
          [Sequence]
        )
VALUES  ( @FrameworkNodeID ,
          @RubicRowID ,
          5
        )
	
	
INSERT  INTO [dbo].[SERubricRow]
        ( [Title] ,
          [Description] ,
          [PL4Descriptor] ,
          [PL3Descriptor] ,
          [PL2Descriptor] ,
          [PL1Descriptor] ,
          [IsStateAligned] ,
          [BelongsToDistrict] ,
          [IsStudentGrowthAligned] ,
          [ShortName] ,
          [StickyID]
        )
VALUES  ( 'SG 5.5 Provides evidence of student growth of selected teachers' ,
          '' ,
          'Multiple measures of student achievement of selected teachers show significant academic growth' ,
          'Multiple measures of student achievement of selected teachers show measurable academic growth' ,
          'Multiple measures of student achievement of selected teachers show minimal academic growth' ,
          'Multiple measures of student achievement of selected teachers show no academic growth' ,
          1 ,
          @DistrictCode ,
          1 ,
          'SG 5.5' ,
          @StickyId2
        )       
	
SELECT  @RubicRowID = SCOPE_IDENTITY()
	
SELECT  @FrameworkNodeID = sefn.FrameworkNodeID
FROM    SEFrameworkNode sefn
        INNER JOIN SEFramework sef ON sef.FrameworkID = sefn.FrameworkID
WHERE   sef.DerivedFromFrameworkID = 49
        AND sefn.ShortName = 'C5'

	
	
INSERT  INTO [dbo].[SERubricRowFrameworkNode]
        ( [FrameworkNodeID] ,
          [RubricRowID] ,
          [Sequence]
        )
VALUES  ( @FrameworkNodeID ,
          @RubicRowID ,
          5
        )           
               