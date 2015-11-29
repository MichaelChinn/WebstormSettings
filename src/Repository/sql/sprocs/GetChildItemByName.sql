if exists (select * from sysobjects 
where id = object_id('dbo.GetChildItemByName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetChildItemByName.'
      drop procedure dbo.GetChildItemByName
   END
GO
PRINT '.. Creating sproc GetChildItemByName.'
GO
CREATE PROCEDURE GetChildItemByName
	 @pParentNodeId bigint
	,@pName varchar (512)
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
	select *
	from dbo.vRepositoryItem
	where RepositoryFolderId = @pParentNodeId
	and ItemName = @pName
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

