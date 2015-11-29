if exists (select * from sysobjects 
where id = object_id('dbo.UpdateSchoolConfig_PrincAssignDelegate') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateSchoolConfig_PrincAssignDelegate.'
      drop procedure dbo.UpdateSchoolConfig_PrincAssignDelegate
   END
GO
PRINT '.. Creating sproc UpdateSchoolConfig_PrincAssignDelegate.'
GO
CREATE PROCEDURE UpdateSchoolConfig_PrincAssignDelegate
	 @pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pIsPrincipalAssignmentDelegated BIT
	,@pSchoolYear SMALLINT
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

UPDATE dbo.SESchoolConfiguration
	SET IsPrincipalAssignmentDelegated=@pIsPrincipalAssignmentDelegated
WHERE SchoolCode=@pSchoolCode
  AND DistrictCode=@pDistrictCode
  AND SchoolYear=@pSchoolYear


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SESchoolConfiguration  failed. In: ' 
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


