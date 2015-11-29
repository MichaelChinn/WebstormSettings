if exists (select * from sysobjects 
where id = object_id('dbo.UpdateRubricEvidence') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateRubricEvidence.'
      drop procedure dbo.UpdateRubricEvidence
   END
GO
PRINT '.. Creating sproc UpdateRubricEvidence.'
GO
CREATE PROCEDURE UpdateRubricEvidence
	   @pRubricEvidenceID BIGINT
	  ,@pRubricRowID BIGINT
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

UPDATE dbo.SERubricEvidence SET
	RubricRowID=@pRubricRowID,
	PerformanceLevelID=@pPerformanceLevelID,
	RubricDescriptorText=@pRubricDescriptorText,
	SupportingEvidenceText=@pSupportingEvidenceText,
	RubricEvidenceTypeID=@pRubricEvidenceTypeID,
	SchoolYear=@pSchoolYear,
	EvaluateeId=@pEvaluateeId,
	CreatedByUserID=@pCreatedByUserId,
	CreationDateTime=@pCreationDateTime,
	EvaluationTypeID=@pEvaluationTypeID,
	EvalSessionID=@pEvalSessionID,
	IsPublic=@pIsPublic
WHERE RubricEvidenceID=@pRubricEvidenceID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SERubricEvidence  failed. In: ' 
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


