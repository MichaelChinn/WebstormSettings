IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.UpdateBitstreamMetaData')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc UpdateBitstreamMetaData'
        DROP PROCEDURE dbo.UpdateBitstreamMetaData
    END
GO
PRINT '.. Creating sproc UpdateBitstreamMetaData'
GO
CREATE PROCEDURE UpdateBitstreamMetaData
    @pBitstreamId BIGINT ,
    @pIsPrimary BIT ,
   -- @pAZGuid UNIQUEIDENTIFIER ,
    @pURL VARCHAR(500) ,
    @pName VARCHAR(2000) ,
    @pExt VARCHAR(20) ,
    @pDescription TEXT ,
    @pSize BIGINT ,
    @pContentType VARCHAR(250) ,
    @pInitialUpload DATETIME ,
    @pDebug BIT = 0
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


    IF ( @pUrl = '' )
        SELECT  @pUrl = NULL;

    DECLARE @containerBundle BIGINT ,
        @containerItem BIGINT 

    SELECT  @containerBundle = b.bundleId ,
            @containerItem = b.RepositoryItemID
    FROM    dbo.Bitstream bs
            JOIN dbo.Bundle b ON b.BundleID = bs.BundleId
    WHERE   bs.bitstreamId = @pBitstreamID

    SELECT  @sql_error = dbo.ItemIsImmutable_fn(@containerItem)
    IF ( @sql_error <> 0 )
        BEGIN
            SELECT  @sql_error_message = 'Destination item marked immutable, so bitstream metadata could not be changed '
            GOTO ErrorHandler
        END
	

	-- if bitstream is *not* an url, check for name collisions of bitstream within bundle
	DECLARE @isURL BIT = 0
	IF (NOT EXISTS (SELECT * FROM bitstream WHERE ContentType='URL' AND bitstreamID = @pBitstreamId))
		SELECT  @sql_error = dbo.IsBitStreamCollision_fn(@containerBundle, @pName,
														 @pBitstreamId)
    IF ( @sql_error <> 0 )
        BEGIN
            SELECT  @sql_error_message = 'Name collision in destination bundle'
            GOTO ErrorHandler
        END



    IF EXISTS ( SELECT  URL
                FROM    dbo.bitstream
                WHERE   bitstreamId = @pBitstreamId
                        AND URL IS NOT NULL )
        SELECT  @sql_error = -1
    IF ( @sql_error <> 0 )
        BEGIN
            SELECT  @sql_error_message = 'Target bitstream is url, not file; cannot change name'
            GOTO ErrorHandler
        END
	








	-- assume that the extension of the name and the extension passed
	-- in are in agreement, enforced by the DAL... but still must check the 
	-- passed-in content type with the extension
	
    DECLARE @ContentType VARCHAR(250)

    SET @ContentType = ( SELECT ImageType
                         FROM   dbo.ImageType
                         WHERE  Extension = @pExt
                       )
    IF ( @ContentType IS NULL )
        BEGIN
            IF ( @pContentType = '' )
                OR ( @pContentType IS NULL )
                SET @ContentType = 'application/UNKNOWN'
            ELSE
				--if there was a content type passed in, and the extension hadn't
				--been seen before, assume the passed in content type is what was
				--wanted; in this way, we can instantiate new content types in the 
				--image type table
                BEGIN
                    SET @ContentTYpe = @pContentType
                    INSERT  dbo.ImageTYpe
                            ( extension, imageType )
                    VALUES  ( @pExt, @contentType )

                    SELECT  @sql_error = @@error
                    IF @sql_error <> 0
                        BEGIN
                            SELECT  @sql_error_message = 'can''t insert new content type into ImageType table '
                            GOTO ErrorHandler
                        END
                END
        END
	
    IF @pdebug = 1
        SELECT  @contentType


    UPDATE  dbo.Bitstream
    SET     --S3Key = @pAZGuid ,
            URL = @pUrl ,
            Name = @pName ,
            Ext = @pExt ,
            Description = @pDescription ,
            Size = @pSize ,
            ContentType = @ContentType ,
            InitialUpload = @pInitialUpload
    WHERE   BitstreamId = @pBitstreamId

    SELECT  @sql_error = @@error
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem trying to update meta data of bitstream. '
            GOTO ErrorHandler
        END

    IF ( @pIsPrimary = 1 )
        BEGIN

            DECLARE @BundleId BIGINT
            SELECT  @BundleId = bundleid
            FROM    bitstream
            WHERE   bitstreamid = @pBitstreamId

            UPDATE  dbo.Bundle
            SET     PrimaryBitStreamID = @pBitStreamId
            WHERE   BundleId = @bundleId

            SELECT  @sql_error = @@error
            IF @sql_error <> 0
                BEGIN
                    SELECT  @sql_error_message = 'Problem trying to set primary bitstream in bundle. '
                    GOTO ErrorHandler
                END

        END
----------------------
-- Handle errors --
----------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            ROLLBACK TRANSACTION
            SELECT  @sql_error_message = @sql_error_message + '---'
                    + ' || IsPrimary = ' + CONVERT(VARCHAR(10), @pIsPrimary)
                    + ' || BitstreamId = '
                    + CONVERT(VARCHAR(10), @pBitstreamId)
				--+ ' || AZGuid = ' + CONVERT(varchar(10), @pAZGuid)
                    + ' || URL = ' + CONVERT(VARCHAR(10), ISNULL(@pURL, ''))
                    + ' || Name = ' + CONVERT(VARCHAR(10), @pName)
                    + ' || Ext = ' + CONVERT(VARCHAR(10), @pExt)
                    + ' || Size = ' + CONVERT(VARCHAR(10), @pSize)
                    + ' || ContentType = '
                    + CONVERT(VARCHAR(10), @pContentType)
                    + ' || InitalUpload = '
                    + CONVERT(VARCHAR(10), @pInitialUpload) + @ProcName + '. '
                    + '>>>' + ISNULL(@sql_error_message, '')
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


