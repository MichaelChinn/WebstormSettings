if exists (select * from sysobjects 
where id = object_id('dbo.SetEvaluationAreaVisibility') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvaluationAreaVisibility..'
      drop procedure dbo.SetEvaluationAreaVisibility
   END
GO
PRINT '.. Creating sproc SetEvaluationAreaVisibility..'
GO
CREATE PROCEDURE SetEvaluationAreaVisibility
	@pSetForAllTees			BIT	= 0
	,@pEvaluateeID			BIGINT = NULL
	,@pEvaluatorID			BIGINT = NULL
	,@pDistrictCode			VARCHAR(20)
	,@pSchoolYear			 SMALLINT
	,@pEvalTypeID			 SMALLINT
	,@pFINAL_SCORE           BIT = NULL 
	,@pEVAL_COMMENTS         BIT = NULL 
	,@pEVAL_EXCERPTS         BIT = NULL 
	,@pFN_SUMMATIVE_SCORES   BIT = NULL 
	,@pOBSERVATIONS          BIT = NULL 
	,@pRR_SUMMATIVE_SCORES   BIT = NULL 
	,@pFN_EXCERPTS           BIT = NULL 
	,@pRR_ANNOTATIONS		 BIT = NULL 
	,@pEVAL_RECOMMENDATIONS  BIT = NULL 
	,@pREPORT_SNAPSHOTS		 BIT = NULL 

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

IF (@pSetForAllTees=0)
BEGIN
	UPDATE dbo.SEEvalVisibility set
		FinalScoreVisible           = ISNULL(@pFINAL_SCORE, FinalScoreVisible)        
		,EvalCommentsVisible        = ISNULL(@pEVAL_COMMENTS, EvalCommentsVisible)         
		,EvalExcerptsVisible        = ISNULL(@pEVAL_EXCERPTS, EvalExcerptsVisible)          
		,FNSummativeScoresVisible   = ISNULL(@pFN_SUMMATIVE_SCORES, FNSummativeScoresVisible)   
		,ObservationsVisible        = ISNULL(@pOBSERVATIONS, ObservationsVisible)          
		,RRSummativeScoresVisible   = ISNULL(@pRR_SUMMATIVE_SCORES, RRSummativeScoresVisible)   
		,FNExcerptsVisible          = ISNULL(@pFN_EXCERPTS, FNExcerptsVisible)
		,RRAnnotationsVisible       = ISNULL(@pRR_ANNOTATIONS, RRAnnotationsVisible)      
		,EvalRecommendationsVisible = ISNULL(@pEVAL_RECOMMENDATIONS, EvalRecommendationsVisible)
		,ReportSnapshotVisible      = ISNULL(@pREPORT_SNAPSHOTS, ReportSnapshotVisible)
	FROM dbo.SEEvalVisibility v
	JOIN dbo.SEEvaluation e ON v.EvaluationID=e.EvaluationID
	WHERE e.EvaluateeId = @pEvaluateeID
	  AND e.DistrictCode=@pDistrictCode
	  AND e.SchoolYear=@pSchoolYear
	  AND e.EvaluationTypeID=@pEvalTypeID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update Visibility flags for Single TEE  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE BEGIN

	UPDATE dbo.SEEvalVisibility set
		FinalScoreVisible           = ISNULL(@pFINAL_SCORE, FinalScoreVisible)        
		,EvalCommentsVisible        = ISNULL(@pEVAL_COMMENTS, EvalCommentsVisible)         
		,EvalExcerptsVisible        = ISNULL(@pEVAL_EXCERPTS, EvalExcerptsVisible)          
		,FNSummativeScoresVisible   = ISNULL(@pFN_SUMMATIVE_SCORES, FNSummativeScoresVisible)   
		,ObservationsVisible        = ISNULL(@pOBSERVATIONS, ObservationsVisible)          
		,RRSummativeScoresVisible   = ISNULL(@pRR_SUMMATIVE_SCORES, RRSummativeScoresVisible)   
		,FNExcerptsVisible          = ISNULL(@pFN_EXCERPTS, FNExcerptsVisible)
		,RRAnnotationsVisible       = ISNULL(@pRR_ANNOTATIONS, RRAnnotationsVisible)      
		,EvalRecommendationsVisible = ISNULL(@pEVAL_RECOMMENDATIONS, EvalRecommendationsVisible)
		,ReportSnapshotVisible      = ISNULL(@pREPORT_SNAPSHOTS, ReportSnapshotVisible)
	FROM dbo.SEEvalVisibility v
	JOIN dbo.SEEvaluation e ON v.EvaluationID=e.EvaluationID	
	WHERE e.EvaluatorID = @pEvaluatorID
	  AND e.DistrictCode=@pDistrictCode
	  AND e.SchoolYear=@pSchoolYear
	  AND e.EvaluationTypeID=@pEvalTypeID
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update Visibility flags for TEES of evaluator... '+ @pEvaluatorID +'.   failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

END

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


