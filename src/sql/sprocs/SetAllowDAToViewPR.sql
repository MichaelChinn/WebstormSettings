if exists (select * from sysobjects 
where id = object_id('dbo.SetAllowDAToViewPR') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SetAllowDAToViewPR..'
      drop procedure dbo.SetAllowDAToViewPR
   END
GO
PRINT '.. Creating sproc SetAllowDAToViewPR..'
GO
CREATE PROCEDURE SetAllowDAToViewPR
	@pPrincipalUserId BIGINT
   ,@pDAUserId BIGINT
   ,@pSchoolYear SMALLINT
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

IF NOT EXISTS (SELECT IsChecked 
                 FROM dbo.SEDAPRViewing 
                WHERE DAUserID=@pDAUserId 
                  AND PRUserID=@pPrincipalUserId
                  AND SchoolYear=@pSchoolYear)
BEGIN
	INSERT dbo.SEDAPRViewing(PRUserID, DAUserID, SchoolYear, IsChecked)
	VALUES (@pPrincipalUserId, @pDAUserID, @pSchoolYear, @pIsChecked)
		
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update SetAllowDAToViewPR. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

END
ELSE
BEGIN

UPDATE dbo.[SEDAPRViewing] 
   SET IsChecked = IsChecked       
WHERE PRUserId=@pPrincipalUserID
  AND DAUserId=@pDAUserID
  AND SchoolYear=@pSchoolYear

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SetAllowDAToViewPR. In: ' 
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


