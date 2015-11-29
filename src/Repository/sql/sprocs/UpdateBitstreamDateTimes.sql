GO
IF OBJECT_ID ('dbo.UpdateBitstreamDateTimes') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc UpdateBitstreamDateTimes.'
      DROP PROCEDURE dbo.UpdateBitstreamDateTimes
   END
GO
PRINT '.. Creating sproc UpdateBitstreamDateTimes.'
GO
CREATE PROCEDURE dbo.UpdateBitstreamDateTimes
(
	@pBitStreamId bigint
	,@pLastUpload datetime
	,@pInitialUpload dateTime
)
AS

SET NOCOUNT ON 
---------------
-- VARIABLES --
---------------
DECLARE @sql_error                   INT
       ,@ProcName                    SYSNAME
       ,@tran_count                  INT
        ,@sql_error_message	     VARCHAR(250)
---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

IF @tran_count = 0
   BEGIN TRANSACTION


UPDATE dbo.Bitstream 
   SET
		lastUpload = @pLastUpload
		,initialUpload = @pInitialUpload
      
		   
 WHERE BitstreamID = @pBitStreamId


SELECT @sql_error = @@Error
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Update Bitstream DateTime Failed'
	GOTO ErrorHandler
END


-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + 
      	  '-- BitstreamId = ' + convert(varchar(20), ISNULL(@pBitstreamID, '')) + 
	      '-- LastUpload = ' + convert(varchar(20), ISNULL(@pLastUpload, '')) + 
	      '-- InitialUpload = ' + convert(varchar(20), ISNULL(@pInitialUpload, '')) + 
          '.  In: ' + @ProcName + '. ' 
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

RETURN(@sql_error)

GO

