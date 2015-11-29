IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.InsertNewSchool')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc InsertNewSchool.'
        DROP PROCEDURE dbo.InsertNewSchool
    END
GO
PRINT '.. Creating sproc InsertNewSchool.'
GO
CREATE PROCEDURE InsertNewSchool
    @pDistrictCode VARCHAR(10) ,
    @pSchoolCode VARCHAR(10) ,
    @pSchoolName VARCHAR(200) ,
    @pDistrictName VARCHAR(200) = ''
AS
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500)


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

    IF NOT EXISTS ( SELECT  districtCode
                    FROM    seDistrictSchool )
        BEGIN
            INSERT  seDistrictSchool
                    ( districtCode ,
                      districtSchoolName ,
                      isSchool

                    )
            VALUES  ( @pDistrictCode ,
                      @pDistrictName ,
                      0
                    )
	
	
            SELECT  @sql_error = @@ERROR
            IF @sql_error <> 0
                BEGIN
                    SELECT  @sql_error_message = 'Could not insert new district... '
                            + @pDistrictCode + ' ...In: ' + @ProcName + ' >>>'
                            + ISNULL(@sql_error_message, '')
                    GOTO ErrorHandler
                END
        END

    INSERT  dbo.SEDistrictSchool
            ( districtCode ,
              schoolCode ,
              districtSchoolName ,
              isSchool ,
              isSecondary
            )
    VALUES  ( @pDistrictCode , -- districtCode - varchar(10)
              @pSchoolCode , -- schoolCode - varchar(10)
              @pSchoolName , -- districtSchoolName - varchar(100)
              1 , -- isSchool - bit
              1 -- isSecondary - bit
            )

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not insert new school... '
                    + @pSchoolCode + ' ...In: ' + @ProcName + ' >>>'
                    + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

	DECLARE @SchoolYear INT
	SELECT @SchoolYear = MAX(schoolYear) FROM dbo.SESchoolYear

    INSERT  dbo.SESchoolConfiguration
            ( DistrictCode ,
              SchoolCode ,
              SchoolYear 
	        )
    VALUES  ( @pDistrictCode , -- DistrictCode - varchar(20)
              @pSchoolCode , -- SchoolCode - varchar(20)
              @schoolYear  -- SchoolYear - smallint
	        )


    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem inserting seSchoolConfigurationRecord... '
                    + @pSchoolCode + ' ...In: ' + @ProcName + ' >>>'
                    + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
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


