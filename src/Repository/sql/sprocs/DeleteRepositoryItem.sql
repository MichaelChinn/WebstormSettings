if exists (select * from sysobjects 
where id = object_id('dbo.DeleteRepositoryItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteRepositoryItem.'
      drop procedure dbo.DeleteRepositoryItem
   END
GO
PRINT '.. Creating sproc DeleteRepositoryItem.'
GO
CREATE PROCEDURE DeleteRepositoryItem
	 @pItemId bigint
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

/***********************************************************************************/
BEGIN



	CREATE TABLE #Bundles (bundleId bigint)
	CREATE TABLE #Streams (streamId bigint, streamSize bigint)



	IF EXISTS (
		SELECT RepositoryItemID
		  FROM dbo.AppUsageCount
		 WHERE ((ReferenceCount >0) OR (ImmutabilityCOunt > 0) )
				AND RepositoryItemID = @pItemID
	)
	
	BEGIN
		SELECT @sql_error = 1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'This item has been marked immutable, and so cannot be recycled.'
			  GOTO ErrorHandler
		   END
	END

	DECLARE @OwnerID BIGINT
	SELECT @OwnerID = ownerID from DBO.RepositoryITem where RepositoryItemID = @pItemID


/*	
if (@pCheckEfolioLitePortfolio = 1)
	BEGIN
		if exists (
			SELECT RepositoryItemID
			  FROM efolioLite.dbo.PortfolioNodeData
			 WHERE RepositoryItemID in (
				SELECT ItemID
				  FROM #Items
			 )
		)

		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Item(s) in use and cannot be recycled.'
			  GOTO ErrorHandler
		   END
	END
		
	if (@pCheckCOEStudentPortfolio = 1)
	BEGIN
		if exists (
			SELECT RepositoryItemID
			  FROM mayComp.dbo.COEWorkSample
			 WHERE RepositoryItemID in (
				SELECT ItemID
				  FROM #Items
			 )
		)

		SELECT @sql_error = -1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Item(s) in use by COE Collection and cannot be recycled.'
			  GOTO ErrorHandler
		   END
	END
*/

	INSERT #Bundles
	SELECT BundleId 
	  FROM dbo.Bundle
	 WHERE RepositoryItemID =@pItemId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot get bundle list for item(s).'
		  GOTO ErrorHandler
	   END


	INSERT #Streams
	SELECT BitStreamId, [size] AS streamSize
	  FROM dbo.Bitstream
	 WHERE BundleId in
		(SELECT BundleId from #Bundles where bundleID is not null)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot get stream list for bundle(s).'
		  GOTO ErrorHandler
	   END


	UPDATE dbo.Bundle
       SET PrimaryBitstreamId = null
	 WHERE bundleId in 
		(Select BundleId from #Bundles)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot set primary bitstreamID null in bundles.'
		  GOTO ErrorHandler
	   END

	--now delete the item related stuff
	DECLARE @sizeAdjust BIGINT
	SELECT @sizeAdjust = sum([size])
	  FROM DBO.Bitstream
	 WHERE BitstreamID in 
		(SELECT streamId from #streams)
	IF (@sizeAdjust IS NULL)
		SELECT @sizeAdjust = 0

	DELETE dbo.Bitstream
	 WHERE BitstreamId in 
		(SELECT streamId from #streams)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot delete the bitstreams.'
		  GOTO ErrorHandler
	   END

	UPDATE dbo.UserRepoContext
	   SET DiskUsage = DiskUsage - @sizeAdjust
	 WHERE ownerId = @OwnerID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not update diskusage in userContext.'
		  GOTO ErrorHandler
	   END

	DELETE dbo.Bundle
	 WHERE bundleId in 
		(SELECT BundleId from #bundles)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot delete bundle.'
		  GOTO ErrorHandler
	   END

	DELETE dbo.RepositoryItem
	 WHERE RepositoryItemID = @pItemId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot delete item list.'
		  GOTO ErrorHandler
	   END
END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
    /*  SELECT @sql_error_message = @sql_error_message + '---'
			+ 'ownerId = ' + CONVERT(varchar (20),@pOwnerID) + ' | '
		    + 'right = ' + CONVERT(varchar (20),@right) + ' | '
		    + 'left = ' + CONVERT(varchar (20),@left) + ' | '
		    + 'mnoc = ' + CONVERT(varchar (20),@MNOC) + ' | '
		    + 'RecycleId = ' + CONVERT(varchar (20),@RecycleId) + '---'
            + 'In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
	*/
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


GO


