if exists (select * from sysobjects 
where id = object_id('dbo.InsertArtifact') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertArtifact.'
      drop procedure dbo.InsertArtifact
   END
GO
PRINT '.. Creating sproc InsertArtifact.'
GO
CREATE PROCEDURE InsertArtifact
	 @pSEUserID BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pRepositoryItemID BIGINT
	,@pArtifactTypeID SMALLINT
	,@pIsFile		BIT
	,@pComments		TEXT
	,@pUserPromptResponseID BIGINT = NULL
	,@pContextResponse VARCHAR(MAX)
	,@pAlignmentResponse VARCHAR(MAX)
	,@pReflectionResponse VARCHAR(MAX)
	,@pEvalSessionID BIGINT = NULL
	,@pEvaluationTypeID SMALLINT
	,@pGoalTemplateGoalID BIGINT = NULL
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



DECLARE @Id AS BIGINT, @UserPromptID BIGINT

INSERT dbo.SEArtifact(SchoolYear, DistrictCode, ArtifactTypeID, RepositoryItemID, Comments, IsPublic, UserPromptResponseID,
						ContextPromptResponse, AlignmentPromptResponse, ReflectionPromptResponse, UserID, EvalSessionID, GoalTemplateGoalID)
VALUES (@pSchoolYear, @pDistrictCode, @pArtifactTypeID, @pRepositoryItemID, @pComments, 0, @pUserPromptResponseID,
						@pContextResponse, @pAlignmentResponse, @pReflectionResponse, @pSEUserID, @pEvalSessionID, @pGoalTemplateGoalID)
SELECT @sql_error = @@ERROR, @ID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEArtifact  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

SELECT @UserPromptID = p.UserPromptID
  FROM dbo.SEUserPrompt p
 WHERE p.Title='IndividualArtifactNotes'
   AND p.EvaluationTYpeID=@pEvaluationTypeID

DECLARE @EvaluateeID BIGINT
SELECT @EvaluateeID = @pSEUserID
IF (@pEvalSessionID IS NOT NULL)
BEGIN
	SELECT @EvaluateeID = EvaluateeUserID FROM dbo.SEEvalSession WHERE EvalSessionID=@pEvalSessionID
END

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, ArtifactID, SchoolYear, DistrictCode)
VALUES (@UserPromptID, @EvaluateeID, @Id, @pSchoolYear, @pDistrictCode)

SELECT ArtifactID=@Id

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


