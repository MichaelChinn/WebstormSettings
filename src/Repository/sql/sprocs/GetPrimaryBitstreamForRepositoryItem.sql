if exists (select * from sysobjects 
where id = object_id('dbo.GetPrimaryBitstreamForRepositoryItem') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPrimaryBitstreamForRepositoryItem.'
      drop procedure dbo.GetPrimaryBitstreamForRepositoryItem
   END
GO
PRINT '.. Creating sproc GetPrimaryBitstreamForRepositoryItem.'
GO
CREATE PROCEDURE GetPrimaryBitstreamForRepositoryItem
	 @pRepositoryItemId BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error              INT
       ,@ProcName               SYSNAME
       ,@tran_count             INT
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

SELECT s.*
  FROM dbo.vBitstream s
  JOIN dbo.Bundle b
    ON s.BitstreamId=b.PrimaryBitstreamID
  JOIN dbo.RepositoryItem ri
    ON ri.RepositoryItemID=b.RepositoryItemID
 WHERE ri.RepositoryItemID=@pRepositoryItemID
	

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

