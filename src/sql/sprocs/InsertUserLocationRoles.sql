 IF EXISTS ( SELECT *
             FROM   sysobjects
             WHERE  id = OBJECT_ID('dbo.InsertUserLocationRoles')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc InsertUserLocationRoles.';
        DROP PROCEDURE dbo.InsertUserLocationRoles;
    END;
GO
 PRINT '.. Creating sproc InsertUserLocationRoles.';
GO
 SET QUOTED_IDENTIFIER ON;
GO
 CREATE PROCEDURE InsertUserLocationRoles
    @pUserName VARCHAR(200) ,
    @pLRString NVARCHAR(4000) ,
    @pDebug SMALLINT = 0
 AS
    SET NOCOUNT ON; 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName sysname ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500);


---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID);

------------------
-- TRAN CONTROL --
------------------

/*  Parse out the input LRString and hydrate the temp table*/
--DROP TABLE #lr
    CREATE TABLE #lr
        (
          lrPair NVARCHAR(100) ,
          split INT ,
          location NVARCHAR(10) ,
          roleName NVARCHAR(100) ,
          schoolcode VARCHAR(10) ,
          districtCode VARCHAR(10) ,
          schoolName VARCHAR(100) ,
          districtName VARCHAR(100)
        );

--DECLARE @inputString NVARCHAR(4000)
    DECLARE @xmlString XML;
--SELECT @inputString = '01147|abc,3010|jkl,3015|michael,34003|jason, 34003|mommy'


    SET @xmlString = N'<root><r>' + REPLACE(@pLRString, ',', '</r><r>')
        + '</r></root>';

    INSERT  #lr
            ( lrPair
            )
            SELECT  t.value('.', 'varchar(100)') AS [roleName]
            FROM    @xmlString.nodes('//root/r') AS a ( t );

    UPDATE  #lr
    SET     split = CHARINDEX('|', lrPair)
    FROM    #lr;

    UPDATE  #lr
    SET     location = LTRIM(RTRIM(SUBSTRING(lrPair, 1, split - 1))) ,
            roleName = LTRIM(RTRIM(SUBSTRING(lrPair, split + 1, 100)));


    UPDATE  #lr
    SET     schoolName = sn.SchoolName ,
            schoolcode = sn.schoolCode
    FROM    #lr lr
            JOIN vSchoolName sn ON sn.schoolCode = lr.location;

    UPDATE  #lr
    SET     districtName = dn.DistrictName ,
            districtCode = dn.districtCode
    FROM    #lr lr
            JOIN vDistrictName dn ON dn.districtCode = lr.location;

    UPDATE  #lr
    SET     schoolName = '' ,
            schoolcode = ''
    WHERE   schoolcode IS NULL;
    UPDATE  #lr
    SET     districtName = '' ,
            districtCode = ''
    WHERE   districtCode IS NULL;


    IF ( @pDebug = 1 )
        SELECT  *
        FROM    #lr;
/******************************************************/
/*  Check SEUserDistrictSchool for need to flush */
    DECLARE @seuserId BIGINT ,
        @fCount INT ,
        @rCount INT ,
        @flushULR BIT ,
        @flushUDS BIT;

    SELECT  @seuserId = SEUserID ,
            @flushULR = 0 ,
            @flushUDS = 0
    FROM    dbo.SEUser su
            JOIN aspnet_Users au ON au.UserId = su.ASPNetUserID
    WHERE   au.UserName = @pUserName;

    SELECT  @fCount = COUNT(*)
    FROM    ( SELECT    DistrictCode ,
                        SchoolCode
              FROM      dbo.SEUserDistrictSchool
              WHERE     SEUserID = @seuserId
              EXCEPT
              SELECT    districtCode ,
                        schoolcode
              FROM      #lr
            ) AS X;

    SELECT  @rCount = COUNT(*)
    FROM    ( SELECT    districtCode ,
                        schoolcode
              FROM      #lr
              EXCEPT
              SELECT    DistrictCode ,
                        SchoolCode
              FROM      dbo.SEUserDistrictSchool
              WHERE     SEUserID = @seuserId
            ) AS Y;


    IF ( ( @fCount > 0 )
         OR ( @rCount > 0 )
       )
        SELECT  @flushUDS = 1;
/******************************************************/
/*  Check in SEUserLocationRole for need to flush  */
    SELECT  @fCount = COUNT(*)
    FROM    ( SELECT    DistrictCode ,
                        SchoolCode ,
                        RoleName
              FROM      dbo.SEUserLocationRole
              WHERE     UserName = @pUserName
              EXCEPT
              SELECT    districtCode ,
                        schoolcode ,
                        roleName
              FROM      #lr
            ) AS X;

    SELECT  @rCount = COUNT(*)
    FROM    ( SELECT    districtCode ,
                        schoolcode ,
                        roleName
              FROM      #lr
              EXCEPT
              SELECT    DistrictCode ,
                        SchoolCode ,
                        RoleName
              FROM      dbo.SEUserLocationRole
              WHERE     UserName = @pUserName
            ) AS Y;


    IF ( ( @fCount > 0 )
         OR ( @rCount > 0 )
       )
        SELECT  @flushULR = 1;


    IF @pDebug = 2
        SELECT  @flushUDS AS UDS ,
                @flushULR AS ULR;
/******************************************************/
/*  Check in seEvaluation for need to flush  */
 
 /*
 --eventually...

 EXEC dbo.InsertEvaluation @pEvaluationTypeID = 0, -- smallint
    @pSchoolYear = 0, -- smallint
    @pDistrictCode = '', -- varchar(20)
    @pEvaluateeID = 0, -- bigint
    @sql_error_message = '' -- varchar(500)
 
 */



/**********************************************************/
/*  Now go do the work */
    IF @tran_count = 0
        BEGIN TRANSACTION;

    BEGIN TRY

        IF ( @flushUDS = 1 )
            BEGIN
                SELECT  @sql_error_message = 'Need to remove SEUserDistrictSchool for SEUserID'; 
               
                DELETE  dbo.SEUserDistrictSchool
                WHERE   SEUserID = @seuserId;
        
                SELECT  @sql_error_message = 'inserting new seUserDistrictSchool';

                INSERT  dbo.SEUserDistrictSchool
                        ( SEUserID ,
                          SchoolCode ,
                          DistrictCode ,
                          SchoolName ,
                          DistrictName ,
                          IsPrimary
                        )
                        SELECT  @seuserId ,
                                schoolcode ,
                                districtCode ,
                                schoolName ,
                                districtName ,
                                1	--bogus value
                        FROM    #lr;
            END;

        IF ( @flushULR = 1 )
            BEGIN
                SELECT  @sql_error_message = 'removing seUserLocationRole after discerning necessity'; 

                DELETE  dbo.SEUserLocationRole
                WHERE   UserName = @pUserName;
                SELECT  @sql_error = @@ERROR;
        
                SELECT  @sql_error_message = 'inserting new UserLocationRoles'; 
       
                INSERT  dbo.SEUserLocationRole
                        ( UserName ,
                          SchoolCode ,
                          DistrictCode ,
                          RoleName ,
                          CreateDate 
		                )
                        SELECT  @pUserName ,
                                schoolcode ,
                                districtCode ,
                                roleName ,
                                GETDATE()
                        FROM    #lr;
            END;
    END TRY
    
	
    BEGIN CATCH
        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + ' >>> ' + @sql_error_message + +' ... "'
                + ERROR_MESSAGE() + '"<<<';

        ROLLBACK TRANSACTION;
        RAISERROR(@sql_error_message, 15, 10);
   
    END CATCH;
	
    PROC_END:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION;
        END;


GO

