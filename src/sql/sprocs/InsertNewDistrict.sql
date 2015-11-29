if exists (select * from sysobjects 
where id = object_id('dbo.InsertNewDistrict') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertNewDistrict.'
      drop procedure dbo.InsertNewDistrict
   END
GO
PRINT '.. Creating sproc InsertNewDistrict.'
GO
CREATE PROCEDURE InsertNewDistrict
	@pDistrictCode varchar(10)
	,@pDistrictName VARCHAR(200)
	
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


   INSERT dbo.SEDistrictSchool
           ( districtCode ,
             schoolCode ,
             districtSchoolName ,
             isSchool ,
             isSecondary
           )
   VALUES  ( @pdistrictCode , -- districtCode - varchar(10)
             '' , -- schoolCode - varchar(10)
             @pDistrictName , -- districtSchoolName - varchar(100)
             0 , -- isSchool - bit
             0  -- isSecondary - bit
           )

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert new district... '+@pDistrictCode+' ...In: ' 
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


