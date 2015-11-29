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
        
        /*... locationtRoleClaim has been deprecated... 
        INSERT  #absent
                ( userName
                )
                SELECT  lrc.username
                FROM    dbo.locationRoleClaim lrc
                        JOIN aspnet_users au ON au.userName = lrc.userName
                WHERE   lrc.userName NOT LIKE '__msi!x_us%'
                EXCEPT
                SELECT  CONVERT(VARCHAR(20), personid) + '_edsUser' AS username
                FROM    vedsroles
                
               */
                             
        INSERT  #absent
                ( userName
                )
                SELECT  username
                FROM    dbo.aspnet_Users u
                        JOIN aspnet_usersInRoles uir ON uir.userID = u.userid
                WHERE   username NOT IN ( SELECT    userName
                                          FROM      #absent )
                        AND userName LIKE '%_edsUser'
                        AND username NOT LIKE '__msi%'
                     
                EXCEPT
                SELECT  CONVERT(VARCHAR(20), personid) + '_edsUser' AS username
                FROM    vedsroles                 

		/* ... location role claim has been deprecated
        DELETE  dbo.locationRoleClaim
        WHERE   LocationRoleClaimID IN (
                SELECT  locationRoleClaimId
                FROM    dbo.locationRoleClaim lrc
                        JOIN #absent a ON a.userName = lrc.UserName )
                              

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete lrc records of unpresent persons from locationRoleClaim' 

                GOTO ErrorHandler
            END
            */
        DELETE  dbo.aspnet_usersInRoles
        WHERE   userid IN (
                SELECT  u.userID
                FROM    #absent a
                        JOIN aspnet_users u ON u.username = a.userName )

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete persons aspnet_usersInRoles records' 

                GOTO ErrorHandler
            END
        
/*         
        DELETE  FROM aspnet_membership
        WHERE   userID IN ( SELECT  u.userId
                            FROM    aspnet_users u
                                    JOIN #absent a ON a.userName = u.userName )
              
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete persons aspnet_users records' 
                GOTO ErrorHandler
            END
       
        DELETE  FROM dbo.aspnet_Profile
        WHERE   userID IN ( SELECT  u.userId
                            FROM    aspnet_users u
                                    JOIN #absent a ON a.userName = u.userName )
       
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete persons aspnet_users records' 
                GOTO ErrorHandler
            END
         
        DELETE  dbo.aspnet_users
        WHERE   userName IN ( SELECT    userName
                              FROM      #absent )


        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t delete persons aspnet_users records' 

                GOTO ErrorHandler
            END
         
        UPDATE  dbo.seUser
        SET     aspnetUserID = NULL
        WHERE   userName IN ( SELECT    userName
                              FROM      #absent )


        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Couldn''t update seUser with null aspnetUserId records' 

                GOTO ErrorHandler
            END
*/         		
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

