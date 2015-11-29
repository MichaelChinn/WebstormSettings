IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetUnknownDistricts')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc GetUnknownDistricts.'
        DROP PROCEDURE dbo.GetUnknownDistricts
    END
GO
PRINT '.. Creating sproc GetUnknownDistricts.'
GO
CREATE PROCEDURE GetUnknownDistricts
AS
    SET NOCOUNT ON 

    SELECT DISTINCT
            OSPILegacyCode AS DistrictCode
    FROM    dbo.veDsroles
    WHERE   ospiLegacyCode LIKE '_____'
    EXCEPT
    SELECT  DistrictCode
    FROM    vDistrictName





