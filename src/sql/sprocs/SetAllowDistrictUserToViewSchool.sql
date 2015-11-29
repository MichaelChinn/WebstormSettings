if exists (select * from sysobjects 
where id = object_id('dbo.SetAllowDistrictUserToViewSchool') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetAllowDistrictUserToViewSchool..'
      drop procedure dbo.SetAllowDistrictUserToViewSchool
   END
GO
PRINT '.. Creating sproc SetAllowDistrictUserToViewSchool..'
GO
CREATE PROCEDURE SetAllowDistrictUserToViewSchool
    @pDistrictUserId BIGINT
   ,@pSchoolYear SMALLINT
   ,@pSchoolCode VARCHAR(20)
   ,@pIsChecked BIT

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

IF (@pIsChecked=0)
BEGIN

DELETE dbo.SEDistrictPRViewing
 WHERE DistrictUserID=@pDistrictUserID
   AND SchoolYear=@pSchoolYear
   AND SchoolCode=@pSchoolCode
   
END
ELSE
BEGIN

IF NOT EXISTS (SELECT SchoolCode 
                 FROM dbo.SEDistrictPRViewing 
                WHERE DistrictUserId=@pDistrictUserId 
                  AND SchoolYear=@pSchoolYear
                  AND SchoolCode=@pSchoolCode)
BEGIN
	INSERT dbo.SEDistrictPRViewing(DistrictUserID, SchoolYear, SchoolCode)
	VALUES (@pDistrictUserId, @pSchoolYear, @pSchoolCode)
		
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SetAllowDistrictUserToViewSchool. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
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


