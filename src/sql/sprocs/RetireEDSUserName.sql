IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.RetireEDSUserName')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc RetireEDSUserName.'
        DROP PROCEDURE dbo.RetireEDSUserName
    END
GO
PRINT '.. Creating sproc RetireEDSUserName.'
GO

CREATE PROCEDURE RetireEDSUserName @pPersonId BIGINT
AS
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
    IF @tran_count = 0
        BEGIN TRANSACTION

		


    DECLARE @RetiredName VARCHAR(200) ,
        @ActiveName VARCHAR(200) ,
        @sPersonId VARCHAR(20)

    SELECT  @sPersonId = CONVERT(VARCHAR(20), @pPersonId)
  

    SELECT  @RetiredName = 'x' + @sPersonId + '_depr' ,
            @ActiveName = @sPersonId + '_edsUser'
      
    UPDATE  seuser
    SET     userName = @RetiredName ,
            loweredusername = @RetiredName
    WHERE   userName = @ActiveName


    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not update SEUser record to retired name. failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    UPDATE  dbo.aspnet_Users
    SET     userName = @RetiredName ,
            loweredusername = @RetiredName
    WHERE   userName = @ActiveName

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not update aspnet_users to retiredName.  failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    DELETE  dbo.LocationRoleClaim
    WHERE   username = @ActiveName

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not remove active name from locationRoleClaim.  failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            ROLLBACK TRANSACTION
            RAISERROR(@sql_error_message, 15, 10)
        END

----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION
        END


GO


