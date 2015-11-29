if exists (select * from sysobjects 
where id = object_id('dbo.UpdateEvaluateeNextYearPlanType') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateEvaluateeNextYearPlanType.'
      drop procedure dbo.UpdateEvaluateeNextYearPlanType
   END
GO
PRINT '.. Creating sproc UpdateEvaluateeNextYearPlanType.'
GO
CREATE PROCEDURE UpdateEvaluateeNextYearPlanType
	@pDistrictCode VARCHAR(20)
	,@pEvaluateePlanTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pEvaluationTypeID SMALLINT
	,@pEvaluateeID BIGINT
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

UPDATE SEEvaluation SET NextYearEvaluateePlanTypeID=@pEvaluateePlanTypeID
 WHERE DistrictCode=@pDistrictCode
   AND EvaluateeID=@pEvaluateeID
   AND SchoolYear=@pSchoolYear
   AND EvaluationTypeID=@pEvaluationTypeID
   
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEEvaluation  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- update the next year if it has already been set up
UPDATE SEEvaluation SET EvaluateePlanTypeID=@pEvaluateePlanTypeID
 WHERE DistrictCode=@pDistrictCode
   AND EvaluateeID=@pEvaluateeID
   AND SchoolYear=@pSchoolYear+1
   AND EvaluationTypeID=@pEvaluationTypeID
   
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEEvaluation  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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


