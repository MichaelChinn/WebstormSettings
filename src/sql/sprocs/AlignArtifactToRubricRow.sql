if exists (select * from sysobjects 
where id = object_id('dbo.AlignArtifactToRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AlignArtifactToRubricRow.'
      drop procedure dbo.AlignArtifactToRubricRow
   END
GO
PRINT '.. Creating sproc AlignArtifactToRubricRow.'
GO
CREATE PROCEDURE AlignArtifactToRubricRow
	 @pArtifactID BIGINT
	,@pRubricRowID BIGINT
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

IF NOT EXISTS (SELECT RubricRowID FROM dbo.SEArtifactRubricRowAlignment WHERE ArtifactID=@pArtifactID AND RubricRowID= @pRubricRowID)
BEGIN

INSERT dbo.SEArtifactRubricRowAlignment(ArtifactID, RubricRowID)
VALUES (@pArtifactID, @pRubricRowID)
SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEArtifactRubricRowAlignment  failed. In: ' 
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


