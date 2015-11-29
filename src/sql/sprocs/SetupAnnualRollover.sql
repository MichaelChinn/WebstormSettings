if exists (select * from sysobjects 
where id = object_id('dbo.SetupAnnualRollover') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetupAnnualRollover.'
      drop procedure dbo.SetupAnnualRollover
   END
GO
PRINT '.. Creating sproc SetupAnnualRollover.'
GO
CREATE PROCEDURE SetupAnnualRollover
	@pFrameworkSetID BIGINT
	,@sql_error_message VARCHAR(500) OUTPUT

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT


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
	
	UPDATE dbo.SEUserPrompt 
	   SET GUID=newid()  
	 WHERE SchoolYear=@pSchoolYear-1
	   AND DistrictCode=@pDistrictCode
	   AND EvaluationTypeID=@pEvaluationTypeID
	   AND EvalSessionID IS NULL
	   AND EvaluateeID IS NULL
	   AND PRIVATE=0
	   AND Retired=0

	-- Copy forward all the user prompts from the question bank
	INSERT dbo.SEUserPrompt(
			PromptTypeID,
			Title,
			Prompt,
			DistrictCode,
			SchoolCode,
			CreatedByUserID,
			Published,
			Retired,
			EvaluationTypeID,
			PRIVATE,
			CreatedAsAdmin,
			Sequence,
			SchoolYear,
			GUID)
	SELECT  PromptTypeID,
			Title,
			Prompt,
			DistrictCode,
			SchoolCode,
			CreatedByUserID,
			0,
			0,
			@pEvaluationTypeID,
			0,
			CreatedAsAdmin,
			Sequence,
			@pSchoolYear,
			GUID
	  FROM dbo.SEUserPrompt
	 WHERE DistrictCode=@pDistrictCode
	   AND EvaluationTypeID=@pEvaluationTypeID
	   AND SchoolYear=(@pSchoolYear-1)
	   AND EvalSessionID IS NULL
	   AND EvaluateeID IS NULL
	   AND PRIVATE=0
	   AND Retired=0
	   
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert to SEUserPrompt  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

	INSERT dbo.SEUserPromptRubricRowAlignment(
			UserPromptID,
			RubricRowID)
  	SELECT DISTINCT
  		   p_new.UserPromptID,
		   rr_new.RubricRowID
	  FROM dbo.SEUserPrompt p_new
	  JOIN dbo.SEUserPrompt p_old ON p_new.GUID=p_old.GUID
	  JOIN dbo.SEUserPromptRubricRowAlignment a_old ON p_old.UserPromptID=a_old.UserPromptID
	  JOIN dbo.SERubricRow rr_old ON a_old.RubricRowID=rr_old.RubricRowID
	  JOIN dbo.SERubricRowFrameworkNode rrfn_old ON rr_old.RubricRowID=rrfn_old.RubricRowID
	  JOIN dbo.SEFrameworkNode fn_old ON rrfn_old.FrameworkNodeID=fn_old.FrameworkNodeID
	  JOIN dbo.SEFramework f_old ON fn_old.FrameworkID=f_old.FrameworkID
	  JOIN dbo.SERubricRow rr_new ON rr_old.StickyID=rr_new.StickyID
	  JOIN dbo.SERubricRowFrameworkNode rrfn_new ON rr_new.RubricRowID=rrfn_new.RubricRowID
	  JOIN dbo.SEFrameworkNode fn_new ON rrfn_new.FrameworkNodeID=fn_new.FrameworkNodeID
	  JOIN dbo.SEFramework f_new ON fn_new.FrameworkID=f_new.FrameworkID
	 WHERE p_old.SchoolYear=@pSchoolYear-1
	   AND p_new.SchoolYear=@pSchoolYear
	   AND f_old.SchoolYear=@pSchoolYear-1
	   AND f_new.SchoolYear=@pSchoolYear
	   AND f_old.DistrictCode=@pDistrictCode
	   AND f_new.DistrictCode=@pDistrictCode
	   AND f_old.StickyID=f_new.StickyID
	   
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert to SEUserPromptRubricRowAlignment  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
	
	-- Carry forward Evidence Look-fors
	UPDATE rr_new
	   SET rr_new.DESCRIPTION=rr_old.DESCRIPTION   
	  FROM dbo.SERubricRow rr_new
	  JOIN dbo.SERubricRow rr_old ON (rr_new.StickyID=rr_old.StickyID AND rr_new.RubricRowID<>rr_old.RubricRowID)
	  JOIN dbo.SERubricRowFrameworkNode rrfn_old ON rr_old.RubricRowID=rrfn_old.RubricRowID
	  JOIN dbo.SEFrameworkNode fn_old ON rrfn_old.FrameworkNodeID=fn_old.FrameworkNodeID
	  JOIN dbo.SEFramework f_old ON fn_old.FrameworkID=f_old.FrameworkID
	  JOIN dbo.SEFrameworkSet fs_old ON f_old.FrameworkSetID=fs_old.FrameworkSetID
	  JOIN dbo.SERubricRowFrameworkNode rrfn_new ON rr_new.RubricRowID=rrfn_new.RubricRowID
	  JOIN dbo.SEFrameworkNode fn_new ON rrfn_new.FrameworkNodeID=fn_new.FrameworkNodeID
	  JOIN dbo.SEFramework f_new ON fn_new.FrameworkID=f_new.FrameworkID
	  JOIN dbo.SEFrameworkSet fset_new ON f_new.FrameworkSetID=f_new.FrameworkSetID
	 WHERE fset_old.SchoolYear=@pSchoolYear-1
	   AND f_new.SchoolYear=@pSchoolYear
	   AND f_old.DistrictCode=@pDistrictCode
	   AND f_new.DistrictCode=@pDistrictCode
	   AND f_old.StickyID=f_new.StickyID

	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SERubricRow.Description  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
	
	-- Carry forward IsPrincipalAssignmentDelegated
	UPDATE new_config
	   SET new_config.IsPrincipalAssignmentDelegated=old_config.IsPrincipalAssignmentDelegated
	  FROM dbo.SESchoolConfiguration new_config
	  JOIN dbo.SESchoolConfiguration old_config ON new_config.SchoolCode=old_config.SchoolCode
	 WHERE new_config.DistrictCode=old_config.DistrictCode
	   AND new_config.SchoolYear=@pSchoolYear
	   AND old_config.SchoolYear=@pSchoolYear-1
	   AND old_config.DistrictCode=@pDistrictCode
	   
 
 	-- Carry forward Report titles
	UPDATE new_config
	   SET new_config.FinalReportTitle=old_config.FinalReportTitle
	      ,new_config.ObservationReportTitle=old_config.ObservationReportTitle
		  ,new_config.SelfAssessReportTitle=old_config.SelfAssessReportTitle
	  FROM dbo.SEFrameworkSet new_config
	  JOIN dbo.SEFrameworkSet old_config ON new_config.districtcode=old_config.districtcode
	 WHERE new_config.DistrictCode=old_config.DistrictCode
	   AND new_config.EvaluationTypeID=old_config.EvaluationTypeID
	   AND new_config.SchoolYear=@pSchoolYear
	   AND old_config.SchoolYear=@pSchoolYear-1
	   AND old_config.DistrictCode=@pDistrictCode
	   AND old_config.EvaluationTypeID=@pEvaluationTypeID

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
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


