if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvaluateeNextYearFocusFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvaluateeNextYearFocusFrameworkNode.'
      drop procedure dbo.UpdateEvaluateeNextYearFocusFrameworkNode
   END
GO
PRINT '.. Creating sproc UpdateEvaluateeNextYearFocusFrameworkNode.'
GO
CREATE PROCEDURE UpdateEvaluateeNextYearFocusFrameworkNode
	@pEvaluateeID BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pFocusedFrameworkNodeID BIGINT
	,@pFocusedSGFrameworkNodeID BIGINT
	,@pEvaluationTypeID SMALLINT
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

UPDATE dbo.SEEvaluation
   SET NextYearFocusedFrameworkNodeID=@pFocusedFrameworkNodeID,
	   NextYearFocusedSGFrameworkNodeID=@pFocusedSGFrameworkNodeID
 WHERE EvaluateeID=@pEvaluateeID
   AND DistrictCode=@pDistrictCode
   AND SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


-- update the following year's if they selected their new framework for it already
-- if so then we will assume that it's ok to update it because the evaluator wasn't done
-- with the current year's evaluation yet
IF EXISTS ( SELECT EvaluationID 
			  FROM dbo.SEEvaluation 
			 WHERE EvaluateeID=@pEvaluateeID
			   AND DistrictCode=@pDistrictCode
			   AND SchoolYear=@pSchoolYear+1
			   AND EvaluationTypeID=@pEvaluationTypeID)
BEGIN

	DECLARE @FollowingYearFocusFrameworkNodeID BIGINT, @FollowingYearFocusSGFrameworkNodeID BIGINT

	SELECT @FollowingYearFocusFrameworkNodeID = fn_followingYear.FrameworkNodeID
	  FROM dbo.SEFrameworkNode fn_followingYear
	  JOIN dbo.SEFrameworkNode fn_currentYear ON fn_currentYear.StickyID=fn_followingYear.StickyID
	  JOIN dbo.SEFramework f_currentYear ON fn_currentYear.FrameworkID=f_currentYear.FrameworkID
	  JOIN dbo.SEFramework f_followingYear ON fn_followingYear.FrameworkID=f_followingYear.FrameworkID
	WHERE f_currentYear.SchoolYear=@pSchoolYear
	  AND f_followingYear.SchoolYear=@pSchoolYear+1
	  AND f_currentYear.DistrictCode=@pDistrictCode
	  AND fn_currentYear.FrameworkNodeID=@pFocusedFrameworkNodeID

	SELECT @FollowingYearFocusSGFrameworkNodeID = fn_followingYear.FrameworkNodeID
	  FROM dbo.SEFrameworkNode fn_followingYear
	  JOIN dbo.SEFrameworkNode fn_currentYear ON fn_currentYear.StickyID=fn_followingYear.StickyID
	  JOIN dbo.SEFramework f_currentYear ON fn_currentYear.FrameworkID=f_currentYear.FrameworkID
	  JOIN dbo.SEFramework f_followingYear ON fn_followingYear.FrameworkID=f_followingYear.FrameworkID
	WHERE f_currentYear.SchoolYear=@pSchoolYear
	  AND f_followingYear.SchoolYear=@pSchoolYear+1
	  AND f_currentYear.DistrictCode=@pDistrictCode
	  AND fn_currentYear.FrameworkNodeID=@pFocusedSGFrameworkNodeID

	UPDATE SEEvaluation
	   SET FocusedFrameworkNodeID=@FollowingYearFocusFrameworkNodeID,
		   FocusedSGFrameworkNodeID=@FollowingYearFocusSGFrameworkNodeID
	 WHERE EvaluateeID=@pEvaluateeID
	   AND DistrictCode=@pDistrictCode
	   AND SchoolYear=@pSchoolYear+1
	   AND EvaluationTypeID=@pEvaluationTypeID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
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


