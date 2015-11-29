IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.ProcessOSPIUserExport')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc ProcessOSPIUserExport.'
        DROP PROCEDURE dbo.ProcessOSPIUserExport
    END
GO
PRINT '.. Creating sproc ProcessOSPIUserExport.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ProcessOSPIUserExport
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

/***********************************************************************************/
    BEGIN
    
        DECLARE @rowCount BIGINT
        SELECT  @rowcount = COUNT(personId)
        FROM    dbo.veDsUsers
        IF ( @rowcount = 0 )
            BEGIN
                SELECT  @sql_error = -1
                SELECT  @sql_error_message = 'nobody to process' 
                GOTO ErrorHandler
            END

		--the following added to process merged users
        EXEC EDSExport_ProcessMergedUsers -- 0 
     
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'merge user failure' 
                GOTO ErrorHandler
            END
			   
        EXEC EDSExport_RemoveMissing  --I
    
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'remove missing failure' 
                GOTO ErrorHandler
            END
    
        EXEC EDSExport_SetupStaging   -- II
    
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'staging setup failure'
                GOTO ErrorHandler
            END
    
        EXEC EDSExport_PruneStaging  --III
       
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'prune staging failure'
                GOTO ErrorHandler
            END
            
        EXEC EDSExport_SetupNew       -- IV
 
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'setup new failure'
                GOTO ErrorHandler
            END
    
        EXEC EDSExport_ReplaceProperties -- V
    
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'replace properties failure'
                GOTO ErrorHandler
            END

        EXEC EDSExport_InsertEvaluation -- VI
    
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'insert eval failure'
                GOTO ErrorHandler
            END
		
    END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            IF ( @tran_count = 0 )
                AND ( @@TRANCOUNT <> 0 )
                BEGIN
                    ROLLBACK TRANSACTION
                END


            SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                    + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                    + ISNULL(@sql_error_message, '') + '<<<  '

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

    RETURN(@sql_error)

