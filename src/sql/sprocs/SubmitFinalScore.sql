if exists (select * from sysobjects 
where id = object_id('dbo.SubmitFinalScore') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SubmitFinalScore..'
      drop procedure dbo.SubmitFinalScore
   END
GO
PRINT '.. Creating sproc SubmitFinalScore..'
GO
CREATE PROCEDURE SubmitFinalScore
	 @pEvaluateeID		BIGINT
	 ,@pSchoolYear	SMALLINT
	 ,@pDistrictCode VARCHAR(20)
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
   SET HasBeenSubmitted=1
      ,SubmissionDate=getdate()
WHERE EvaluateeID=@pEvaluateeID
  AND SchoolYear=@pSchoolYear
  AND DistrictCode=@pDistrictCode

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEEvaluation  failed. In: ' 
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


