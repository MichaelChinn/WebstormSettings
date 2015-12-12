IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.FetchMembershipPW')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc FetchMembershipPW.';
        DROP PROCEDURE dbo.FetchMembershipPW;
    END;
GO
PRINT '.. Creating sproc FetchMembershipPW.';
GO
CREATE PROCEDURE FetchMembershipPW
    @pUserName VARCHAR(256) ,
    @pPasswordFormat INT ,
    @pPwHASHOut VARCHAR(256) OUTPUT ,
    @PSalt VARCHAR(256) OUTPUT
AS
    SET NOCOUNT ON; 

    SELECT  @pPwHASHOut = m.[Password] ,
            @PSalt = m.PasswordSalt
    FROM    aspnet_Users u
            JOIN dbo.aspnet_Membership m ON m.UserId = u.UserId
    WHERE   UserName = @pUserName;