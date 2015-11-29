if exists (select * from sysobjects 
where id = object_id('dbo.ReplaceBitstreamDataFromFile') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ReplaceBitstreamDataFromFile.'
      drop procedure dbo.ReplaceBitstreamDataFromFile
   END
GO
PRINT '.. Creating sproc ReplaceBitstreamDataFromFile.'
GO
CREATE PROCEDURE ReplaceBitstreamDataFromFile
	 @pBitstreamId bigint

	,@pFullPath varchar(1024) 
	,@pDebug BIT = 0          
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
	DECLARE @contentTYpe varchar(20)

	select @ContentTYpe = contentType
      FRom dbo.Bitstream
	 Where BitstreamID = @pBitstreamID

	if (@contentType='URL')
	BEGIN
          SELECT @sql_error = -1
		  SELECT @sql_error_message = 'You may not add stream data to an URL type. '
		  GOTO ErrorHandler
	END

	CREATE TABLE #fileContent(fileContent VARBINARY(MAX))

	DECLARE @SqlCmd VARCHAR (5000)
	DECLARE @Content AS VARBINARY(MAX), @BitstreamId bigint
	/*
	SELECT @SqlCmd = 'declare @content as varbinary(max) '
	+ 'SELECT @Content = CAST(bulkcolumn AS VARBINARY(MAX)) '
	+ 'FROM OPENROWSET( BULK '''+ @pBasePath + @pFileName + ''', SINGLE_BLOB ) as x'
	*/
	SELECT @SqlCmd = 'insert #fileContent(fileContent) '
	+ 'SELECT CAST(bulkcolumn AS VARBINARY(MAX)) '
	+ 'FROM OPENROWSET( BULK '''+ @pFullPath + ''', SINGLE_BLOB ) as x'
    
    EXEC(@sqlCmd)
    
    SELECT @content = fileContent FROM #fileContent

	IF (@pDebug=1)
	BEGIN
		SELECT @sqlCmd
		SELECT DATALENGTH(@content)
	END
    
	declare @now datetime, @oldSize bigint, @ownerId bigint
	select @now = GetDATe()
		, @oldSize=[size]
		, @ownerId = ownerId
	  FROM dbo.Bitstream
	 WHERE bitstreamID = @pBitstreamId

	update dbo.Bitstream
	   set Bitstream = @content
		,size = DATALENGTH(@content)
		,lastUpload=@now
	where BitStreamId = @pBitstreamId

	declare @id bigint
	select @id = scope_identity()
		,@sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to update bitstream. '
		  GOTO ErrorHandler
	   END

	UPDATE dbo.UserRepoContext
	   SET DiskUsage = DiskUsage - @oldSize + DATALENGTH(@content)
	 WHERE ownerId = @ownerId

	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem with updating file size. '
		  GOTO ErrorHandler
	   END


END
/***********************************************************************************/

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
      SELECT @sql_error_message = @sql_error_message + '... in ' + @ProcName
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

