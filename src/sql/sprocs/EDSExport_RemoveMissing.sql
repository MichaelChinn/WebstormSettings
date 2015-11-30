IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_RemoveMissing')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc EDSExport_RemoveMissing.'
        DROP PROCEDURE dbo.EDSExport_RemoveMissing
    END
GO
PRINT '.. Creating sproc EDSExport_RemoveMissing.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_RemoveMissing
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
    
		--have to detect missing district/schools and log error if any found...
		-- however, at the moment, leaving this doing nothing is no more harmful than it used to be
		-- since the two fields in question were always null!!! (see the diff)

		/********/

        CREATE TABLE #absent
            (
              userId UNIQUEIDENTIFIER ,
              userName VARCHAR(200)
            )
	     
        TRUNCATE TABLE #absent 
        
        
        INSERT  #absent
                ( userName
                )
                SELECT  au.UserName
                FROM    dbo.SEUserLocationRole ulr
                        JOIN SEUser su ON su.SEUserID = ulr.SEUserId
                        JOIN aspnet_Users au ON au.UserId = su.ASPNetUserID
						WHERE au.userName LIKE '%edsuser'
                EXCEPT
                SELECT  CONVERT(VARCHAR(20), personid) + '_edsUser' AS username
                FROM    vedsroles;
                
               
        DELETE  dbo.SEUserLocationRole
        WHERE   SEUserId IN (
                SELECT  SEUserID
                FROM    SEUser u
                        JOIN aspnet_Users au ON au.UserId = u.ASPNetUserID
                        JOIN #absent ab ON ab.userName = au.UserName );
                               

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete ULR records of unpresent persons from UserLocationRole' 

                GOTO ErrorHandler
            END
              		
        DELETE  dbo.SEUserDistrictSchool
        WHERE   SEUserID IN (
                SELECT  seUserId
                FROM    seUser su
                        JOIN #absent ab ON ab.userName = su.Username )
	
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t remove seUserDistrictSchool' 

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

