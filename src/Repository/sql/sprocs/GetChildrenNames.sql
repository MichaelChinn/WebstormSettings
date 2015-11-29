if exists (select * from sysobjects 
where id = object_id('dbo.GetChildrenNames') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetChildrenNames.'
      drop procedure dbo.GetChildrenNames
   END
GO
PRINT '.. Creating sproc GetChildrenNames.'
GO
CREATE PROCEDURE GetChildrenNames
	 @pParentNodeId bigint
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

	create table #names (name varchar(2000))
	
	insert #names (name)
	SELECT name from dbo.Bitstream bs
	join dbo.Bundle bu on bu.BundleID = bs.BundleID
	join dbo.RepositoryItem ri on ri.RepositoryItemID = bu.RepositoryItemID
	join dbo.RepositoryFolder rf on rf.RepositoryFolderID = ri.RepositoryFolderID
	where rf.RepositoryFolderID = @pParentNodeID

	insert #names (name)
	SELECT FolderName from dbo.RepositoryFolder
	where ParentNodeID = @pParentNodeID

	select Name
	from #names

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


GO

