if exists (select * from sysobjects 
where id = object_id('dbo.InsertResource') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertResource.'
      drop procedure dbo.InsertResource
   END
GO
PRINT '.. Creating sproc InsertResource.'
GO
CREATE PROCEDURE InsertResource
	 @pSEUserID BIGINT
	,@pRepositoryItemID BIGINT
	,@pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pIsFile		BIT
	,@pComments		TEXT
	,@pResourceType SMALLINT
	,@pSchoolYear SMALLINT
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

INSERT dbo.SEResource(RepositoryItemID, DistrictCode, SchoolCode, Comments, ResourceTypeID, SchoolYear)
VALUES (@pRepositoryItemID, @pDistrictCode, @pSchoolCode, @pComments, @pResourceType, @pSchoolYear)
SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEResource  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT ResourceID=@Id

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


