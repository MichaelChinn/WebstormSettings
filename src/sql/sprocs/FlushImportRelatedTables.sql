IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.FlushImportRelatedTables')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc FlushImportRelatedTables.'
        DROP PROCEDURE dbo.FlushImportRelatedTables
    END
GO
PRINT '.. Creating sproc FlushImportRelatedTables.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE FlushImportRelatedTables
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

    BEGIN TRY
  
        DELETE  SEUserPromptResponseEntry
        DELETE  seUserPromptResponse
        DELETE  SEEvalVisibility
        DELETE  SEEvaluation
        DELETE  LocationRoleClaim
        WHERE   LocationRoleClaimID > 4
        
        DELETE  aspnet_usersInRoles
        FROM    aspnet_usersInRoles d
                JOIN aspnet_users u ON u.userID = d.UserId
        WHERE   username LIKE '%_edsUser'

        DELETE  aspnet_membership
        FROM    aspnet_membership d
                JOIN aspnet_users u ON u.userID = d.UserId
        WHERE   username LIKE '%_edsUser'

        DELETE  aspnet_profile
        FROM    aspnet_profile d
                JOIN aspnet_users u ON u.userID = d.UserId
        WHERE   username LIKE '%_edsUser'

        DELETE  aspnet_users
        WHERE   userName LIKE '%_edsUser'
        DELETE  seUserDistrictSchool
        WHERE   seUserid > 222
        DELETE  seUser
        WHERE   seUserid > 222
        

        
        DELETE  vedsRoles
        DELETE  vedsUsers

    END TRY
    BEGIN CATCH
  
        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT <> 0 ) 
            BEGIN
                ROLLBACK TRANSACTION
            END


        SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                + ISNULL(@sql_error_message, '') + '<<<  '

        RAISERROR(@sql_error_message, 15, 10)
   
    END CATCH
/***********************************************************************************/
  IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 ) 
        BEGIN
            COMMIT TRANSACTION
        END
        
    RETURN(@sql_error)

