if exists (select * from sysobjects 
where id = object_id('dbo.DeleteFrameworkSetForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteFrameworkSetForDistrict.'
      drop procedure dbo.DeleteFrameworkSetForDistrict
   END
GO
PRINT '.. Creating sproc DeleteFrameworkSetForDistrict.'
GO
CREATE PROCEDURE DeleteFrameworkSetForDistrict
@pDistrictCode varchar(20)
,@pRemoveType varchar (20)
,@pDebug bit = 0

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

/***********************************************************************************/
BEGIN

	create table #frameworkTypesToDelete (frameworkTypeID smallint)
	if (@pRemoveType like 'p%')
	BEGIN
		INSERT #frameworkTypesToDelete(frameworkTypeID)
		SELECT FrameworkTypeID from dbo.SEFrameworkType where Name like 'p%'
	END
	ELSE BEGIN
		INSERT #frameworkTypesToDelete(frameworkTypeID)
		SELECT FrameworkTypeID from dbo.SEFrameworkType where Name like 't%'
	END
	
	create table #frameworksToDelete (frameworkID bigint)
	insert #frameworksToDelete (frameworkID)
	select frameworkID from dbo.SEFramework f
	join #frameworkTypesToDelete fttd on fttd.frameworkTypeID = f.FrameworkTypeID
	where f.DistrictCode=@pDistrictCode

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting frameworksToDelete temp table' 

		  GOTO ErrorHandler
	   END


	create table #rrToDelete (rubricRowID bigint)
	insert #rrToDelete
	select RubricRowID 
	from dbo.SERubricRowFrameworkNode rrfn
	join dbo.SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
	join #frameworksToDelete ftd on ftd.frameworkID = fn.FrameworkID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into rrToDelete temp table' 

		  GOTO ErrorHandler
	   END
	   
	if (@pDebug=1)
	BEGIN
		select 'frameworkTypesToDelete', Name from SEFrameworkType where FrameworkTypeID in
			(select FrameworkTypeID from #frameworkTypesToDelete)
		select 'rubricrowframeworkNodeToDelete', fn.FrameworkNodeID, fn.ShortName, rr.RubricRowID, rr.Title 
		  from SERubricRowFrameworkNode rrfn
		  join SEFrameworkNode fn on rrfn.FrameworkNodeID=fn.FrameworkNodeID
		  join SERubricRow rr on rrfn.RubricRowID=rr.RubricRowID
		  where rr.RubricRowID in
			(select RubricRowID from #rrToDelete)
		    order by fn.FrameworkNodeId, rr.RubricRowID
		select 'rubricrowToDelete', RubricRowID, Title from SERubricRow where RubricRowID in 
			(select RubricRowID from #rrToDelete)
			order by RubricRowID
		select 'frameworkNodeToDelete', FrameworkNodeID, f.DistrictCode, ShortName, TItle from SEFrameworkNode fn
		  join SEFramework f on fn.FrameworkID=f.FrameworkID
		 where f.FrameworkID in
			(select FrameworkID from #frameworksToDelete)
			order by f.FrameworkID, FrameworkNodeID
	    select 'frameworToDelete', FrameworkID, DistrictCode, Name from SEFramework where FrameworkID in
			(select FrameworkID from #frameworksToDelete)
			order by FrameworkID

	END

	--select 'delete dbo.SERubricRowFrameworkNode where RubricRowId = ' + CONVERT(varchar (20), rubricRowID) from #rrToDelete
	delete dbo.SERubricRowFrameworkNode where rubricRowID in 
	(select RubricRowID from #rrToDelete)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem deleting the link table seRubricRowToFrameworkNode' 

		  GOTO ErrorHandler
	   END


	--select 'delete dbo.serubricRow where RubricRowID = ' + CONVERT(varchar(20), rubricRowID) from #rrToDelete
	delete dbo.SERubricRow where RubricRowID in 
	(select RubricRowID from #rrToDelete)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem deleting rubric row' 

		  GOTO ErrorHandler
	   END
	
	--select 'delete dbo.seFrameworkNode where FrameworkID = ' + CONVERT(varchar(20), frameworkID) from #frameworksToDelete
	delete dbo.SEFrameworkNode where FrameworkID in
	(select FrameworkID from #frameworksToDelete)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem deleting the frameworknode' 

		  GOTO ErrorHandler
	   END
	  
	--select 'delete dbo.seFrameworkPerformanceLevel where FrameworkID = '  + CONVERT(varchar(20), frameworkID) from #frameworksToDelete
	delete dbo.SEFrameworkPerformanceLevel where FrameworkID in
	(select FrameworkID from #frameworksToDelete)


	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem deleting the framework performance Levels' 

		  GOTO ErrorHandler
	   END

    --select 'delete dbo.seFramework where frameworkID = '  + CONVERT(varchar(20), frameworkID) from #frameworksToDelete
	delete dbo.SEFramework where FrameworkID in
	(select FrameworkID from #frameworksToDelete)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem deleting the frameworks' 

		  GOTO ErrorHandler
	   END
	   
	--select 'delete dbo.SEDistrictConfiguration where districtCode = ''' + @pDistrictCode 
	--	+ ''' and EvaluationTypeID = ' + CONVERT(varchar(20), CASE WHEN @pRemoveType like 'p%' then 1 else 2 END)
	delete dbo.SEDistrictConfiguration 
	where DistrictCode = @pDistrictCode
	and EvaluationTypeID = 
		CASE WHEN @pRemoveType like 'p%' then 1 else 2 END
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
	  SELECT @sql_error_message = 'Problem deleting from the district configuration table' 

	  GOTO ErrorHandler
	END
	   	
END
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


	  SELECT @sql_error_message = '.... In: ' + @ProcName + '. ' + Convert(varchar(20), @sql_error) 
		+ '>>>' + ISNULL(@sql_error_message, '') + '<<<  '
		--+ ' ... parameters...'
		--+ 	' @pDistrict =' + convert(varchar(50), isNull(@pDistrictCode , '')) 
		--+ 	' | @pRemoveType =' + convert(varchar(50), isNull(@pRemoveType , '')) 
		  +   '<<<  '



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

RETURN(@sql_error)

GO

