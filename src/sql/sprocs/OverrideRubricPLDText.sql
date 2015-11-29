if exists (select * from sysobjects 
where id = object_id('dbo.OverrideRubricPLDText') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc OverrideRubricPLDText.'
      drop procedure dbo.OverrideRubricPLDText
   END
GO
PRINT '.. Creating sproc OverrideRubricPLDText.'
GO
CREATE PROCEDURE OverrideRubricPLDText
	 @pRubricRowID BIGINT
	,@pSessionID   BIGINT
	,@pPerformanceLevelID SMALLINT
	,@pText VARCHAR(MAX)
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

IF NOT EXISTS (SELECT RubricRowID 
				 FROM dbo.SERubricPLDTextOverride 
				WHERE RubricRowID=@pRubricRowID 
				  AND EvalSessionID=@pSessionID
				  AND UserID=@pUserID)
BEGIN
	INSERT dbo.SERubricPLDTextOverride(RubricRowID, EvalSessionID, UserID, PL1DescriptorText, PL2DescriptorText, PL3DescriptorText, PL4DescriptorText)
	SELECT @pRubricRowID
	      ,@pSessionID
	      ,@pUserID
	      ,rr.PL1Descriptor
		  ,rr.PL2Descriptor
		  ,rr.PL3Descriptor
		  ,rr.PL4Descriptor
	  FROM dbo.SERubricRow rr (NOLOCK)
	 WHERE rr.RubricRowID=@pRubricRowID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert to SERubricPLDTextOverride  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END

IF (@pPerformanceLevelID=1)
BEGIN
UPDATE dbo.SERubricPLDTextOverride
	SET PL1DescriptorText=@pText
WHERE RubricRowID=@pRubricRowID
  AND EvalSessionID=@pSessionID
  AND UserID=@pUserID
END
ELSE IF (@pPerformanceLevelID=2)
BEGIN
UPDATE dbo.SERubricPLDTextOverride
	SET PL2DescriptorText=@pText
WHERE RubricRowID=@pRubricRowID
  AND EvalSessionID=@pSessionID
  AND UserID=@pUserID
END
ELSE IF (@pPerformanceLevelID=3)
BEGIN
UPDATE dbo.SERubricPLDTextOverride
	SET PL3DescriptorText=@pText
WHERE RubricRowID=@pRubricRowID
  AND EvalSessionID=@pSessionID
  AND UserID=@pUserID
END
ELSE IF (@pPerformanceLevelID=4)
BEGIN
UPDATE dbo.SERubricPLDTextOverride
	SET PL4DescriptorText=@pText
WHERE RubricRowID=@pRubricRowID
  AND EvalSessionID=@pSessionID
  AND UserID=@pUserID
END

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SERubricPLDTextOverride  failed. In: ' 
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


