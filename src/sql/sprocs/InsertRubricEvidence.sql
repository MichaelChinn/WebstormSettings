if exists (select * from sysobjects 
where id = object_id('dbo.InsertRubricEvidence') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertRubricEvidence.'
      drop procedure dbo.InsertRubricEvidence
   END
GO
PRINT '.. Creating sproc InsertRubricEvidence.'
GO
CREATE PROCEDURE InsertRubricEvidence
	   @pRubricRowID BIGINT
	  ,@pPerformanceLevelID SMALLINT
	  ,@pRubricDescriptorText VARCHAR(MAX)
	  ,@pSupportingEvidenceText VARCHAR(MAX)
	  ,@pRubricEvidenceTypeID SMALLINT
	  ,@pSchoolYear SMALLINT
	  ,@pEvaluateeId BIGINT
	  ,@pCreatedByUserId BIGINT
	  ,@pCreationDateTime DATETIME
	  ,@pEvaluationTypeID SMALLINT
	  ,@pEvalSessionID BIGINT
	  ,@pIsPublic BIT
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

DECLARE @ID BIGINT

INSERT dbo.SERubricEvidence(
	RubricRowID,
	PerformanceLevelID,
	RubricDescriptorText,
	SupportingEvidenceText,
	RubricEvidenceTypeID,
	SchoolYear,
	EvaluateeId,
	CreatedByUserID,
	CreationDateTime,
	EvaluationTypeID,
	EvalSessionID,
	IsPublic)
VALUES (
	  @pRubricRowID,
	  @pPerformanceLevelID,
	  @pRubricDescriptorText,
	  @pSupportingEvidenceText,
	  @pRubricEvidenceTypeID,
	  @pSchoolYear,
	  @pEvaluateeId,
	  @pCreatedByUserId,
	  @pCreationDateTime,
	  @pEvaluationTypeID,
	  @pEvalSessionID,
	  @pIsPublic)


SELECT @sql_error = @@ERROR, @ID=SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SERubricEvidence  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


SELECT ID=@ID

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


