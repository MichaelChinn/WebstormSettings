if exists (select * from sysobjects 
where id = object_id('dbo.GetDescendentItems') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDescendentItems.'
      drop procedure dbo.GetDescendentItems
   END
GO
PRINT '.. Creating sproc GetDescendentItems.'
GO
CREATE PROCEDURE GetDescendentItems
	 @pParentNodeID bigint
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

	DECLARE @lft bigint, @rgt bigint, @ownerID bigint
	select @lft=leftOrdinal, @rgt=rightOrdinal, @ownerId=ownerId
	from repositoryFolder where RepositoryFolderID = @pParentNodeId

	select *
	from dbo.vRepositoryItem
	where RepositoryFolderId in
		(select RepositoryFolderID 
		from dbo.RepositoryFolder
		where @lft <= leftOrdinal and rightOrdinal<=@rgt
			and ownerId = @ownerID
		)
	order by ItemName

END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
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


