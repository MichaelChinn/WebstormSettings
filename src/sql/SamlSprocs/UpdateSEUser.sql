IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.UpdateSEUser')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc UpdateSEUser.';
        DROP PROCEDURE dbo.UpdateSEUser;
    END;
GO
PRINT '.. Creating sproc UpdateSEUser.';
GO
CREATE PROCEDURE UpdateSEUser
    @pUserID BIGINT ,
    @pFirstName VARCHAR(50) ,
    @pLastName VARCHAR(50) ,
    @pEmail VARCHAR(1000) = '',
	@pCertNo VARCHAR (20) = '',
	@pDistrictCode VARCHAR(20),
	@pSchoolCode VARCHAR (20)
AS
    SET NOCOUNT ON; 

 ---------------
-- VARIABLES --
---------------
    DECLARE @tran_count INT ,
        @sql_error_message NVARCHAR(1500);

    SELECT  @tran_count = @@TRANCOUNT;

    IF @tran_count = 0
        BEGIN TRANSACTION;
    BEGIN TRY
/************************************************************************/


        UPDATE  dbo.SEUser
        SET     FirstName = @pFirstName ,
                LastName = @pLastName ,
				CertificateNumber = @pCertNo,
				SchoolCode = @pSchoolcode,
				DistrictCode = @pDistrictCode
				
        WHERE   SEUserID = @pUserID;

        IF ( @pEmail <> '' )
            UPDATE  aspnet_Membership
            SET     Email = @pEmail
            FROM    aspnet_Membership m
                    JOIN SEUser su ON su.ASPNetUserID = m.UserId
			WHERE seUserid = @pUserId



	/***********************************************************************/
    END TRY

    BEGIN CATCH

        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + ' >>> ' + @sql_error_message + +' ... "'
                + '| ERROR_MESSAGE: ' + ERROR_MESSAGE() + '| ErrorNumber: '
                + CONVERT(VARCHAR(20), ERROR_NUMBER()) + '| ErrorSeverity: '
                + CONVERT(VARCHAR(20), ERROR_SEVERITY()) + '| ErrorState: '
                + CONVERT(VARCHAR(20), ERROR_STATE()) + '"<<<';

        IF ( ( @tran_count = 0 )
             AND ( @@TRANCOUNT <> 0 )
           )
            BEGIN
                ROLLBACK TRANSACTION;
            END;

        RAISERROR(@sql_error_message, 15, 10);
   
    END CATCH;


    PROC_END:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION;
        END;


GO
GO

