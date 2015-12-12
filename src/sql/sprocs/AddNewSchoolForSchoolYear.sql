IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.AddNewSchoolForSchoolYear')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc AddNewSchoolForSchoolYear.'
        DROP PROCEDURE dbo.AddNewSchoolForSchoolYear
    END
GO
PRINT '.. Creating sproc AddNewSchoolForSchoolYear.'
GO
CREATE PROCEDURE AddNewSchoolForSchoolYear
    @pDistrictCode VARCHAR(10) ,
    @pSchoolName VARCHAR(100) ,
    @pSchoolCode VARCHAR(10) ,
    @pSchoolYear INT
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


    IF EXISTS ( SELECT  schoolCode
                FROM    dbo.SEDistrictSchool
                WHERE   schoolcode = @pSchoolCode )
        BEGIN
	
            SELECT  @sql_error = 01 ,
                    @sql_error_message = 'schoolcode... - ' + @pSchoolCode
                    + '- currently exists.   failed. In: ' + @ProcName
                    + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    IF NOT EXISTS ( SELECT  @pDistrictCode
                    FROM    dbo.SEDistrictSchool
                    WHERE   districtcode = @pDistrictCode )
        BEGIN
	
            SELECT  @sql_error = 01 ,
                    @sql_error_message = 'district code... - ' + @pDistrictCode
                    + '- unrecognized.   failed. In: ' + @ProcName + ' >>>'
                    + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END

    INSERT  seDistrictSchool
            ( districtCode ,
              schoolCode ,
              isSchool ,
              districtSchoolName
            )
    VALUES  ( @pDistrictCode ,
              @pSchoolCode ,
              1 ,
              @pSchoolName
            )    --Moses Lake School District

    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not new school...   failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
            GOTO ErrorHandler
        END



    INSERT  SESchoolConfiguration
            ( districtcode ,
              schoolCode ,
              schoolYear
            )
    VALUES  ( @pDistrictCode ,
              @pSchoolCode ,
              @pSchoolYear
            )

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Could not insert new SESchoolConfiguration record...  failed. In: '
                    + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
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
            SELECT  *
            FROM    dbo.vSchoolName
            WHERE   schoolCode = @pSchoolCode
        END


GO

/*
--tests:

select count (*) from sedistrictschool 
select count (*) FROM dbo.SESchoolConfiguration

--something there already
EXEC dbo.AddNewSchoolForSchoolYear
 @pDistrictCode = '13161', -- varchar(10)
    @pSchoolName = 'Endeavor Middle School', -- varchar(100)
    @pSchoolCode = '5354', -- varchar(10)
    @pSchoolYear = 2015 -- int


--fake district
EXEC dbo.AddNewSchoolForSchoolYear
 @pDistrictCode = '00100', -- varchar(10)
    @pSchoolName = 'Endeavor Middle School', -- varchar(100)
    @pSchoolCode = '0020', -- varchar(10)
    @pSchoolYear = 2015 -- int
	

--new school (fake, of course), good district
EXEC dbo.AddNewSchoolForSchoolYear
 @pDistrictCode = '13161', -- varchar(10)
    @pSchoolName = 'Endeavor Middle School', -- varchar(100)
    @pSchoolCode = '0002', -- varchar(10)
    @pSchoolYear = 2015 -- int



*/