IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.SaveOTPW')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc SaveOTPW.';
        DROP PROCEDURE dbo.SaveOTPW;
    END;
GO
PRINT '.. Creating sproc SaveOTPW.';
GO
CREATE PROCEDURE SaveOTPW
    @pUserName VARCHAR(256) ,
    @pPWHash VARCHAR(1000)
AS
    SET NOCOUNT ON; 


---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName sysname ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500);


---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID);

------------------
-- TRAN CONTROL --
------------------

    IF @tran_count = 0
        BEGIN TRANSACTION;
    BEGIN TRY

		SELECT @sql_error_message 'save off the password hash'
		UPDATE seuser SET otpw = @pPWHash
		WHERE username = @pUserName
        
        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT = 1 )
            BEGIN
                COMMIT TRANSACTION;
            END;
    END TRY
    
	
    BEGIN CATCH
        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + ' >>> ' + @sql_error_message + +' ... "'
                + ERROR_MESSAGE() + '"<<<';


        IF ( ( @tran_count = 0 )
             AND ( @@TRANCOUNT <> 0 )
           )
            ROLLBACK TRANSACTION;
        RAISERROR(@sql_error_message, 15, 10);

   
    END CATCH;