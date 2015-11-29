if exists (select * from sysobjects 
where id = object_id('dbo.InsertEDSFormattedRoleClaims') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertEDSFormattedRoleClaims.'
      drop procedure dbo.InsertEDSFormattedRoleClaims
   END
GO
PRINT '.. Creating sproc InsertEDSFormattedRoleClaims.'
GO
CREATE PROCEDURE InsertEDSFormattedRoleClaims
   @pUserName VARCHAR(300)
, @pLocationCDSCode varchar (20)
, @pLocationName VARCHAR (300)
, @pRoleString VARCHAR (300)
, @pDebug INT = 0

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

/***********************************************************************************/
BEGIN


	IF (@pDebug = 1)
		SELECT 'just prior to insert'

    IF NOT EXISTS ( SELECT  LocationRoleClaimID
                    FROM    dbo.LocationRoleClaim
                    WHERE   userName = @pUserName
                            AND locationCode = @pLocationCDSCode
                            AND RoleString = @pRoleString )
        INSERT  dbo.LocationRoleClaim
                ( UserName ,
                  location ,
                  locationCode ,
                  RoleString
                )
        VALUES  ( @pUserName ,
                  @pLocationName ,
                  @pLocationCDSCode ,
                  @pRoleString
                )
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'could not add new locationRoleClaim record' 

		  GOTO ErrorHandler
	   END

END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = '.... In: ' + @ProcName + '. ' + Convert(varchar(20), @sql_error) 
		+ '>>>' + ISNULL(@sql_error_message, '') + '<<<  '
		+ ' ... parameters...'
		+ 	' @pUserName =' + @pUserName
		+ 	' | @pRoleString =' + @pRoleString
		+ 	' | @pLocationName =' + @pLocationName
		+ 	' | @pLocationCDSCode =' + @pLocationCDSCode

        +   '<<<  '

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

