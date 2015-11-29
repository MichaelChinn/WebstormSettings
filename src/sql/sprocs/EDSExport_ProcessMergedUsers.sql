IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_ProcessMergedUsers')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc EDSExport_ProcessMergedUsers.'
        DROP PROCEDURE dbo.EDSExport_ProcessMergedUsers
    END
GO
PRINT '.. Creating sproc EDSExport_ProcessMergedUsers.'
GO
CREATE PROCEDURE EDSExport_ProcessMergedUsers @pDebug BIT = 0
AS
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message VARCHAR(500)


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

    IF NOT EXISTS ( SELECT  *
                    FROM    sys.columns
                    WHERE   Name = N'PreviousPersonId'
                            AND Object_ID = OBJECT_ID(N'vEDSUsers') )
        GOTO ProcEnd

	--this is the first sproc to run in the EDSExport set
	-- truncate the EDSError
	
    TRUNCATE TABLE EDSError

	/*******  the non-xml shred  ********************************************/
    CREATE TABLE #multis
        (
          personId BIGINT ,
          remaining VARCHAR(3000) ,
          leftPart VARCHAR(300)			--as in 'the part that is to the left'
        )
    CREATE TABLE #PersonIDHistory
        (
          personId BIGINT ,
          previousPersonId BIGINT ,
          HasPreviousSEID BIT
        )

		-- all the easy ones first 
    INSERT  #PersonIDHistory
            ( personId ,
              previousPersonId
            )
            SELECT  personId ,
                    CONVERT(BIGINT, REPLACE(PreviousPersonId, ' ', ''))
            FROM    dbo.vEDSUsers
            WHERE   PreviousPersonId NOT LIKE '%,%'
                    AND PreviousPersonId NOT LIKE ''
                    AND PreviousPersonId IS NOT NULL                     
 
		-- now process multi prevId users
    INSERT  #multis
            ( personId ,
              remaining
            )
            SELECT  personId ,
                    REPLACE(PreviousPersonId, ' ', '')
            FROM    dbo.vEDSUsers
            WHERE   PreviousPersonId LIKE '%,%'
                    AND PreviousPersonId NOT LIKE ''
                    AND PreviousPersonId IS NOT NULL
                  
                  
    --IF @pDebug = 1 SELECT * FROM #multis     
       
    DECLARE @nRows BIGINT ,
        @Cycles INT
    SELECT  @nRows = COUNT(*) ,
            @cycles = 0
    FROM    #multis

    WHILE ( SELECT  COUNT(*)
            FROM    #multis
          ) > 0
        BEGIN
		--start a cycle
            UPDATE  #multis
            SET     leftPart = LEFT(remaining, CHARINDEX(',', remaining) - 1) 
		--... pick up the singletons found
            INSERT  #PersonIDHistory
                    ( personId ,
                      previousPersonId
                    )
                    SELECT  personId ,
                            CONVERT(BIGINT, leftpart)
                    FROM    #multis

		--... reset 'remaining'; pick up any that cant' be processed anymore
            UPDATE  #multis
            SET     remaining = SUBSTRING(remaining,
                                          CHARINDEX(',', remaining) + 1, 5000)
            FROM    #multis
            INSERT  #PersonIDHistory
                    ( personId ,
                      previousPersonId
                    )
                    SELECT  personId ,
                            CONVERT(BIGINT, remaining)
                    FROM    #multis
                    WHERE   remaining NOT LIKE '%,%'

		--... remove spent records; reset 'leftpart'
            DELETE  #multis
            WHERE   remaining NOT LIKE '%,%'
            UPDATE  #multis
            SET     leftPart = ''

        END


	/*******  detecting problems  ********************************************/

    UPDATE  #PersonIDHistory
    SET     HasPreviousSEID = 1
    FROM    #PersonIdHistory pih
            JOIN aspnet_users u ON u.username = CONVERT(VARCHAR(40), pih.previousPersonId)
                                   + '_edsUser'

	--multis
    INSERT  EDSError
            ( personID ,
              errorMsg
            )
            SELECT  personId ,
                    'MULTID - multiple previousPersonIds exist together in se aspnet_users'
            FROM    ( SELECT    COUNT(personid) AS N ,
                                personId
                      FROM      #personIdHistory
                      WHERE     HasPreviousSEID = 1
                      GROUP BY  Personid
                    ) x
            WHERE   N > 1
            
    --multis
    INSERT  EDSError
            ( personID ,
              errorMsg
            )
            SELECT  personId ,
                    'NEWOLD - Old personid and New person id exist in se aspnet_users together'
            FROM    #PersonIDHistory pih
            WHERE   CONVERT(VARCHAR(20), pih.personId) + '_edsUser' IN (
						SELECT  username
						FROM    aspnet_Users )
                    AND CONVERT(VARCHAR(20), pih.previousPersonId) + '_edsUser' IN ( 
						SELECT    username
                        FROM      aspnet_Users )
    --IF @pDebug = 1 SELECT * FROM EDSError
                                   
    DELETE  #PersonIDHistory
    WHERE   personId IN ( SELECT    personId
                          FROM      EDSError )
    
	/*******  changing the names  ********************************************/
    CREATE TABLE #workToDo
        (
          personId BIGINT ,
          previousPersonid BIGINT
        )

	
    INSERT  #workToDo
            ( personId ,
              previousPersonid
            )
            SELECT  personid ,
                    previousPersonId
            FROM    #personIdHistory
            WHERE   HasPreviousSEID = 1
            ORDER BY PersonId

    IF @pDebug = 1
        SELECT  'initialWTD' ,
                *
        FROM    #workToDo
        


    DECLARE @CurrentPersonId INT ,
        @personId BIGINT ,
        @previousPersonIds VARCHAR(2000) ,
        @userName VARCHAR(200)
        
    SELECT  @CurrentPersonId = MIN(personId)
    FROM    #workToDo

    WHILE @CurrentPersonId IS NOT NULL
        BEGIN
            SELECT  @userName = CONVERT (VARCHAR(20), personId) + '_EDSUSER' -- varchar(100)
                    ,
                    @previousPersonIds = CONVERT(VARCHAR(20), previousPersonId)
            FROM    #workToDo
            WHERE   personId = @CurrentPersonId

            IF NOT EXISTS ( SELECT  *
                            FROM    aspnet_users
                            WHERE   username = @userName )
                BEGIN
                    IF @pDebug = 1
                        SELECT  @userName ,
                                @previousPersonIds 
                    ELSE
                        EXEC dbo.ChangeEDSUserName @pCurrentEDSUserName = @userName,
                            @pIDHistory = @previousPersonIds, -- varchar(8000)
                            @pApplicationName = 'SE',-- varchar(200)
                            @sql_error_message = @sql_error_message -- nvarchar(500)
                
                END

            DELETE  #workToDo
            WHERE   personId = @CurrentPersonId
            SELECT  @CurrentPersonId = MIN(personId)
            FROM    #workToDo

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


