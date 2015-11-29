if exists (select * from sysobjects 
where id = object_id('dbo.LoadFrameworkContext') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc LoadFrameworkContext.'
      drop procedure dbo.LoadFrameworkContext
   END
GO
PRINT '.. Creating sproc LoadFrameworkContext.'
GO
CREATE PROCEDURE LoadFrameworkContext
	@pDistrictCode VARCHAR(20)
   ,@pProtoFrameworkContextID BIGINT
   ,@pIsActive BIT = 0

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
	DECLARE @FrameworkContextID BIGINT
	DECLARE @theDate DATETIME
	DECLARE @EvalType SMALLINT
	DECLARE @SchoolYear SMALLINT
	DECLARE @StateFrameworkID BIGINT
	DECLARE @InstructionalFrameworkID BIGINT

	SELECT @theDate = GETDATE()
	
	-- set up transferIDs 
	update StateEval_proto.dbo.SEFrameworkNode set XferId = newId()
	update StateEval_proto.dbo.SERubricRow set XferId = newId()
	update StateEval_proto.dbo.SEFramework set XferId = NEWID()

	INSERT dbo.SEFrameworkContext(
		   Name
		  ,SchoolYear
		  ,DistrictCode
		  ,EvaluationTypeID
		  ,LoadDateTime
		  ,IsActive
		  ,StateFrameworkID
		  ,InstructionalFrameworkID
		  ,ProtoTypeFrameworkContextID
		  ,FrameworkViewTypeID)
	SELECT proto_FS.Name
		  ,proto_FS.SchoolYear
		  ,@pDistrictCode
		  ,proto_FS.EvaluationTypeID
		  ,@theDate
		  ,@pIsActive
		  ,NULL
		  ,NULL
		  ,@pProtoFrameworkContextID
		  ,NULL
	 FROM StateEval_proto.dbo.SEFrameworkContext proto_FS
	WHERE proto_FS.FrameworkContextID=@pProtoFrameworkContextID

	SELECT @FrameworkContextID=SCOPE_IDENTITY()

	DECLARE @FrameworkID BIGINT

	SELECT @StateFrameworkID = StateFrameworkID
	      ,@InstructionalFrameworkID = InstructionalFrameworkID
     FROM StateEval_proto.dbo.SEFrameworkContext protoFS
	WHERE protoFS.FrameworkContextID=@pProtoFrameworkContextID

	-- insert the state framework, if it exists
	IF (@StateFrameworkID IS NOT NULL)
	BEGIN
		INSERT dbo.SEFramework(
			   Name
			  ,FrameworkContextID
			  ,XferId
			  ,ProtoTypeFrameworkID
			  ,StickyID)
		SELECT protoF.Name
			  ,@FrameworkContextID
			  ,protoF.XferID
			  ,protoF.FrameworkID
			  ,protoF.StickyID 
		 FROM StateEval_proto.dbo.SEFrameworkContext protoFS
		 JOIN StateEval_proto.dbo.SEFramework protoF on protoF.FrameworkContextID=protoFS.FrameworkContextID
		WHERE protoFS.FrameworkContextID=@pProtoFrameworkContextID
		  AND protoF.FrameworkID=protoFS.StateFrameworkID
	
		SELECT @FrameworkID=SCOPE_IDENTITY(), @sql_error = @@ERROR
		IF @sql_error <> 0
			BEGIN
				SELECT @sql_error_message = 'Problem inserting into SEFramework' 

				GOTO ErrorHandler
			END

		 UPDATE dbo.SEFrameworkContext
		   SET StateFrameworkID=@FrameworkID
		 WHERE FrameworkContextID=@FrameworkContextID	

	 END
	
	 -- insert the instructional framework, if it exists
	 IF (@InstructionalFrameworkID IS NOT NULL)
	BEGIN
		INSERT dbo.SEFramework(
			   Name
			  ,FrameworkContextID
			  ,XferId
			  ,ProtoTypeFrameworkID
			  ,StickyID)
		SELECT protoF.Name
			  ,@FrameworkContextID
			  ,protoF.XferID
			  ,protoF.FrameworkID
			  ,protoF.StickyID 
		 FROM StateEval_proto.dbo.SEFrameworkContext protoFS
		 JOIN StateEval_proto.dbo.SEFramework protoF on protoF.FrameworkContextID=protoFS.FrameworkContextID
		WHERE protoFS.FrameworkContextID=@pProtoFrameworkContextID
		  AND protoF.FrameworkID=protoFS.InstructionalFrameworkID
	
		SELECT @FrameworkID=SCOPE_IDENTITY(), @sql_error = @@ERROR
		IF @sql_error <> 0
			BEGIN
				SELECT @sql_error_message = 'Problem inserting into SEFramework' 

				GOTO ErrorHandler
			END

		 UPDATE dbo.SEFrameworkContext
		   SET InstructionalFrameworkID=@FrameworkID
		 WHERE FrameworkContextID=@FrameworkContextID	

	 END
	
	 -- set default frameworkviewtype

	 IF (@InstructionalFrameworkID IS NOT NULL)
	 BEGIN
		IF (@StateFrameworkID IS NOT NULL)
		BEGIN
			UPDATE dbo.SEFrameworkContext
			   SET FrameworkViewTypeID=3 -- instructional default
			 WHERE FrameworkContextID=@FrameworkContextID	
	    END
		ELSE
		BEGIN
			 UPDATE dbo.SEFrameworkContext
			   SET FrameworkViewTypeID=4 -- instructional only
			 WHERE FrameworkContextID=@FrameworkContextID	
		END
	END
	ELSE
	BEGIN
		UPDATE dbo.SEFrameworkContext
			SET FrameworkViewTypeID=1 -- state only
			WHERE FrameworkContextID=@FrameworkContextID	
	END
	
	
	-- framework nodes
	
	INSERT dbo.SEFrameworkNode(
		FrameworkID
	   ,ParentNodeID
	   ,Title
	   ,ShortName
	   ,Description
	   ,isStateFramework
	   ,Sequence
	   ,IsLeafNode
	   ,XferID
	   ,StickyID)
	SELECT  f.FrameworkID
		   ,null
		   ,sfn.Title
		   ,ShortName
		   ,sfn.Description
		   ,0
		   ,Sequence
		   ,IsLeafNode
		   ,sfn.XferID
		   ,sfn.StickyID
	FROM StateEval_proto.dbo.SEFrameworkNode sfn
	JOIN StateEval_proto.dbo.SEFramework protoF on protoF.FrameworkID=sfn.FrameworkID
	JOIN dbo.SEFramework f on f.ProtoTypeFrameworkID=protoF.FrameworkID
	JOIN dbo.SEFrameworkContext fs on f.FrameworkContextID=fs.FrameworkContextID
   WHERE fs.FrameworkContextID=@FrameworkContextID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into SEFrameworkNode' 

		  GOTO ErrorHandler
	   END

	--rubric rows

	
	INSERT dbo.SERubricRow(
			Title
		   ,TitleToolTip
		   ,Description
		   ,Pl4Descriptor
		   ,pl3Descriptor
		   ,pl2descriptor
		   ,pl1Descriptor
		   ,XferID
		   ,IsStateAligned
		   ,IsStudentGrowthAligned
		   ,shortname
		   ,StickyId )
	SELECT DISTINCT
		    rr.Title
		   ,rr.TitleToolTip
		   ,''
		   ,Pl4Descriptor
		   ,pl3Descriptor
		   ,pl2descriptor
		   ,pl1Descriptor
		   ,rr.XferID
		   ,IsStateAligned
		   ,IsStudentGrowthAligned
		   ,rr.shortname
		   ,rr.StickyID
	FROM StateEval_proto.dbo.SERubricRow rr
	JOIN StateEval_proto.dbo.SERubricRowFrameworkNode rrfn on rrfn.RubricRowID = rr.RubricRowID
	JOIN StateEval_proto.dbo.SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
	JOIN StateEval_proto.dbo.SEFramework f on f.FrameworkID=fn.FrameworkID
    JOIN StateEval_proto.dbo.SEFrameworkContext fs on f.FrameworkContextID=fs.FrameworkContextID
   WHERE fs.FrameworkContextID=@pProtoFrameworkContextID
     AND fs.StateFrameworkID=f.FrameworkID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into RubricRow' 

		  GOTO ErrorHandler
	   END

	--insert the link records via the xfer id and the proto fn's & rr's
	INSERT dbo.SERubricRowFrameworkNode (
			FrameworkNodeId
		   ,RubricRowId
		   ,Sequence)
	SELECT  fn.FrameworkNodeID
		   ,rr.RubricRowID
		   ,protoRRFN.Sequence
	  FROM  dbo.seFrameworkNode fn
	  JOIN StateEval_proto.dbo.SEFrameworkNode protofn on protoFN.xferID = fn.xferID
	  JOIN StateEval_proto.dbo.SERubricRowFrameworkNode protoRRFN on protoRRFN.FrameworkNodeID = protoFN.FrameworkNodeID
	  JOIN StateEval_proto.dbo.SERubricRow protoRR on protoRR.RubricRowID = protoRRFN.RubricRowID
	  JOIN dbo.SERubricRow rr on rr.xferID = protoRR.xferID
	  JOIN StateEval_proto.dbo.SEFramework protoF on protoFN.frameworkID=protoF.FrameworkID
	  JOIN dbo.SEFramework f on f.ProtoTypeFrameworkID=protoF.FrameworkID
	  JOIN dbo.SEFrameworkContext fs on f.FrameworkContextID=fs.FrameworkContextID
     WHERE fs.FrameworkContextID=@FrameworkContextID	 
	 ORDER BY fn.shortname, protoRRFN.Sequence

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem linking rr and fn' 

		  GOTO ErrorHandler
	   END

	INSERT dbo.SEFrameworkPerformanceLevel (
		FrameworkID
	   ,PerformanceLevelID
	   ,ShortName
	   ,FullName
	   ,Description)
	SELECT f.FrameworkID
	   ,PerformanceLevelID
	   ,ShortName
	   ,FullName
	   ,proto_fpl.Description
	FROM StateEval_proto.dbo.SEFrameworkPerformanceLevel proto_fpl
	JOIN StateEval_proto.dbo.SEFramework protoF on proto_fpl.frameworkId = protoF.FrameworkID
	JOIN StateEval_proto.dbo.SEFrameworkContext protoFS on protoF.FrameworkContextID=protoFS.FrameworkContextID
	JOIN dbo.SEFramework f on f.ProtoTypeFrameworkID=protoF.FrameworkID
	JOIN dbo.SEFrameworkContext fs on f.FrameworkContextID=fs.FrameworkContextID
   WHERE fs.FrameworkContextID=@FrameworkContextID	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting frameworkPerformanceLevels' 

		  GOTO ErrorHandler
	   END
	   
	   
	IF exists (select DistrictName from vDistrictName where districtCode = @pDistrictCode)
	BEGIN
		if not exists (
			SELECT seUserID from seUser where lastname = @pDistrictCode
		)
		BEGIN
			DECLARE @userName varchar (200)
			select @userName = districtName from vDistrictName where districtCode = @pDistrictCode 
			exec dbo.InsertSEUser @pFirstname = 'District', @pLastName = @pDistrictCode  
				, @pDistrictCode = @pDistrictCode, @pEmail = '', @pSchoolCode = ''  , @pUserName =@userName

		END  
	END 
	 
	INSERT dbo.SEDistrictConfiguration(
		FrameworkContextID)
	values 
		(@FrameworkContextID)
		
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting seDistrictConfiguration' 

		  GOTO ErrorHandler
	   END


   SELECT @EvalType = EvaluationTypeID
	      ,@SchoolYear=SchoolYear 
	 FROM dbo.SEFrameworkContext 
	WHERE FrameworkContextID=@FrameworkContextID
	

	INSERT dbo.SESchoolConfiguration (DistrictCode, SchoolCode, IsPrincipalAssignmentDelegated, SchoolYear)
	SELECT districtCode, schoolCode, 0, @SchoolYear
	  FROM dbo.vSchoolName
	 WHERE DistrictCode = @pDistrictCode 
	   AND SchoolCode + CONVERT(VARCHAR(21),@SchoolYear) NOT IN
			(SELECT SchoolCode + CONVERT(VARCHAR (21),SchoolYear) FROM dbo.SESchoolConfiguration)
	
	SELECT @sql_error = @@ERROR	
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting seSchoolConfiguration' 

		  GOTO ErrorHandler
	   END

	/* TODO: need to change SEUserPrompt to FK to SEFrameworkContext  
	EXEC @sql_error =  dbo.SetupAnnualRollover @pProtoFrameworkContextID=@FrameworkContextID, @sql_error_message=@sql_error_message OUTPUT
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'EXEC SetupAnnualRollover failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	 END
	 */

	EXEC @sql_error =  dbo.InsertEvaluation @pEvaluationTypeID=@EvalType, @pSchoolYear=@SchoolYear, @pDistrictCode=@pDistrictCode, @pEvaluateeID=NULL, @sql_error_message=@sql_error_message OUTPUT
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
		+ 	' @pDistrictCode =' + @pDistrictCode
		+ 	' | @pProtoFrameworkContextID =' + @pProtoFrameworkContextID
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



