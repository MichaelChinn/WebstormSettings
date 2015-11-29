if exists (select * from sysobjects 
where id = object_id('dbo.AddBundle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddBundle.'
      drop procedure dbo.AddBundle
   END
GO
PRINT '.. Creating sproc AddBundle.'
GO
CREATE PROCEDURE AddBundle
		@pItemId bigint
		,@pPrimaryBitstreamID bigint = null

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
	if (dbo.ItemIsImmutable_fn(@pItemId)=1)
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'Item Immutable; cannot add bundle. '
		  GOTO ErrorHandler
	END

	if not exists (
		select RepositoryItemID 
		  from dbo.RepositoryItem 
		 where RepositoryItemID = @pItemID)
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'Non existant item id. '
		  GOTO ErrorHandler
	END

	insert dbo.Bundle (PrimaryBitstreamID, repositoryItemID)
	values (@pPrimaryBitstreamId, @pItemId)

	declare @id bigint
	select @id = scope_identity()
		,@sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to insert a new bundle. '
		  GOTO ErrorHandler
	   END

	select * from dbo.vBundle where bundleId = @id


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
			+ 'ItemId: ' + Convert(varchar(20), @pItemID) + '.  '
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


