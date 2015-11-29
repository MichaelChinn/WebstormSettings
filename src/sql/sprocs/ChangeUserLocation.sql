IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.ChangeUserLocation')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc ChangeUserLocation.'
        DROP PROCEDURE dbo.ChangeUserLocation
    END
GO
PRINT '.. Creating sproc ChangeUserLocation.'
GO
CREATE PROCEDURE ChangeUserLocation
    @pEDSPersonId BIGINT ,
    @pLocationCode VARCHAR(10) ,
    @pRoleString VARCHAR(2000) ,
	@pDebug BIT = 0
AS
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500) ,
        @id BIGINT


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

    DECLARE @seUserid BIGINT ,
        @SchoolCode VARCHAR(10) ,
        @DistrictCode VARCHAR(10) ,
        @SchoolName VARCHAR(200) ,
        @DistrictName VARCHAR(200) ,
        @UserName VARCHAR(50)
		

    SELECT  @userName = CONVERT(VARCHAR(10), @pEDSPersonId) + '_edsUser'
    SELECT  @seUserid = seUserid
    FROM    dbo.SEUser
    WHERE   UserName = @UserName
   
    IF ( LEN(@pLocationCode) = 5 )
        SELECT  @schoolCode = NULL ,
                @DistrictCode = @pLocationCode
    ELSE
        SELECT  @schoolCode = @pLocationCode ,
                @DistrictCode = districtCode
        FROM    SeDistrictSchool
        WHERE   schoolCode = @pLocationCode

    SELECT  @SchoolName = schoolName
    FROM    vschoolName
    WHERE   schoolCode = @SchoolCode
    SELECT  @districtName = districtName
    FROM    vDistrictName
    WHERE   districtCode = @districtCode

	IF @pDebug = 1
		SELECT  @schoolName, @schoolCode, @districtName, @districtCode, @seUserId, @username


		/*

		SELECT * FROM dbo.LocationRoleClaim
		SELECT * FROM dbo.SEUser
		SELECT * FROM dbo.SEUserDistrictSchool	
		SELECT * FROM dbo.SEUserLocationRole
		roles

		*/

	--*** locationRoleClaim ***
    UPDATE  dbo.LocationRoleClaim
    SET     rolestring = @pRoleString ,
            LocationCode = @pLocationCode ,
            location = CASE WHEN @schoolName IS NULL THEN @DistrictName
                            ELSE @SchoolName
                       END
    WHERE   username = @UserName

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with LRC... In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END




	--*** seUser ***
    UPDATE  seUser
    SET     districtCode = @DistrictCode ,
            SchoolCode = @SchoolCode
    WHERE   seUserid = @seUserid

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with seUser. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

	--*** SEUserDistrictSchool
    DELETE  dbo.SEUserDistrictSchool
    WHERE   SEUserID = @seUserid

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool Delete. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    INSERT  seUserdistrictschool
            ( SEUserID ,
              districtCode ,
              schoolCode ,
              isPrimary
            )
    VALUES  ( @seUserid ,
              @DistrictCode ,
              @SchoolCode ,
              1
            )

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool Insert. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END


   UPDATE  SEUserDistrictSchool
    SET     Schoolname = ds.districtschoolName
    FROM    SEUserDistrictSchool uds
			JOIN seDistrictSchool ds ON ds.schoolcode = uds.schoolcode
    WHERE   SEUserID = @seUserID AND uds.schoolcode <> ''

    SELECT  @sql_error = @@ERROR;
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate school name. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
            GOTO ErrorHandler;
        END;

    UPDATE  SEUserDistrictSchool
    SET     DistrictName = x.districtschoolName
    FROM    SEUserDistrictSchool uds
            JOIN seDistrictschool x ON x.districtCode = uds.districtCode
    WHERE   SEUserID = @seUserID;

    SELECT  @sql_error = @@ERROR;
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate districtme. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
            GOTO ErrorHandler;
        END;



	--*** roles ***
    DELETE  aspnet_usersInroles
    WHERE   userid = ( SELECT   aspnetUserId
                       FROM     seUser
                       WHERE    seUserid = @seUserid
                     )

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem deleting roles. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    DECLARE @ahora DATETIME
    SELECT  @ahora = GETDATE()
    SELECT  @pRoleString = REPLACE(@pRoleString, ';', ',')

    EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @ApplicationName = N'SE', -- nvarchar(256)
        @UserNames = @UserName, -- nvarchar(4000)
        @RoleNames = @pRoleSTring, @CurrentTimeUtc = @ahora -- datetime

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem adding roles. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END


	--*** SEUserLocationRole ***
	-- csv to table ...
    CREATE TABLE #r ( roleName VARCHAR(50) )
    DECLARE @ind INT ,
        @str VARCHAR(20)

    BEGIN
        SET @ind = CHARINDEX(',', @pRoleString)
        WHILE @ind > 0
            BEGIN
                SET @str = SUBSTRING(@pRoleString, 1, @ind - 1)
                SET @pRoleString = SUBSTRING(@pRoleString, @ind + 1,
                                             LEN(@pRoleString) - @ind)
                INSERT  INTO #r
                VALUES  ( @str )
                SET @ind = CHARINDEX(',', @pRoleString)
            END
        SET @str = @pRoleString
        INSERT  INTO #r
        VALUES  ( @str )
    END

    DELETE  seUserLocationRole
    WHERE   username = @UserName
    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with seUserLocationROle delete. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END
	
    INSERT  dbo.SEUserLocationRole
            ( UserName ,
              RoleName ,
              DistrictCode ,
              SchoolCode ,
              LastActiveRole ,
              CreateDate
	        )
            SELECT  @userName ,
                    roleName ,
                    @DistrictCode ,
                    @schoolCode ,
                    0 ,
                    @ahora
            FROM    #r

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem with seUserLocationRole insert... In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            IF ( ( @tran_count = 0 )
                 AND ( @@TRANCOUNT <> 0 )
               )
                ROLLBACK TRANSACTION
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


GO



