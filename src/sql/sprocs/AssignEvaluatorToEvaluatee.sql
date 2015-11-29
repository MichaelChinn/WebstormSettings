if exists (select * from sysobjects 
where id = object_id('dbo.AssignEvaluatorToEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AssignEvaluatorToEvaluatee.'
      drop procedure dbo.AssignEvaluatorToEvaluatee
   END
GO
PRINT '.. Creating sproc AssignEvaluatorToEvaluatee.'
GO
CREATE PROCEDURE AssignEvaluatorToEvaluatee
	 @pEvaluateeUserID BIGINT
	,@pEvaluatorUserID BIGINT
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
	,@pFirstTime BIT = 1
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


DECLARE @DistrictCode VARCHAR(20)
SELECT @DistrictCode = DistrictCode FROM dbo.SEUser WHERE SEUserID=@pEvaluateeUserID

UPDATE dbo.SEEvaluation
   SET EvaluatorID=@pEvaluatorUserID
 WHERE EvaluateeID=@pEvaluateeUserID
   AND SchoolYear=@pSchoolYear
   AND DistrictCode=@DistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID
   
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- if this is a teacher evaluation and the evaluator is a principal from one of the teacher's schools that isn't
-- the one that is currently in the teachers SEUser record, then we need to update the teacher's SEUser.SchoolCode
-- to match the principal's schoolcode so that the final report will have the evaluator's school code.

IF (@pEvaluationTypeID = 2)
BEGIN

	DECLARE @TeacherSchoolCode VARCHAR(20), @PrincipalSchoolCode VARCHAR(20)

	SELECT @TeacherSchoolCode = SchoolCode FROM SEUser WHERE SEUserID=@pEvaluateeUserID
	SELECT @PrincipalSchoolCode = SchoolCode FROM SEUser WHERE SEUserID=@pEvaluatorUserID

	IF (@TeacherSchoolCode IS NOT NULL AND @PrincipalSchoolCode IS NOT NULL AND @TeacherSchoolCode <> @PrincipalSchoolCode)
	BEGIN

		IF EXISTS (SELECT SchoolCode FROM SEUserDistrictSchool WHERE SEUserID=@pEvaluateeUserID AND SchoolCode=@PrincipalSchoolCode)
		BEGIN
			UPDATE SEUser SET SchoolCode=@PrincipalSchoolCode WHERE SEUserID=@pEvaluateeUserID
			
			SELECT @sql_error = @@ERROR
			IF @sql_error <> 0
			BEGIN
				SELECT @sql_error_message = 'Could not update to SEUser  failed. In: ' 
					+ @ProcName
					+ ' >>>' + ISNULL(@sql_error_message, '')
				GOTO ErrorHandler
			END

		END
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


