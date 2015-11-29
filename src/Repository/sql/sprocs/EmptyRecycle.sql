if exists (select * from sysobjects 
where id = object_id('dbo.EmptyRecycle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc EmptyRecycle.'
      drop procedure dbo.EmptyRecycle
   END
GO
PRINT '.. Creating sproc EmptyRecycle.'
GO
CREATE PROCEDURE EmptyRecycle
	 @pOwnerId bigint
	,@pCheckEfolioLitePortfolio bit = 0
	,@pCheckCOEStudentPortfolio bit = 0
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

	declare @left int
		, @right int
		, @MNOC int --count of ordinals *within* recycle bin
		, @RecycleId bigint

	select @left = leftOrdinal
			,@right = rightOrdinal
			,@MNOC = rightOrdinal - leftOrdinal + 1 - 2
			,@RecycleId = RepositoryFolderId
	from dbo.RepositoryFolder
	where ownerId = @pOwnerId
	and FolderName = '_Recycle Bin'

	CREATE TABLE #Items (itemId bigint)
	CREATE TABLE #Bundles (bundleId bigint)
	CREATE TABLE #Streams (streamId bigint, streamSize bigint)

	INSERT #Items
	SELECT RepositoryItemID as itemID
	  FROM dbo.RepositoryItem
	 WHERE RepositoryFolderID in 
		(select RepositoryFolderId from dbo.RepositoryFolder 
		where (@left <= leftOrdinal and rightOrdinal <= @right)
			and ownerId = @pOwnerId)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot get item list for folder(s).'
		  GOTO ErrorHandler
	   END

	IF EXISTS (
		SELECT RepositoryItemID
		  FROM dbo.AppUsageCount
		 WHERE ((ReferenceCount >0) OR (ImmutabilityCOunt > 0) )
				AND (
					RepositoryItemId in (
						SELECT itemId
						FROM #Items
				)
		)
	)
	BEGIN
		SELECT @sql_error = 1
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'An item in the recycle folder has been marked immutable, and so cannot be recycled.'
			  GOTO ErrorHandler
		   END
	END

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
		
	/*
	
	there is some conflict about the following clause, starting with "if (@pCheckCOEStudentPortfolio = 1)"
	
	In svn, at https://dev.hocprofessional.com/svn/common/trunk/Repository:149, anne removed it.
	She thinks that maybe she removed it in response to a complaint about the digital locker for efoliolite.
	She says she maybe recalls tha removing it fixed something.
	
	When we branched the tree to work on the StateEval_repo, the change wasn't made.
	
	So, the clause was removed for the efoliolite_repo, and is present in the stateeval_repo
	
	 - Note that the clause is only meaningful in the context of the maycomp database for coe.
	 
	 - The flag is set only in RepositoryMgr.EmptyCOEStudentRecycleBin, and there is no reference 
		to this method in all of ems and efoliolite, so I can't imagine how the change could have
		fixed anything in those applications.
		
	 - Since she doesn't remember what she did it for, it's possible that there was another 
		reason the change was made.     
	
	Given the above, i'm going to comment out this clause as I re-integrate the stateEval code base
	into the main repository code base.  The main reason is that may comp may be looked at for reference,
	but will certainly never be used again.  Whether or not the clause exists will be a complete no-op
	to everything else.
	
	However, efoliolite/ems *is* actively used.  So, we give precedence to the changes made in that db,
	even though they don't seem to be doing anything.
		
	--begin conflicting clause		
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
	--end conflicting clause
	*/

	INSERT #Bundles
	SELECT BundleId 
	  FROM dbo.Bundle
	 WHERE RepositoryItemID in 
		(SELECT ItemId from #Items where ItemID is not null)

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
	 WHERE ownerId = @pOwnerID

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
	 WHERE RepositoryItemID in 
		(SELECT itemID from #items)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'cannot delete item list.'
		  GOTO ErrorHandler
	   END

	--now delete folders 
	delete dbo.RepositoryFolder
	where (@left < leftOrdinal and rightOrdinal < @right)
		and ownerId = @pOwnerId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'folder deletion failed.'
		  GOTO ErrorHandler
	   END

				
	update dbo.RepositoryFolder
		set LeftOrdinal = case when LeftOrdinal > @left
			then LeftOrdinal - @MNOC
			else LeftOrdinal end,
		rightOrdinal =	  case when RightOrdinal > @left
			then RightOrdinal - @MNOC
			else RightOrdinal end
		where (LeftOrdinal > @right or RightOrdinal > @left)
			and ownerId = @pOwnerId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Renumber of indices failed.'
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


