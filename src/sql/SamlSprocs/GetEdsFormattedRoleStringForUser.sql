IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.GetEDSFormattedRoleStringForUser')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc GetEDSFormattedRoleStringForUser.';
        DROP PROCEDURE dbo.GetEDSFormattedRoleStringForUser;
    END;
GO
PRINT '.. Creating sproc GetEDSFormattedRoleStringForUser.';
GO
CREATE PROCEDURE GetEDSFormattedRoleStringForUser
    @pSeUserId BIGINT = 0 ,
    @pUserName VARCHAR(50) = '' ,
    @pDebug BIT = 0
AS
    SET NOCOUNT ON; 

    IF @pSeUserId = 0
        SELECT  @pSeUserId = SEUserID
        FROM    dbo.SEUser
        WHERE   Username = @pUserName;

    CREATE TABLE #l
        (
          locationCode VARCHAR(10) ,
          locationName VARCHAR(200) ,
          lrcString VARCHAR(2000)
        );

    INSERT  #l
            ( locationCode ,
              locationName
            )
            SELECT  uds.SchoolCode ,
                    sn.SchoolName
            FROM    dbo.SEUserDistrictSchool uds
                    JOIN vSchoolName sn ON sn.schoolCode = uds.SchoolCode
            WHERE   SEUserID = @pSeUserId
                    AND uds.SchoolCode <> '';

    INSERT  #l
            ( locationCode ,
              locationName
            )
            SELECT  uds.DistrictCode ,
                    dn.DistrictName
            FROM    dbo.SEUserDistrictSchool uds
                    JOIN vDistrictName dn ON dn.districtCode = uds.DistrictCode
            WHERE   SEUserID = @pSeUserId
                    AND uds.SchoolCode = '';

	IF @pDebug=1 SELECT * FROM #l

    DECLARE @roleString VARCHAR(2000);
    SELECT  @roleString = COALESCE(@roleString + ';', '') + RoleName
    FROM    aspnet_Roles r
            JOIN dbo.aspnet_UsersInRoles uir ON uir.RoleId = r.RoleId
            JOIN SEUser su ON su.ASPNetUserID = uir.UserId
    WHERE   su.SEUserID = @pSeUserId;

    UPDATE  #l
    SET     lrcString = locationName + ';' + locationCode + ';' + @roleString;


	IF @pDebug=1 SELECT * FROM #l

    DECLARE @retval VARCHAR(MAX);
    SELECT  @retval = COALESCE(@retVal + +'|', '') + lrcString
    FROM    #l;

	SELECT ISNULL(@retVal, '')