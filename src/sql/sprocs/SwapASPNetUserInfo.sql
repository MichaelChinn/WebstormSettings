IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.SwapASPNetUserInfo')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc SwapASPNetUserInfo.'
        DROP PROCEDURE dbo.SwapASPNetUserInfo
    END
GO
PRINT '.. Creating sproc SwapASPNetUserInfo.'
GO

CREATE PROCEDURE SwapASPNetUserInfo
    @pAUserId BIGINT ,
    @pBUserId BIGINT
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

		



    DECLARE @AUserName VARCHAR(200) ,
        @ALoweredUserName VARCHAR(200) ,
        @AGUID UNIQUEIDENTIFIER

    SELECT  @AUserName = userName ,
            @ALoweredUserName = lowereduserName ,
            @AGuid = aspnetUserid
    FROM    seuser
    WHERE   seUserid = @pAUserId

	    DECLARE @BUserName VARCHAR(200) ,
        @BLoweredUserName VARCHAR(200) ,
        @BGUID UNIQUEIDENTIFIER

    SELECT  @BUserName = userName ,
            @BLoweredUserName = lowereduserName ,
            @BGuid = aspnetUserid
    FROM    seuser
    WHERE   seUserid = @pBUserId




    UPDATE  seuser
    SET     userName = @AUserName ,
            loweredusername = @ALoweredUserName ,
            ASPNetUserID = @AGUID
    WHERE   seUserid = @pBUserId


    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not update ''B'' SEUser record  failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    UPDATE  seuser
    SET     userName = @BUserName ,
            loweredusername = @BLoweredUserName ,
            ASPNetUserID = @BGUID
    WHERE   seUserid = @pAUserId


    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not update ''A'' SEUser record  failed. In: '
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


