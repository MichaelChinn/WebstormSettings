IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.FetchOTPW')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc FetchOTPW.';
        DROP PROCEDURE dbo.FetchOTPW;
    END;
GO
PRINT '.. Creating sproc FetchOTPW.';
GO
CREATE PROCEDURE FetchOTPW
    @pUserName VARCHAR(256) ,
	@pPwHASHOut VARCHAR (1000) OUTPUT
AS
    SET NOCOUNT ON; 

	SELECT @pPwHASHOut = OTPW
	FROM SEUser WHERE Username = @pUserName