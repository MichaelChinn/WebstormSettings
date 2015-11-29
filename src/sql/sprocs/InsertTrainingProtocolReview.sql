if exists (select * from sysobjects 
where id = object_id('dbo.InsertTrainingProtocolReview') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertTrainingProtocolReview.'
      drop procedure dbo.InsertTrainingProtocolReview
   END
GO
PRINT '.. Creating sproc InsertTrainingProtocolReview.'
GO
CREATE PROCEDURE InsertTrainingProtocolReview
	 @pProtocolID BIGINT
	 ,@pUserID BIGINT
	 ,@pRating DECIMAL
	 ,@pComments VARCHAR(MAX)
	 ,@pAnnonymous BIT

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



DECLARE @Id AS BIGINT
DECLARE @theDate DATETIME
SELECT @theDate = GETDATE()

INSERT dbo.SETrainingProtocolRating(TrainingProtocolID, UserID, Rating, Comments, CreationDate, Status, IsAnnonymous)
VALUES(@pProtocolID, @pUserID, @pRating, @pComments, @theDate, 1, @pAnnonymous)
SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SETrainingProtocolRating  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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


