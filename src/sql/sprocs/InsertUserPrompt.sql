if exists (select * from sysobjects 
where id = object_id('dbo.InsertUserPrompt') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertUserPrompt.'
      drop procedure dbo.InsertUserPrompt
   END
GO
PRINT '.. Creating sproc InsertUserPrompt'
GO
CREATE PROCEDURE InsertUserPrompt
	@pPromptTypeID SMALLINT,
	@pTitle VARCHAR(200),
	@pQuestion VARCHAR(MAX),
	@pDistrictCode VARCHAR(20),
	@pSchoolCode VARCHAR(20),
	@pCreatedByUserID BIGINT,
	@pPublished BIT,
	@pRetired BIT,
	@pEvaluationTypeID SMALLINT,
	@pPrivate BIT,
	@pEvaluateeID BIGINT = NULL,
	@pEvalSessionID BIGINT,
	@pCreatedAsAdmin BIT,
	@pSchoolYear SMALLINT,
	@pPublishedDate DATETIME




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

DECLARE @Id BIGINT

INSERT dbo.SEUserPrompt(PromptTypeID, Title, Prompt, DistrictCode, SchoolCode, CreatedByUserID,
						EvaluationTypeID, EvaluateeID, CreatedAsAdmin, EvalSessionID,
						Sequence, SchoolYear, Published, PublishedDate, Retired, Private)
VALUES(@pPromptTypeID, @pTitle, @pQuestion, @pDistrictCode, @pSchoolCode, @pCreatedByUserID,
						@pEvaluationTypeID, @pEvaluateeID, @pCreatedAsAdmin, @pEvalSessionID,
						0, @pSchoolYear, @pPublished, @pPublishedDate, @pRetired, @pPrivate)
SELECT @sql_error = @@ERROR, @Id = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPrompt  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT ID=@Id

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


