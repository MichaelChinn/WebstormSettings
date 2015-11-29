if exists (select * from sysobjects 
where id = object_id('dbo.ChunkInStreamData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc ChunkInStreamData.'
      drop procedure dbo.ChunkInStreamData
   END
GO
PRINT '.. Creating sproc ChunkInStreamData.'
GO
CREATE PROCEDURE ChunkInStreamData
	 @pBitstreamId bigint
	,@pBitstream image
	,@pAppend bit = 1
AS
SET NOCOUNT ON 


/* from the web... 

http://groups.google.com/group/microsoft.public.dotnet.languages.csharp/browse_thread/thread/6c9e5e75ae39826b/998c53ff8afb02eb?lnk=st&q=mgt+textptr#998c53ff8afb02eb

ALTER PROC mgtsave @id int, @data image, @append bit = 1 
        AS 
        DECLARE @ptr binary(16) 
        IF @append = 0 -- need to put in some empty data (not null) for 
TEXTPTR to work 
            UPDATE MGT 
            SET  data = '' 
            WHERE id = @id 


        SELECT @ptr = TEXTPTR(data) 
        FROM  MGT 
        WHERE id = @id 


        IF @append = 1 
            UPDATETEXT MGT.data @ptr NULL 0 @data 
        ELSE 
            WRITETEXT MGT.data @ptr @data 
*/
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
    
	declare @now datetime
	select @now = GetDATe()

	if (@pAppend=0)	--first time through
		UPDATE dbo.Bitstream 
		   set Bitstream = ''
				,lastUpload = @now
		 WHERE BitstreamId = @pBitstreamID

	DECLARE @ptr binary(16) 

    SELECT @ptr = TEXTPTR(Bitstream) 
      FROM  dbo.Bitstream
     WHERE BitstreamId = @pBitstreamId

    IF @pAppend = 1 
        UPDATETEXT dbo.Bitstream.Bitstream @ptr NULL 0 @pBitstream 
    ELSE 
        WRITETEXT dbo.Bitstream.Bitstream @ptr @pBitstream


	select @sql_error = @@error
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem trying to update bitstream. '
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

