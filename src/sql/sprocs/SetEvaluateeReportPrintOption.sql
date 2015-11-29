if exists (select * from sysobjects 
where id = object_id('dbo.SetEvaluateeReportPrintOption') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetEvaluateeReportPrintOption..'
      drop procedure dbo.SetEvaluateeReportPrintOption
   END
GO
PRINT '.. Creating sproc SetEvaluateeReportPrintOption..'
GO
CREATE PROCEDURE SetEvaluateeReportPrintOption
	 @pEvaluateeID			BIGINT
	,@pSchoolYear			SMALLINT
	,@pReportOptionId		BIGINT
	,@pIsChecked			BIT
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
    
-- delete it if it already exists
DELETE dbo.SEReportPrintOptionEvaluatee
 WHERE EvaluateeID=@pEvaluateeID
   AND ReportPrintOptionID=@pReportOptionID
   AND SchoolYear=@pSchoolYear
          
IF (@pIsChecked = 1)
BEGIN

INSERT dbo.SEReportPrintOptionEvaluatee(ReportPrintOptionID, EvaluateeID, schoolYear)
VALUES (@pReportOptionID, @pEvaluateeID, @pSchoolYear)

END

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEReportPrintOptionUser. In: ' 
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


