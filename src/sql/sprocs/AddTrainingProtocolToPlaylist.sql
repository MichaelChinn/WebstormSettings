if exists (select * from sysobjects 
where id = object_id('dbo.AddTrainingProtocolToPlaylist') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AddTrainingProtocolToPlaylist.'
      drop procedure dbo.AddTrainingProtocolToPlaylist
   END
GO
PRINT '.. Creating sproc AddTrainingProtocolToPlaylist.'
GO
CREATE PROCEDURE AddTrainingProtocolToPlaylist
	 @pProtocolID BIGINT
	 ,@pUserID BIGINT

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

IF NOT EXISTS (SELECT TrainingProtocolID FROM dbo.SETrainingProtocolPlaylist WHERE TrainingProtocolID=@pProtocolID AND UserID=@pUserID)
BEGIN

INSERT dbo.SETrainingProtocolPlaylist(TrainingProtocolID, UserID)
VALUES(@pProtocolID, @pUserID)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SETrainingProtocolPlaylist  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

END

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


