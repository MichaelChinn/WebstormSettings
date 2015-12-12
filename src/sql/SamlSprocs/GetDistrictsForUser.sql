IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetDistrictsForUser')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc GetDistrictsForUser.';
        DROP PROCEDURE dbo.GetDistrictsForUser;
    END;
GO
PRINT '.. Creating sproc GetDistrictsForUser.';
GO
CREATE PROCEDURE GetDistrictsForUser @pSEUserId BIGINT
AS
    SET NOCOUNT ON; 

    SELECT DISTINCT
            dn.districtCode ,
            dn.DistrictName
    FROM    vDistrictName dn
            JOIN SEUserDistrictSchool uds ON uds.DistrictCode = dn.districtCode
    WHERE   SEUserID = @pSEUserId
    ORDER BY dn.DistrictName;




