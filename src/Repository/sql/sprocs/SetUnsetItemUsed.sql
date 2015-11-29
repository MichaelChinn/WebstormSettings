GO
IF OBJECT_ID ('dbo.SetUnsetItemUsed') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc SetUnsetItemUsed.'
      DROP PROCEDURE dbo.SetUnsetItemUsed
   END
GO
PRINT '.. Creating sproc SetUnsetItemUsed.'
GO
CREATE PROCEDURE dbo.SetUnsetItemUsed
(
	@pItemId		BIGINT
	,@pIsUsed  bit
	,@pApplicationString varchar (50)
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

IF not exists (
	SELECT repositoryItemID
	  FROM dbo.RepositoryITEm
	 WHERE repositoryItemID = @pItemID
)
BEGIN
	SELECT @sql_error = 1
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not find'
		GOTO ErrorHandler
	END
END

IF not exists (
	SELECT repositoryItemId
	  FROM dbo.AppUsageCount
	 WHERE ApplicationString = @pApplicationString
	   AND RepositoryItemId = @pItemId
)
BEGIN
	INSERT dbo.AppUsageCount (ApplicationString, RepositoryItemID, ReferenceCount, ImmutabilityCount)
	VALUES (@pApplicationString, @pItemId, 0, 0)

	SELECT @sql_error = @@error
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Problem inserting app usage count record'
		GOTO ErrorHandler
	END

END

if (@pIsUsed=1)
BEGIN
	UPDATE dbo.AppUsageCount 
	   SET
		 ReferenceCount = ReferenceCount + 1
		 WHERE ApplicationString = @pApplicationString
		   AND RepositoryItemId = @pItemId

	SELECT @sql_error = @@Error
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not increment reference count for this item'
		GOTO ErrorHandler
	END
END

ELSE BEGIN
	DECLARE @count int
	SELECT @count = ReferenceCount
	  FROM dbo.AppUsageCOunt
	 WHERE ApplicationString = @pApplicationString
	   AND RepositoryItemId = @pItemId

	IF (@count > 0)
	BEGIN
		UPDATE dbo.AppUsageCount 
		   SET
			 ReferenceCount = ReferenceCount - 1
			 WHERE ApplicationString = @pApplicationString
			   AND RepositoryItemId = @pItemId

		SELECT @sql_error = @@Error
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not decrement reference count for this item'
			GOTO ErrorHandler
		END



	END
END

DELETE dbo.AppUsageCount
where RepositoryItemId = @pItemId
	and ImmutabilityCount <1
	and ReferenceCount <1

SELECT @sql_error = @@Error
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete a zeroed AppUsageCount record'
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
	'--  Application String = ' + @pApplicationString +
	'--  ItemId  ='     + convert (varchar(20), ISNULL(@pItemId		        , '')) +
	'--  Used Flag =' + convert (varchar(20), ISNULL(@pIsUsed	  , '')) +
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

