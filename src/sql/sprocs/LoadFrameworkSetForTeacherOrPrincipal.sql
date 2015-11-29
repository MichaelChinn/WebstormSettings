if exists (select * from sysobjects 
where id = object_id('dbo.LoadFrameworkSetForTeacherOrPrincipal') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc LoadFrameworkSetForTeacherOrPrincipal.'
      drop procedure dbo.LoadFrameworkSetForTeacherOrPrincipal
   END
GO
PRINT '.. Creating sproc LoadFrameworkSetForTeacherOrPrincipal.'
GO
CREATE PROCEDURE LoadFrameworkSetForTeacherOrPrincipal
 @pSFDistrictCode varchar (200)
 ,@pDFDistrictCode varchar (20) = ''
 ,@pDFBaseName varchar (200) = ''
 ,@pDFDescription varchar (200) = ''
 ,@pEvalType varchar (200) = 'Teacher'
 ,@pSchoolYear int
 ,@pDebug bit = 0

AS
SET NOCOUNT ON 
/******************************************************************************************

	keep in mind, that you must load *all* the frameworks for teachers, or the principals
	at once.  This is because both the state an Instructional views reference the same rubric
	rows, and if you were to load, say, the teacher Instructional, and teacher State separately,
	you'd have to remember to use the previously loaded rubric rows when you load the state
	view after the IFW view.
	
	This goes for any self evals as well. So, in the case of the consortium, you must load
		teacher State 
		teacher IFW
		teacher Self State
		
	all at once.
	
*/


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
	DECLARE @frameworkTypeID SMALLINT
	DECLARE @EvalTypeID SMALLINT
	DECLARE @IFWTypeID smallint

	DECLARE @IsStateFramework bit
	DECLARE @DerivedFromFrameworkID bigint
	DECLARE @DFID bigint
	DECLARE @IsPrincipalEval BIT
	DECLARE @theDate DATETIME

	SELECT @theDate = GETDATE()
	
	-- set up transferIDs 
	update StateEval_proto.dbo.SEFrameworkNode set XferId = newId()
	update StateEval_proto.dbo.SERubricRow set XferId = newId()
	update StateEval_proto.dbo.SEFramework set XferId = NEWID()
	
	SELECT @IsPrincipalEval = CASE WHEN @pEvalType = 'TEACHER' then 0 else 1 end
	SELECT @EvalTypeID = CASE WHEN @pEvalType = 'TEACHER' then 2 else 1 END
	
	create table #ftIds (frameworkTypeID bigint)
	insert #ftIds (frameworkTypeID)
	select frameworkTypeID from SEFrameworkType
	where IsPrincipalEval = @IsPrincipalEval

	create table #ofids (frameworkID bigint)
	insert #ofids (frameworkID)
	select frameworkId from StateEval_proto.dbo.SEFramework protoF
	JOIN #ftIds ft on ft.frameworkTypeID = protoF.FrameworkTypeID 
	and DistrictCode = @pSFDistrictCode
	AND SchoolYear=@pSchoolYear
	
	DECLARE @nFrameworksToInsert int
	SELECT @nFrameworksToInsert= COUNT(frameworkID) from #ofids
	if (@nFrameworksToInsert =0)
	BEGIN
		SELECT @sql_error = -1
		SELECT @sql_error_message = 'No source frameworks to load!' 
		GOTO ErrorHandler
	END

	If (@pDebug=1) 
	BEGIN
		select @IsPrincipalEval as [PrincipalEval?]
		select 'ftids', * from #ftIds
		select 'ofids', * from #ofids
	END

	if (@pDebug=1) select @pSFDistrictCode as sourceDistrict, @pDFDistrictCode as destDistrict, frameworkID as ofid  from #ofids

	if (@pDFDistrictCode = '')
	BEGIN
		SELECT @pDFDistrictCode = @pSFDistrictCode
				
		if (@pDebug=1)
		begin
			SELECT 'selecting with no new name' , Name, Description, DistrictCode, @pSchoolYear, ft.FrameworkTypeID
					,isPrototype, Name, 0, 1, IFWTypeid, XferID
			FROM StateEval_proto.dbo.SEFramework protoF
			JOIN #ofids o on o.frameworkID = protoF.FrameworkID
			JOIN #ftIds ft on ft.frameworkTypeID = protof.FrameworkTypeID
			WHERE protof.SchoolYear=@pSchoolYear
		END
		
		
		IF exists (select FrameworkID from SEFramework f 
			join #ftids ftid on ftid.FrameworkTypeiD = f.FrameworkTypeID
			where DistrictCode = @pDFDistrictCode AND f.SchoolYear = @pSchoolYear
		)
		BEGIN
			SELECT @sql_error = -1
			SELECT @sql_error_message = 'Attempt to insert extant prototype district' 
			GOTO ErrorHandler
		END
	
		INSERT dbo.SEFramework(LoadDateTime, Name, Description, DistrictCode, SchoolYear, FrameworkTypeID
				, IsPrototype, DerivedFromFrameWorkName, HasBeenModified, HasBeenApproved, IFWTypeID, XferId, EvaluationTypeID, DerivedFromFrameworkID, DerivedFromFrameworkAuthor)
		SELECT @theDate, Name, Description, DistrictCode, @pSchoolYear, ft.FrameworkTypeID
				,isPrototype, Name, 0, 1, IFWTypeid, XferID, @EvalTypeID, CONVERT(INT, protof.FrameworkId), protof.DistrictCode
		FROM StateEval_proto.dbo.SEFramework protoF
		JOIN #ofids o on o.frameworkID = protoF.FrameworkID
		JOIN #ftIds ft on ft.frameworkTypeID = protof.FrameworkTypeID
		WHERE protoF.SchoolYear=@pSchoolYear

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Problem inserting new framework with no new name' 

			  GOTO ErrorHandler
		   END
		  
	END
	ELSE
	BEGIN
		if (@pDebug=1)
		begin
			SELECT 'selecting with new name' , @pDFBaseName + '-' + ft.Name, @pDFDescription, @pDFDistrictCode, @pSchoolYear, ft.FrameworkTypeID
					,isPrototype, protoF.Name, 0, 1, IFWTypeid, XferId
			FROM StateEval_proto.dbo.SEFramework protoF
			JOIN #ofids o on o.frameworkID = protoF.FrameworkID
			JOIN #ftIds tft on tft.frameworkTypeID = protof.FrameworkTypeID
			JOIN SEFrameworkType ft on ft.FrameworkTypeID = tft.frameworkTypeID
			WHERE protof.SchoolYear=@pSchoolYear
		END
		
		IF exists (select FrameworkID from SEFramework f 
			join #ftids ftid on ftid.FrameworkTypeiD = f.FrameworkTypeID
			where DistrictCode = @pDFDistrictCode AND f.SchoolYear = @pSchoolYear
		)
		BEGIN
			SELECT @sql_error = -1
			SELECT @sql_error_message = 'Framework of this (these) type(s) exist for district FOR this year (in new name branch)' 
			GOTO ErrorHandler
		END
		
	
		INSERT dbo.SEFramework(LoadDateTime, Name, Description, DistrictCode, SchoolYear, FrameworkTypeID
				, IsPrototype, DerivedFromFrameWorkName, HasBeenModified, HasBeenApproved, IFWTypeID, XferId, EvaluationTypeID
				, DerivedFromFrameworkID, DerivedFromFrameworkAuthor, StickyID)
		SELECT @theDate, @pDFBaseName + '-' + ft.Name, @pDFDescription, @pDFDistrictCode, @pSchoolYear, ft.FrameworkTypeID
				,isPrototype, protoF.Name, 0, 1, IFWTypeid, XferId, @EvalTypeID
				, CONVERT(INT, protof.FrameworkId), protof.DistrictCode, protoF.StickyID
		FROM StateEval_proto.dbo.SEFramework protoF
		JOIN #ofids o on o.frameworkID = protoF.FrameworkID
		JOIN #ftIds tft on tft.frameworkTypeID = protof.FrameworkTypeID
		JOIN SEFrameworkType ft on ft.FrameworkTypeID = tft.frameworkTypeID
		WHERE protof.SchoolYear=@pSchoolYear		

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Problem inserting into framework with new name' 

			  GOTO ErrorHandler
		   END
						
	END
	 
	-- framework nodes
	DECLARE @SomeRandomFrameworkID bigint
	SELECT @SomeRandomFrameworkID = MAX(FrameworkId) from dbo.SEFramework
	
	INSERT dbo.SEFrameworkNode(FrameworkID, ParentNodeID, Title, ShortName
	, Description, isStateFramework, Sequence, IsLeafNode, XferID, StickyID)
	Select 	@SomeRandomFrameworkID, null, Title, ShortName
	, Description, 0, Sequence, IsLeafNode, XferID, sfn.StickyID
	from StateEval_proto.dbo.SEFrameworkNode sfn
	join #ofids o on o.frameworkID = sfn.frameworkID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into SEFrameworkNode' 

		  GOTO ErrorHandler
	   END

	-- linkup the framework nodes to the right frameworks via the xfer id and the proto db
	update dbo.SEFrameworkNode set FrameworkID = df.FrameworkID
	from dbo.SEFrameworkNode fn
	join StateEval_proto.dbo.SEFrameworkNode sfn on sfn.XferID = fn.XferID
	join StateEval_proto.dbo.SEFramework sf on sf.FrameworkID = sfn.FrameworkID
	join dbo.SEFramework df on df.xferID = sf.xferID
	join #ofids o on o.frameworkID = sf.FrameworkId


	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem linking framework nodes with framework' 

		  GOTO ErrorHandler
	   END

	update dbo.SEFrameworkNode set IsStateFramework = 
		case when f.FrameworkTypeID IN (1,3, 5, 7) then 1 else 0 end
	FROM dbo.SEFrameworkNode fn
	JOIN dbo.SEFramework f on f.FrameworkID = fn.FrameworkID
	JOIN StateEval_proto.dbo.SEFramework sf on sf.XferID = f.XferId
	JOIN #ofids o on o.frameworkID = sf.FrameworkID


	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem updateing isStateFramework flag in SEFrameworkNode' 

		  GOTO ErrorHandler
	   END


	--rubric rows
	
	if (@pDebug=1)
	Begin
	
		select distinct 'rrsToInsert', rr.Title, rr.Description, Pl4Descriptor, pl3Descriptor, pl2descriptor, pl1Descriptor, rr.XferID, @pDFDistrictCode
		from StateEval_proto.dbo.seRubricRow rr
		join StateEval_proto.dbo.SERubricRowFrameworkNode rrfn on rrfn.RubricRowID = rr.RubricRowID
		join StateEval_proto.dbo.SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
		join #ofids o on o.frameworkID = fn.FrameworkID
	
	end
	
	
	
	INSERT dbo.seRubricRow(Title,TitleToolTip, Description, Pl4Descriptor, pl3Descriptor, pl2descriptor, pl1Descriptor, XferID, IsStateAligned, BelongsToDistrict,IsStudentGrowthAligned, shortname, StickyId )
	select distinct rr.Title,rr.TitleToolTip, '', Pl4Descriptor, pl3Descriptor, pl2descriptor, pl1Descriptor, rr.XferID, IsStateAligned, @pDFDistrictCode, IsStudentGrowthAligned, rr.shortname, rr.StickyID
	from StateEval_proto.dbo.seRubricRow rr
	join StateEval_proto.dbo.SERubricRowFrameworkNode rrfn on rrfn.RubricRowID = rr.RubricRowID
	join StateEval_proto.dbo.SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
	join #ofids o on o.frameworkID = fn.FrameworkID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into RubricRow' 

		  GOTO ErrorHandler
	   END

	--insert the link records via the xfer id and the proto fn's & rr's
	INSERT dbo.SERubricRowFrameworkNode (FrameworkNodeId, RubricRowId, Sequence)
	SELECT  fn.FrameworkNodeID, rr.RubricRowID, protoRRFN.Sequence
	from dbo.seFrameworkNode fn
	JOIN StateEval_proto.dbo.SEFrameworkNode protofn on protoFN.xferID = fn.xferID
	JOIN StateEval_proto.dbo.SERubricRowFrameworkNode protoRRFN on protoRRFN.FrameworkNodeID = protoFN.FrameworkNodeID
	JOIN StateEval_proto.dbo.SERubricRow protoRR on protoRR.RubricRowID = protoRRFN.RubricRowID
	join dbo.seRubricRow rr on rr.xferID = protoRR.xferID
	join #ofids o on o.frameworkID = protoFn.FrameworkID
	order by fn.shortname, protoRRFN.Sequence

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem linking rr and fn' 

		  GOTO ErrorHandler
	   END

	INSERT dbo.SEFrameworkPerformanceLevel (FrameworkID, PerformanceLevelID, ShortName, FullName, Description)
	SELECT df.FrameworkID, PerformanceLevelID, ShortName, FullName, proto_fpl.Description
	FROM StateEval_proto.dbo.SEFrameworkPerformanceLevel proto_fpl
	JOIN StateEval_proto.dbo.SEFramework protoF on proto_fpl.frameworkId = protoF.FrameworkID
	join #ofids o on o.frameworkID = protoF.FrameworkID
	JOIN dbo.SEFramework df on df.XferId = protoF.XferID
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting frameworkPerformanceLevels' 

		  GOTO ErrorHandler
	   END
	   
	   
	INSERT dbo.SEDistrictConfiguration (DistrictCode, EvaluationTypeID, FrameworkViewTypeID, SchoolYear)
	values 
		(@pDFDistrictCode
		,case when @IsPrincipalEval=1 then 1 else 2 end 
		,case when exists (
			select frameworkId from dbo.SEFramework f
			join dbo.SEFrameworkType ft on ft.FrameworkTypeID = f.FrameworkTypeID
			where ft.IsStateFramework = 0 and DistrictCode = @pDFDistrictCode
			and ft.IsPrincipalEval = @IsPrincipalEval
			AND f.SchoolYear=@pSchoolYear
		)then 2 else 1 end	--2 is 'has both'; 1 is has only one (which has to be the state)
		,@pSchoolYear)
		
		
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting seDistrictConfiguration' 

		  GOTO ErrorHandler
	   END

	insert dbo.SESchoolConfiguration (DistrictCode, SchoolCode, IsPrincipalAssignmentDelegated, SchoolYear)
	select districtCode, schoolCode, 0, @pSchoolYear
		from vschoolName
		where districtCode = @pDFDistrictCode 
		and schoolCode + CONVERT(VARCHAR(21),@pSchoolYear) not in 
			(select schoolCode + CONVERT(VARCHAR (21),SchoolYear) from dbo.SESchoolConfiguration)
		
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting seSchoolConfiguration' 

		  GOTO ErrorHandler
	   END
	   
	IF (@pDebug=1) 
	   select * from vFramework
	   
	   
	IF exists (select DistrictName from vDistrictName where districtCode = @pDFDistrictCode)
	BEGIN
		if not exists (
			SELECT seUserID from seUser where lastname = @pDFDistrictCode
		)
		BEGIN
			DECLARE @userName varchar (200)
			select @userName = districtName from vDistrictName where districtCode = @pDFDistrictCode 
			exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = @pDFDistrictCode  
				, @pDistrictCode = @pDFDistrictCode, @pEmail = '', @pSchoolCode = ''  , @pUserName =@userName

		END  
	END 
	   
	EXEC @sql_error =  dbo.SetupAnnualRollover @pSchoolYear=@pSchoolYear, @pDistrictCode=@pDFDistrictCode, @pEvaluationTypeID=@EvalTypeID, @sql_error_message=@sql_error_message OUTPUT
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'EXEC SetupAnnualRollover failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	 END
	 
	EXEC @sql_error =  dbo.InsertEvaluation @pEvaluationTypeID=@EvalTypeID, @pSchoolYear=@pSchoolYear, @pDistrictCode=@pDFDistrictCode, @pEvaluateeID=NULL, @sql_error_message=@sql_error_message OUTPUT
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'EXEC InsertEvaluation failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
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
		+ ' ... parameters...'
		+ 	' @pSFDistrictCode =' + @pSFDistrictCode
		+ 	' | @pDFDistrictCode =' + @pDFDistrictCode
		+ 	' | @pDFBaseName =' + @pDFBaseName
		+ 	' | @pDFDescription =' + @pDFDescription
		+ 	' | @pEvalType =' + @pEvalType
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



