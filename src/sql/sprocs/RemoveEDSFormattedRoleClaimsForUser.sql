IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.RemoveEDSFormattedRoleClaimsForUser')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc RemoveEDSFormattedRoleClaimsForUser.'
        DROP PROCEDURE dbo.RemoveEDSFormattedRoleClaimsForUser
    END
GO
PRINT '.. Creating sproc RemoveEDSFormattedRoleClaimsForUser.'
GO
CREATE PROCEDURE RemoveEDSFormattedRoleClaimsForUser
    
    @pUserName VARCHAR(50)
AS 
    DELETE dbo.locationRoleClaim WHERE userName = @pUserName
   