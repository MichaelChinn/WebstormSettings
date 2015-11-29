if exists (select * from sysobjects 
where id = object_id('dbo.GetDiskUsageForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDiskUsageForUser.'
      drop procedure dbo.GetDiskUsageForUser
   END
GO
PRINT '.. Creating sproc GetDiskUsageForUser.'
GO
CREATE PROCEDURE GetDiskUsageForUser
		@pUserId bigint
		
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

SELECT DiskUsage
  FROM dbo.UserRepoContext
 WHERE OwnerID = @pUserId


ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


GO


