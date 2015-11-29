if exists (select * from sysobjects 
where id = object_id('dbo.[GetBitstreamForItemByName]') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc [GetBitstreamForItemByName].'
      drop procedure dbo.[GetBitstreamForItemByName]
   END
GO
PRINT '.. Creating sproc [GetBitstreamForItemByName].'
GO
CREATE PROCEDURE [dbo].[GetBitstreamForItemByName]
	 @pItemId bigint
	,@pBitstreamName varchar (2000)
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
	DECLARE @bundleId bigint
	SELECT @bundleId = bundleId
	  FROM dbo.bundle 
	 WHERE RepositoryItemId = @pItemId

	select * 
	from dbo.vBitstream
	where bundleId = @BundleID
	  AND Name = @pBitstreamName
	order by Name
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



