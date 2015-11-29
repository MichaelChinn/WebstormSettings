IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetUnknownSchools')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc GetUnknownSchools.'
        DROP PROCEDURE dbo.GetUnknownSchools
    END
GO
PRINT '.. Creating sproc GetUnknownSchools.'
GO
CREATE PROCEDURE GetUnknownSchools
AS
    SET NOCOUNT ON 

    SELECT DISTINCT
            OSPILegacyCode AS SchoolCode
    FROM    dbo.veDsroles
    WHERE   ospiLegacyCode LIKE '____'
    EXCEPT
    SELECT  SchoolCode
    FROM    vSchoolName





