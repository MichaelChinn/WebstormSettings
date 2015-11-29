IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.MergeEDSUserPair')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc MergeEDSUserPair.';
        DROP PROCEDURE dbo.MergeEDSUserPair;
    END;
GO
PRINT '.. Creating sproc MergeEDSUserPair.';
GO
CREATE PROCEDURE dbo.MergeEDSUserPair
    @pLastname VARCHAR(50) ,
    @pOldEDSPersonId BIGINT ,
    @pNewEDSPersonId BIGINT ,
    @pDebug INT = 0
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
    IF @tran_count = 0
        BEGIN TRANSACTION;

    IF NOT EXISTS ( SELECT  *
                    FROM    SEUser
                    WHERE   Username = CONVERT(VARCHAR(20), @pOldEDSPersonId)
                            + '_edsUser'
                            AND LastName = @pLastname )
        BEGIN
            SELECT  @sql_error = -1 ,
                    @sql_error_message = 'checking lastname against old personid';
            GOTO ErrorHandler;
        END;
		 
        
    IF NOT EXISTS ( SELECT  *
                    FROM    SEUser
                    WHERE   Username = CONVERT(VARCHAR(20), @pNewEDSPersonId)
                            + '_edsUser'
                            AND LastName = @pLastname )
        BEGIN
            SELECT  @sql_error = -1 ,
                    @sql_error_message = 'checking lastname against new personid';
            GOTO ErrorHandler;
        END;


    CREATE TABLE #oldData
        (
          PersonId BIGINT ,
          SEUserId BIGINT ,
          EvalSessionCount INT ,
          ArtifactCount INT ,
          ResponseEntryCount INT ,
          SummativeFNScore INT ,
          SummativeRRScore INT
        );

    CREATE TABLE #newData
        (
          PersonId BIGINT ,
          SEUserId BIGINT ,
          EvalSessionCount INT ,
          ArtifactCount INT ,
          ResponseEntryCount INT ,
          SummativeFNScore INT ,
          SummativeRRScore INT
        );

    INSERT  #oldData
            ( PersonId ,
              SEUserId ,
              EvalSessionCount ,
              ArtifactCount ,
              ResponseEntryCount ,
              SummativeFNScore ,
              SummativeRRScore
	        )
            SELECT  *
            FROM    dbo.CheckIfEDSUserHasData_fn(@pOldEDSPersonId);

    INSERT  #newData
            ( PersonId ,
              SEUserId ,
              EvalSessionCount ,
              ArtifactCount ,
              ResponseEntryCount ,
              SummativeFNScore ,
              SummativeRRScore
	        )
            SELECT  *
            FROM    dbo.CheckIfEDSUserHasData_fn(@pNewEDSPersonId);

    DECLARE @oldDataCount INT ,
        @newDataCount INT;
    SELECT  @oldDataCount = EvalSessionCount + ArtifactCount
            + ResponseEntryCount + SummativeFNScore + SummativeRRScore
    FROM    #oldData; 

    SELECT  @newDataCount = EvalSessionCount + ArtifactCount
            + ResponseEntryCount + SummativeFNScore + SummativeRRScore
    FROM    #newData; 


			  --both have data; can't do anything more

    IF @oldDataCount <> 0
        AND @newDataCount <> 0
        BEGIN
            SELECT  @sql_error = -1 ,
                    @sql_error_message = 'both accts have data';
            GOTO ErrorHandler;
        END;
 
    IF @oldDataCount <> 0
        AND @newDataCount = 0
        BEGIN
            DECLARE @oldSeUserId BIGINT ,
                @newSeuserid BIGINT;

            SELECT  @oldSeUserId = SEUserId
            FROM    #oldData;
            SELECT  @newSeuserid = SEUserId
            FROM    #newData;

            EXEC dbo.SwapASPNetUserInfo @pAUserId = @oldSeUserId, -- bigint
                @pBUserId = @newSeuserid; -- bigint

            SELECT  @sql_error = @@ERROR;
            IF @sql_error <> 0
                BEGIN
                    SELECT  @sql_error_message = 'exec swap failed'; 
                    GOTO ErrorHandler;
                END;


        END;
			
		--this just falls through

    EXEC dbo.RetireEDSUserName @pPersonId = @pOldEDSPersonId; -- bigint

    SELECT  @sql_error = @@ERROR;
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'exec retire failed'; 
            GOTO ErrorHandler;
        END;

   
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            IF ( @tran_count = 0 )
                AND ( @@TRANCOUNT <> 0 )
                BEGIN
                    ROLLBACK TRANSACTION;
                END;


            SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                    + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                    + ISNULL(@sql_error_message, '') + '<<<  ';

            RAISERROR(@sql_error_message, 15, 10);
        END;

----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION;
        END;

    RETURN(@sql_error);

GO



GO