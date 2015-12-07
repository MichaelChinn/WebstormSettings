 IF EXISTS ( SELECT *
             FROM   sysobjects
             WHERE  id = OBJECT_ID('dbo.InsertUserReferenceTables')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc InsertUserReferenceTables.';
        DROP PROCEDURE dbo.InsertUserReferenceTables;
    END;
GO
 PRINT '.. Creating sproc InsertUserReferenceTables.';
GO
 SET QUOTED_IDENTIFIER ON;
GO
 CREATE PROCEDURE InsertUserReferenceTables
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
          roleId UNIQUEIDENTIFIER ,
          schoolcode VARCHAR(10) ,
          districtCode VARCHAR(10) ,
          schoolName VARCHAR(100) ,
          districtName VARCHAR(100) ,
          evaluationTypeId SMALLINT ,
          cmdInsertEvaluation VARCHAR(500)
        );
    CREATE TABLE #cmdBlock
        (
          cmdId INT IDENTITY(1, 1)
                    PRIMARY KEY ,
          cmd NVARCHAR(500)
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
    SET     roleId = r.RoleId
    FROM    #lr lr
            JOIN aspnet_Roles r ON r.RoleName = lr.roleName;

	--district and school names
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
    SET     districtName = dn.DistrictName ,
            districtCode = dn.districtCode
    FROM    #lr lr
            JOIN vSchoolName sn ON sn.schoolCode = lr.schoolcode
            JOIN vDistrictName dn ON dn.districtCode = sn.districtCode
    WHERE   lr.districtCode IS NULL;

	--zap unrecognized roles
    DELETE  #lr
    WHERE   roleId IS NULL;
    
	--evaluation type
    UPDATE  #lr
    SET     evaluationTypeId = eret.evaluationTypeId
    FROM    #lr lr
            JOIN seEvaluateeRoleEvaluationType eret ON eret.roleId = lr.roleId;
	
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

    INSERT  #cmdBlock
            ( cmd
            )
          
			SELECT DISTINCT
                    'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation @pEvaluationTypeID='
                    + CONVERT(VARCHAR(20), lr.evaluationTypeId)
                    + ', @pSchoolYear=NULL, @pDistrictCode=''' + lr.districtCode +''''
					+ ', @pEvaluateeID=' + CONVERT(VARCHAR(10),@seUserId)
                    + ', @sql_error_message=@sql_error_message OUTPUT'
            FROM    #lr lr
			JOIN dbo.SEFrameworkContext ctx ON ctx.districtcode = lr.districtCode
            WHERE   lr.evaluationTypeId IS NOT NULL;

    IF ( @pDebug = 1 )
        BEGIN
            SELECT  *
            FROM    #lr;

            SELECT  *
            FROM    #cmdBlock;
        END;
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


    IF @pDebug = 1
        SELECT @flushULR AS ULR;

/**********************************************************/
/*  Now go do the work */
  
    IF @tran_count = 0
        BEGIN TRANSACTION;
    BEGIN TRY

        IF ( @flushULR = 1 )
            BEGIN
                SELECT  @sql_error_message = 'removing seUserLocationRole after discerning necessity'; 

                DELETE  dbo.SEUserLocationRole
                WHERE   UserName = @pUserName;
                SELECT  @sql_error = @@ERROR;
        
                SELECT  @sql_error_message = 'inserting new UserLocationRoles'; 
       
                INSERT  dbo.SEUserLocationRole
                        ( UserName ,
						  SEUserid ,
                          SchoolCode ,
                          DistrictCode ,
						  DistrictName ,
						  SchoolName ,
                          RoleName ,
                          RoleId ,
                          CreateDate 
		                )
                        SELECT  @pUserName ,
								@seuserId ,
                                schoolcode ,
                                districtCode ,
								districtName ,
								schoolName,
                                roleName ,
                                roleId ,
                                GETDATE()
                        FROM    #lr;


            END;
	
       --loop through the command block to insert evaluation records
        DECLARE @idx BIGINT ,
            @cmd VARCHAR(5000);
        SELECT  @idx = MIN(cmdId)
        FROM    #cmdBlock;
        WHILE @idx IS NOT NULL
            BEGIN
                          
                
                SELECT  @cmd = cmd
                FROM    #cmdBlock
                WHERE   cmdId = @idx
                        AND cmd IS NOT NULL;	
		
				IF @pDebug = 1
				   SELECT @cmd
                ELSE 
			       EXEC (@cmd);
                             
                SELECT  @idx = MIN(cmdId)
                FROM    #cmdBlock
                WHERE   cmdId > @idx
                        AND cmd IS NOT NULL;
            END;


        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT = 1 )
            BEGIN
                COMMIT TRANSACTION;
            END;
    END TRY
    
	
    BEGIN CATCH
        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + ' >>> ' + @sql_error_message + +' ... "'
                + ERROR_MESSAGE() + '"<<<';


        IF ( ( @tran_count = 0 )
             AND ( @@TRANCOUNT <> 0 )
           )
            ROLLBACK TRANSACTION;
        RAISERROR(@sql_error_message, 15, 10);

   
    END CATCH;
	


GO

