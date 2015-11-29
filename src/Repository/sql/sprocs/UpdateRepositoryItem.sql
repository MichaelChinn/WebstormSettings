GO
IF OBJECT_ID ('dbo.UpdateRepositoryItem') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc UpdateRepositoryItem.'
      DROP PROCEDURE dbo.UpdateRepositoryItem
   END
GO
PRINT '.. Creating sproc UpdateRepositoryItem.'
GO
CREATE PROCEDURE dbo.UpdateRepositoryItem
(
	@pItemId		BIGINT
	,@pItemName		varchar(512)
	,@pDescription		varchar(1024)
	,@pKeywords		varchar(1024)
	,@pVerifiedByStudent	BIT
	,@pWithdrawnFlag	bit
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

DECLARE @IsImmutable bit
select @IsImmutable = dbo.ItemIsImmutable_fn(@pItemId)

if (@IsImmutable=1)
BEGIN
      SELECT @sql_error = -1
	  SELECT @sql_error_message = 'Item immutable; cannot add bundle. '
	  GOTO ErrorHandler
END

UPDATE dbo.RepositoryItem 
   SET
	 ItemName              =@pItemName
	,Description           =@pDescription
	,Keywords              =@pKeywords
	,VerifiedByStudent     =@pVerifiedByStudent
	,WithdrawnFlag         =@pWithdrawnFlag

 WHERE RepositoryItemId = @pItemId

SELECT @sql_error = @@Error
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Update Repository Item Failed'
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

	'--  ItemId  ='     + convert (varchar(20), ISNULL(@pItemId		        , '')) +
	'--  ItemName ='    + convert (varchar(20), ISNULL(@pItemName		      , '')) +
	'--  Description =' + convert (varchar(20), ISNULL(@pDescription	    , '')) +
	'--  Keywords ='    + convert (varchar(20), ISNULL(@pKeywords		      , '')) +
	'--  VerifiedByStudent =' + convert (varchar(20), ISNULL(@pVerifiedByStudent, '')) +
	'--  WithdrawnFlag =' + convert (varchar(20), ISNULL(@pWithdrawnFlag	  , '')) +
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

