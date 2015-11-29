IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.ChangeMobileAccessKey')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc ChangeMobileAccessKey.'
        DROP PROCEDURE dbo.ChangeMobileAccessKey
    END
GO
PRINT '.. Creating sproc ChangeMobileAccessKey.'
GO
SET QUOTED_IDENTIFIER ON
go 
CREATE PROCEDURE dbo.ChangeMobileAccessKey
    @pUserID BIGINT
AS
    SET NOCOUNT ON 


UPDATE SEUser SET MobileAccessKey=NEWID() WHERE SEUserID=@pUserID
SELECT MobileAccessKey FROM SEUser WHERE SEUserID=@pUserID
