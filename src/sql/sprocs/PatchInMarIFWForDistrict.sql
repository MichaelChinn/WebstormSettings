if exists (select * from sysobjects 
where id = object_id('dbo.PatchMarIFWForDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc PatchMarIFWForDistrict.'
      drop procedure dbo.PatchMarIFWForDistrict
   END
GO
PRINT '.. Creating sproc PatchMarIFWForDistrict.'
GO
CREATE PROCEDURE PatchMarIFWForDistrict
 @pDFDistrictCode varchar (20) 
 ,@pDebug bit = 0

AS
SET NOCOUNT ON 
/******************************************************************************************/



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

	DECLARE @marStateFwID BIGINT, @marIFWFwid BIGINT, @protoMarIfwFwid bigint
	SELECT @marStateFWID = frameworkID FROM seFramework WHERE districtcode = @pDFDistrictCode AND FrameworkTypeId=1
	SELECT @protoMarIFWFwid = frameworkID FROM stateeval_proto.dbo.SEFramework WHERE name = 'mar, ifw view'
	
	IF EXISTS (SELECT frameworkId FROM seFramework WHERE DistrictCode=@pDFDistrictCode AND frameworktypeid = 2)
	SELECT @sql_error = -1
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'ifw framework already there for this district' 

		  GOTO ErrorHandler
	   END

	
	--new framework
	INSERT seFramework (Name, [description], districtCode, schoolYear, frameworkTypeID, ifwTypeID, isPrototype ,DerivedFromFrameworkName, hasBeenModified, hasBeenApproved)
	SELECT REPLACE (name, 'TState', 'TInstructional'),'', districtCode, schoolYear, 2, 2, isPrototype, REPLACE(DerivedFromFrameworkName, 'State', 'IFW'), hasBeenModified, hasBeenApproved
	FROM seFramework WHERE frameworkId = @marStateFWID
	SELECT @marIFWFwid = SCOPE_IDENTITY(), @sql_error=@@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem with insert seframework' 

		  GOTO ErrorHandler
	   END

	insert seFrameworkNode(frameworkID, title, shortname, [description], sequence, isLeafNode, xferId, IsStateFramework) 
	SELECT @marIFWFwID, title, shortname, [description], sequence, isLeafNode, xferId, 0
	FROM stateeval_proto.dbo.seFrameworkNode WHERE frameworkid = @protoMarIfwFwid
	SELECT  @sql_error=@@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem inserting nodes' 

		  GOTO ErrorHandler
	   END
	
	CREATE TABLE #MarRR(rrid BIGINT ,title VARCHAR(500))
	INSERT #marRR (rrid, title)
	SELECT rubricRowID, rowtitle FROM dbo.vFrameworkRows WHERE frameworkid = @marStateFwID
	
	IF (@pDebug=1)
	begin
		SELECT 'marzanoRR', * FROM #marRR
		SELECT 'xferids for', * 
		FROM dbo.SERubricRow rr
		JOIN stateeval_proto.dbo.SERubricRow proto ON proto.Title = rr.Title
		JOIN #marRR tempRR ON tempRR.rrid = rr.RubricRowID
		WHERE proto.BelongsToDistrict = 'bmar'
	End
	
	UPDATE dbo.SERubricRow SET xferid = proto.XferID
	FROM dbo.SERubricRow rr
	JOIN stateeval_proto.dbo.SERubricRow proto ON proto.Title = rr.Title
	JOIN #marRR tempRR ON tempRR.rrid = rr.RubricRowID
	WHERE proto.BelongsToDistrict = 'bmar'
	
	SELECT @sql_error=@@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem with rr xferid update' 

		  GOTO ErrorHandler
	   END  
	
	
	INSERT seRubricRowFrameworkNode (FrameworkNodeId, RubricRowId, Sequence)
	SELECT  fn.FrameworkNodeID, rr.RubricRowID, protoRRFN.Sequence
	from dbo.seFrameworkNode fn
	JOIN StateEval_proto.dbo.SEFrameworkNode protofn on protoFN.xferID = fn.xferID
	JOIN StateEval_proto.dbo.SERubricRowFrameworkNode protoRRFN on protoRRFN.FrameworkNodeID = protoFN.FrameworkNodeID
	JOIN StateEval_proto.dbo.SERubricRow protoRR on protoRR.RubricRowID = protoRRFN.RubricRowID
	join dbo.seRubricRow rr on rr.xferID = protoRR.xferID
	WHERE fn.frameworkID = @marifwFwid AND rr.BelongsToDistrict = @pDFDistrictCode
	SELECT @sql_error=@@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem with inserting link records' 

		  GOTO ErrorHandler
	   END
	
	
	INSERT dbo.SEFrameworkPerformanceLevel (FrameworkID, PerformanceLevelID, ShortName, FullName, Description)
	SELECT @marIFWFwid, PerformanceLevelID, ShortName, FullName, proto_fpl.Description
	FROM StateEval_proto.dbo.SEFrameworkPerformanceLevel proto_fpl
	WHERE proto_fpl.FrameworkID = @protoMarIfwFwid
	SELECT @sql_error=@@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem with framework performance level inserts' 

		  GOTO ErrorHandler
	   END
	
	UPDATE dbo.SEDistrictConfiguration SET FrameworkViewTypeID=2 WHERE DistrictCode=@pDFDistrictCode AND EvaluationTypeID=2
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting seDistrictConfiguration' 

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

		SELECT  @sql_error=@@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'problem with inserting district user' 

			  GOTO ErrorHandler
		   END
		
		END  
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
		+ 	' | @pDFDistrictCode =' + @pDFDistrictCode
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



