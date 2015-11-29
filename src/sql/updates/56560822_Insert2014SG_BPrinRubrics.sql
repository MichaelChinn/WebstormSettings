
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime , @NextVersion bigint
SELECT  @ahora = GETDATE()
SELECT @sql_error= 0,@tran_count = @@TRANCOUNT  FROM dbo.updateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 56560822
, @title = '56560822_Insert2014SG_BPrinRubrics'
, @comment = 'this must be done along with companion updates patch, as well as proto change'
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog ( bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

DECLARE @StickyId1 uniqueidentifier
DECLARE @StickyId2 uniqueidentifier
DECLARE @DistrictCode varchar(10)
DECLARE @RubicRowID bigint
DECLARE @FrameworkNodeID bigint


--pull the stickyIds from the proto
SELECT  @stickyId1 = stickyId
FROM    stateeval_proto.dbo.SERubricRow
WHERE   title = 'SG 3.5 Provides evidence of student growth that results from the school improvement planning process'

SELECT  @StickyId2 = stickyId
FROM    stateeval_proto.dbo.SERubricRow
WHERE   title = 'SG 5.5 Provides evidence of student growth of selected teachers'

DECLARE Districts CURSOR FOR 
	Select sef.DistrictCode 
		FROM SEFramework sef
		where sef.SchoolYear = '2014'
		and sef.DerivedFromFrameworkID = 49
		order by 1 asc

OPEN Districts
FETCH NEXT FROM Districts
INTO @DistrictCode

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @DistrictCode
	
	INSERT INTO [dbo].[SERubricRow]
		   ([Title]
		   ,[Description]
		   ,[PL4Descriptor]
		   ,[PL3Descriptor]
		   ,[PL2Descriptor]
		   ,[PL1Descriptor]
		   ,[IsStateAligned]
		   ,[BelongsToDistrict]
		   ,[IsStudentGrowthAligned]
		   ,[ShortName]
		   ,[StickyID])
	 VALUES
		   ('SG 3.5 Provides evidence of student growth that results from the school improvement planning process'
		   ,''
		   ,'School improvement planning process results in significant improvement in student academic growth'
		   ,'School improvement planning process results in measurable improvement in student academic growth'
		   ,'School improvement planning process results in minimal improvement in student academic growth'
		   ,'School improvement planning process results in no improvement in student academic growth'
		   ,1
		   ,@DistrictCode
		   ,1
		   ,'SG 3.5'
		   ,@StickyId1)
			   
	SELECT @RubicRowID = SCOPE_IDENTITY()
	
	SELECT @FrameworkNodeID=FrameworkNodeID
	FROM [dbo].SEFrameworkNode AS sefn
		INNER JOIN [dbo].SEFramework AS sef ON sefn.FrameworkID = sef.FrameworkID 
	WHERE sefn.ShortName = 'C3' and sef.DistrictCode = @DistrictCode

	select @FrameworkNodeID=sefn.FrameworkNodeID from SEFrameworkNode sefn 
	inner join SEFramework sef on sef.FrameworkID = sefn.FrameworkID
	where sef.SchoolYear = '2014'
	and sef.DerivedFromFrameworkID = 49
	and sefn.ShortName = 'C3' 
	and sef.DistrictCode = @DistrictCode
	
	INSERT INTO [dbo].[SERubricRowFrameworkNode]
		([FrameworkNodeID]
		,[RubricRowID]
		,[Sequence])
	Values ( 
		@FrameworkNodeID
		,@RubicRowID
		,5)
	
	
    INSERT INTO [dbo].[SERubricRow]
		   ([Title]
		   ,[Description]
		   ,[PL4Descriptor]
		   ,[PL3Descriptor]
		   ,[PL2Descriptor]
		   ,[PL1Descriptor]
		   ,[IsStateAligned]
		   ,[BelongsToDistrict]
		   ,[IsStudentGrowthAligned]
		   ,[ShortName]
		   ,[StickyID])
	 VALUES
		   ('SG 5.5 Provides evidence of student growth of selected teachers'
		   ,''
		   ,'Multiple measures of student achievement of selected teachers show significant academic growth'
		   ,'Multiple measures of student achievement of selected teachers show measurable academic growth'
		   ,'Multiple measures of student achievement of selected teachers show minimal academic growth'
		   ,'Multiple measures of student achievement of selected teachers show no academic growth'
		   ,1
		   ,@DistrictCode
		   ,1
		   ,'SG 5.5'
		   ,@StickyId2)       
	
	SELECT @RubicRowID = SCOPE_IDENTITY()
	
	select @FrameworkNodeID=sefn.FrameworkNodeID from SEFrameworkNode sefn 
	inner join SEFramework sef on sef.FrameworkID = sefn.FrameworkID
	where sef.SchoolYear = '2014'
	and sef.DerivedFromFrameworkID = 49
	and sefn.ShortName = 'C5' 
	and sef.DistrictCode = @DistrictCode
	
	
	INSERT INTO [dbo].[SERubricRowFrameworkNode]
		([FrameworkNodeID]
		,[RubricRowID]
		,[Sequence])
	VALUES ( 
		@FrameworkNodeID
		,@RubicRowID
		,5)           
                      
    
	FETCH NEXT FROM Districts
	INTO @DistrictCode
END 
CLOSE Districts;
DEALLOCATE Districts;


/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END

GO
