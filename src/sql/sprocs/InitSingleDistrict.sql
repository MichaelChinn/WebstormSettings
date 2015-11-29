if exists (select * from sysobjects 
where id = object_id('dbo.InitSingleDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InitSingleDistrict.'
      drop procedure dbo.InitSingleDistrict
   END
GO
PRINT '.. Creating sproc InitSingleDistrict.'
GO
CREATE PROCEDURE InitSingleDistrict
	 @pSrcDistrict VARCHAR (7)
	 ,@pDestDistrict VARCHAR(7)
	 ,@pDistrictName VARCHAR(50)
	 ,@pSchoolYear INT
	 ,@pLeader VARCHAR (10) = ''
	 ,@pDebug INT = 0
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


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'This should not be called from production. In: ' 
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


