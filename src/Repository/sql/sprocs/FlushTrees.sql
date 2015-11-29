if exists (select * from sysobjects 
where id = object_id('dbo.FlushTrees') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc FlushTrees.'
      drop procedure dbo.FlushTrees
   END
GO
PRINT '.. Creating sproc FlushTrees.'
GO
CREATE PROCEDURE FlushTrees

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


	ALTER TABLE [dbo].[RepositoryItem] DROP CONSTRAINT [FK_RepositoryItem_RepositoryFolder]
	ALTER TABLE [dbo].[Bitstream] DROP CONSTRAINT [FK_Bitstream_Bundle]
	ALTER TABLE [dbo].[Bundle] DROP CONSTRAINT [FK_Bundle_Bitstream]
	ALTER TABLE [dbo].[Bundle] DROP CONSTRAINT [FK_Bundle_RepositoryItem]
	ALTER TABLE [dbo].[AppUsageCount] DROP CONSTRAINT [FK_AppUsageCount_RepositoryItem]

	UPDATE dbo.Bundle
	  SET PrimaryBitstreamId=null
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not set primary bitstream null.'
		  GOTO ErrorHandler
	   END


	truncate table dbo.BitStream 

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove bitstreams.'
		  GOTO ErrorHandler
	   END

		
	truncate table dbo.Bundle

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove bundle.'
		  GOTO ErrorHandler
	   END


	truncate table dbo.RepositoryItem 

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user files... failed.'
		  GOTO ErrorHandler
	   END

	truncate table dbo.RepositoryFolder

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user folders... failed.'
		  GOTO ErrorHandler
	   END

	truncate table dbo.UserRepoContext
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove the user context... failed.'
		  GOTO ErrorHandler
	   END

	truncate table dbo.AppUsageCount
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Could not remove app Usage counts... failed.'
		  GOTO ErrorHandler
	   END


	ALTER TABLE [dbo].[RepositoryItem]  WITH CHECK ADD  CONSTRAINT [FK_RepositoryItem_RepositoryFolder] FOREIGN KEY([RepositoryFolderId])
	REFERENCES [dbo].[RepositoryFolder] ([RepositoryFolderId])
	ALTER TABLE [dbo].[RepositoryItem] CHECK CONSTRAINT [FK_RepositoryItem_RepositoryFolder]

	ALTER TABLE [dbo].[Bitstream]  WITH CHECK ADD  CONSTRAINT [FK_Bitstream_Bundle] FOREIGN KEY([BundleID])
	REFERENCES [dbo].[Bundle] ([BundleID])
	ALTER TABLE [dbo].[Bitstream] CHECK CONSTRAINT [FK_Bitstream_Bundle]

	ALTER TABLE [dbo].[Bundle]  WITH CHECK ADD  CONSTRAINT [FK_Bundle_Bitstream] FOREIGN KEY([PrimaryBitstreamID])
	REFERENCES [dbo].[Bitstream] ([BitstreamID])
	ALTER TABLE [dbo].[Bundle] CHECK CONSTRAINT [FK_Bundle_Bitstream]

	ALTER TABLE [dbo].[Bundle]  WITH CHECK ADD  CONSTRAINT [FK_Bundle_RepositoryItem] FOREIGN KEY([RepositoryItemID])
	REFERENCES [dbo].[RepositoryItem] ([RepositoryItemId])
	ALTER TABLE [dbo].[Bundle] CHECK CONSTRAINT [FK_Bundle_RepositoryItem]

	ALTER TABLE [dbo].[AppUsageCount] WITH CHECK ADD CONSTRAINT [FK_AppUsageCount_RepositoryItem] FOREIGN KEY ([RepositoryItemId])
	REFERENCES [dbo].[RepositoryItem] ([RepositoryItemId])
	ALTER TABLE [dbo].[AppUsageCount] CHECK CONSTRAINT [FK_AppUsageCount_RepositoryItem]




END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
	  ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '---'
            + 'In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
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


