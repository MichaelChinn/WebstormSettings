IF OBJECT_ID ('dbo.RenameBitstream') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc RenameBitstream.'
      DROP PROCEDURE dbo.RenameBitstream
   END
GO
PRINT '.. Creating sproc RenameBitstream.'
GO
CREATE PROCEDURE dbo.RenameBitstream
(
	@pBitStreamId	BIGINT
	,@pNewName		VARCHAR(2000)
	,@pNewExtension VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON 
	---------------
	-- VARIABLES --
	---------------
	DECLARE @sql_error                   INT
		   ,@ProcName                    SYSNAME
		   ,@tran_count                  INT
			,@sql_error_message			VARCHAR(250)
			,@ContentType				VARCHAR(250)
			,@URL						VARCHAR(500)
	---------------------
	-- INITIALIZATIONS --
	---------------------
	SELECT  @sql_error              = 0
		   ,@tran_count             = @@TRANCOUNT
		   ,@ProcName               = OBJECT_NAME(@@PROCID)

	IF @tran_count = 0
	   BEGIN TRANSACTION

	DECLARE @containerBundle bigint, @containerItem bigint, @isUrl bit

	SELECT @containerBundle = b.bundleId, @containerItem = b.RepositoryItemID
	  FROM dbo.Bitstream bs
	  JOIN dbo.Bundle b on b.BundleID = bs.BundleId
	 WHERE bs.bitstreamId = @pBitstreamID

	SELECT @sql_error = dbo.ItemIsImmutable_fn(@containerItem)
	IF (@sql_error <>0)
	BEGIN
	  SELECT @sql_error_message = 'Destination item marked immutable, so bitstream could not be renamed '
	  GOTO ErrorHandler
	END
	
	SELECT @sql_error = dbo.IsBitStreamCollision_fn(@containerBundle, @pNewName, @pBitstreamId)
	IF (@sql_error <>0)
	BEGIN
		SELECT @sql_error_message = 'Name collision in destination bundle'
		GOTO ErrorHandler
	END

	if exists (
		select URL from dbo.bitstream 
		where bitstreamId = @pBitstreamId and URL is not null
	)
	select @sql_error = -1
	IF (@sql_error <>0)
	BEGIN
		SELECT @sql_error_message = 'Target bitstream is url, not file; cannot change name'
		GOTO ErrorHandler
	END
	
	SET @ContentType = (SELECT ImageType FROM dbo.ImageType WHERE Extension = @pNewExtension)
	IF @ContentType IS NULL
		SET @ContentType = 'application/UNKNOWN'

	UPDATE dbo.Bitstream 
	   SET
			[Name] = @pNewName
			,[Ext] = @pNewExtension
			,[ContentType] = @ContentType	   
	 WHERE BitstreamID = @pBitStreamId


	SELECT @sql_error = @@Error
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Rename Bitstream Failed'
		GOTO ErrorHandler
	END


	-------------------
	-- Handle errors --
	-------------------
	ErrorHandler:
	IF (@sql_error <> 0)
	   BEGIN
		  ROLLBACK TRANSACTION
		  SELECT @sql_error_message = @sql_error_message + 
      		  '-- BitstreamId = ' + convert(varchar(20), ISNULL(@pBitstreamID, '')) + 
			  '-- Name = ' + convert(varchar(20), ISNULL(@pNewName, '')) + 
			  '-- Extension = ' + convert(varchar(20), ISNULL(@pNewExtension, '')) + 
			  '.  In: ' + @ProcName + '. ' 
		  RAISERROR(@sql_error_message, 15, 10)
	   END
	----------------------
	-- End of Procedure --
	----------------------
	ProcEnd:

	IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
	   BEGIN
		 COMMIT TRANSACTION
	   END

	RETURN(@sql_error)
END
GO

