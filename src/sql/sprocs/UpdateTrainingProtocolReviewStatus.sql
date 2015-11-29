if exists (select * from sysobjects 
where id = object_id('dbo.UpdateTrainingProtocolReviewStatus') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateTrainingProtocolReviewStatus.'
      drop procedure dbo.UpdateTrainingProtocolReviewStatus
   END
GO
PRINT '.. Creating sproc UpdateTrainingProtocolReviewStatus.'
GO
CREATE PROCEDURE UpdateTrainingProtocolReviewStatus
	 @pRatingID BIGINT
	 ,@pProtocolID BIGINT
	 ,@pStatusTypeID SMALLINT

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


UPDATE dbo.SETrainingProtocolRating
   SET [STATUS]=@pStatusTypeID
 WHERE TrainingProtocolRatingID=@pRatingID
 
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SETrainingProtocolRating  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Calculate new avgrating, numratings on trainingprotocol

DECLARE @NewAvg DECIMAL
DECLARE @NewNumRatings SMALLINT

SELECT @NewAvg=AVG(r.Rating)
	  ,@NewNumRatings=COUNT(r.TrainingProtocolRatingID)
  FROM dbo.SETrainingProtocolRating r
  WHERE r.TrainingProtocolID=@pProtocolID
    AND r.STATUS=2
  
UPDATE dbo.SETrainingProtocol
   SET AvgRating=@NewAvg
      ,NumRatings=@NewNumRatings
 WHERE TrainingProtocolID=@pProtocolID

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


