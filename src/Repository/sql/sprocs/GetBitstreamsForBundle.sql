if exists (select * from sysobjects 
where id = object_id('dbo.GetBitstreamsForBundle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetBitstreamsForBundle.'
      drop procedure dbo.GetBitstreamsForBundle
   END
GO
PRINT '.. Creating sproc GetBitstreamsForBundle.'
GO
CREATE PROCEDURE GetBitstreamsForBundle
	 @pBundleId bigint
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
	from dbo.vBitstream
	where bundleId = @pBundleID
	order BY CASE WHEN contentType='URL' THEN URL ELSE [NAME] END
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

