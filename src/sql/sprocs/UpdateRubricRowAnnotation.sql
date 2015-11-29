if exists (select * from sysobjects 
where id = object_id('dbo.UpdateRubricRowAnnotation') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateRubricRowAnnotation.'
      drop procedure dbo.UpdateRubricRowAnnotation
   END
GO
PRINT '.. Creating sproc UpdateRubricRowAnnotation.'
GO
CREATE PROCEDURE UpdateRubricRowAnnotation
	 @pRubricRowID BIGINT
	,@pSessionID   BIGINT
	,@pAnnotation VARCHAR(MAX)
	,@pUserID	   BIGINT
	,@pAppend BIT = 0
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@sql_error_message   	NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@ProcName               = OBJECT_NAME(@@PROCID)

DECLARE @AnnotationID BIGINT
SELECT @AnnotationID = SERubricRowAnnotationID
				 FROM dbo.SERubricRowAnnotation (NOLOCK)
				WHERE RubricRowID=@pRubricRowID 
				  AND EvalSEssionID=@pSessionID
				  AND UserID=@pUserID
				  
IF (@AnnotationID IS NULL)
BEGIN
	INSERT dbo.SERubricRowAnnotation(RubricRowID, EvalSessionID, Annotation, UserID)
	VALUES (@pRubricRowID, @pSessionID, @pAnnotation, @pUserID)
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert to SERubricRowAnnotation  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END
END
ELSE
BEGIN


UPDATE dbo.SERubricRowAnnotation
	SET Annotation=CASE WHEN (@pAppend=0) THEN @pAnnotation ELSE Annotation + ' ' + @pAnnotation END
WHERE RubricRowID=@pRubricRowID
  AND EvalSessionID=@pSessionID
  AND UserID=@pUserID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SERubricRowAnnotation  failed. In: ' 
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
      RAISERROR(@sql_error_message, 15, 10)
   END



GO


