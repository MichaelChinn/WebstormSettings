IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.DeleteRepositoryFolder')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc DeleteRepositoryFolder.'
        DROP PROCEDURE dbo.DeleteRepositoryFolder
    END
GO
PRINT '.. Creating sproc DeleteRepositoryFolder.'
GO
CREATE PROCEDURE DeleteRepositoryFolder @pFolderId BIGINT
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

/***********************************************************************************/
    BEGIN


        IF NOT EXISTS ( SELECT  RepositoryFolderid
                        FROM    dbo.RepositoryFolder
                        WHERE   @pFolderID = RepositoryFolderId ) 
            BEGIN
                SELECT  @sql_error = -1
                IF @sql_error <> 0 
                    BEGIN
                        SELECT  @sql_error_message = 'Could not find node requested. '
                        GOTO ErrorHandler
                    END
            END
	
        DECLARE @lft BIGINT ,
            @rgt BIGINT ,
            @ownerId BIGINT
          
        SELECT  @ownerID = ownerId ,
                @lft = leftOrdinal ,
                @rgt = rightOrdinal
        FROM    dbo.RepositoryFolder
        WHERE   RepositoryFolderId = @pFolderID

	
        CREATE TABLE #Items
            (
              RepositoryItemid BIGINT
            )
        INSERT  #Items
                ( RepositoryItemid
                )
                SELECT  ri.RepositoryItemId
                FROM    RepositoryItem ri
                        JOIN RepositoryFOlder f ON f.RepositoryFolderId = ri.RepositoryFolderId
                WHERE   @lft < f.LeftOrdinal
                        AND f.RightOrdinal < @rgt
		
		
	
        CREATE TABLE #Bundles ( bundleId BIGINT )
        SELECT  bundleId
        FROM    dbo.Bundle b
                JOIN #items i ON i.RepositoryItemid = b.RepositoryItemID
		
		
	
        CREATE TABLE #bitstreams ( bitstreamId BIGINT )
        SELECT  bitstreamid
        FROM    dbo.Bitstream bs
                JOIN #bundles bu ON bu.bundleId = bs.BundleID

	
        UPDATE  bundle
        SET     PrimaryBitstreamID = NULL
        WHERE   bundleId IN ( SELECT    bundleId
                              FROM      #bundle )
        
        SELECT  @sql_error = @@ERROR
	
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not SET PrimaryBitstreamID = NULL.'
                GOTO ErrorHandler
            END
	
	
        DECLARE @spaceused BIGINT
        SELECT  @spaceUsed = SUM(Size)
        FROM    bitstream bs
                JOIN #bitstreams bss ON bss.bitstreamId = bs.BitstreamId
	
        DELETE  dbo.Bitstream
        WHERE   BitstreamID IN ( SELECT bitstreamid
                                 FROM   #bitstreams )
	
	
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not delete bitstreams.'
                GOTO ErrorHandler
            END
	
	
        DELETE  bundle
        WHERE   bundleId IN ( SELECT    bundleId
                              FROM      #bundles )
	
	
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not delete bundles.'
                GOTO ErrorHandler
            END
	
        DELETE  repositoryitem
        WHERE   repositoryItemId IN ( SELECT    repositoryItemId
                                      FROM      #items )
        
        
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not delete repo item.'
                GOTO ErrorHandler
            END
        
        UPDATE  dbo.UserRepoContext
        SET     DiskUsage = DiskUsage - @spaceUsed
        WHERE   OwnerID = @ownerID
	
	
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not update diskusage in userRepoContext.'
                GOTO ErrorHandler
            END

		
        DELETE  dbo.RepositoryFolder
        WHERE   @lft < LeftOrdinal
                AND RightOrdinal < @rgt

        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Could not delete sub folders.'
                GOTO ErrorHandler
            END
            
        DECLARE @diff BIGINT
        SELECT @diff = @rgt - @lft +1
            
        UPDATE  dbo.RepositoryFolder
        SET     leftOrdinal = leftOrdinal - @diff ,
                RightOrdinal = RightOrdinal - @diff
        WHERE   rightOrdinal >= @rgt AND leftOrdinal <> @lft

        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'could not reorder nodes.'
                GOTO ErrorHandler
            END

    END
-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 ) 
        BEGIN
            ROLLBACK TRANSACTION
            SELECT  @sql_error_message = @sql_error_message
                    + '-- RepositoryfolderId = '
                    + CONVERT(VARCHAR(20), ISNULL(@pFolderId, ''))
                    + '-- userId = ' + CONVERT(VARCHAR(20), ISNULL(@ownerId,
                                                              '')) + '.  In: '
                    + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')

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


