if exists (select * from sysobjects 
where id = object_id('dbo.GetBitstreamData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetBitstreamData.'
      drop procedure dbo.GetBitstreamData
   END
GO
PRINT '.. Creating sproc GetBitstreamData.'
GO
CREATE PROCEDURE GetBitstreamData
	 @pBitstreamId bigint
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
	select Bitstream
	from dbo.Bitstream 
	where BitStreamId = @pBitstreamId
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

