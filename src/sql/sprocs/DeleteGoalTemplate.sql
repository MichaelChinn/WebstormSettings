if exists (select * from sysobjects 
where id = object_id('dbo.DeleteGoalTemplate') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DeleteGoalTemplate.'
      drop procedure dbo.DeleteGoalTemplate
   END
GO
PRINT '.. Creating sproc DeleteGoalTemplate.'
GO
CREATE PROCEDURE DeleteGoalTemplate
	 @pGoalTemplateID BIGINT
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

-- change the type to OTHER and remove link to goal
UPDATE a
   SET GoalTemplateGoalID=NULL
      ,ArtifactTypeID=4
      ,IsPublic=0
  FROM dbo.SEArtifact a
  JOIN dbo.SEGoalTemplateGoal gtg ON gtg.GoalTemplateGoalID=a.GoalTemplateGoalID
  WHERE gtg.GoalTemplateID=@pGoalTemplateID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEArtifact  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Delete goal feedback prompt

DELETE dbo.SEUserPromptResponseEntry
 WHERE UserPromptResponseID IN (SELECT UserPromptResponseID
							      FROM dbo.SEUserPromptResponse	
							      WHERE GoalTemplateGoalID IN (SELECT GoalTemplateGoalID FROM dbo.SEGoalTemplateGoal WHERE GoalTemplateID=@pGoalTemplateID))
 SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponseEntry  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEUserPromptResponse
 WHERE GoalTemplateGoalID IN
	  (SELECT GoalTemplateGoalID FROM dbo.SEGoalTemplateGoal WHERE GoalTemplateID=@pGoalTemplateID)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEUserPromptResponse failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END 

-- Delete goal process steps
DELETE dbo.SEGoalTemplateProcessStep
 WHERE GoalTemplateID=@pGoalTemplateID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEGoalTemplateProcessStep failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END   

DELETE dbo.SEGoalTemplateGoal
 WHERE GoalTemplateID=@pGoalTemplateID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEGoalTemplateGoal failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEGoalTemplateRubricRowAlignment
 WHERE GoalTemplateID=@pGoalTemplateID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEGoalTemplateRubricRowAlignment  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SEGoalTemplate
 WHERE GoalTemplateID=@pGoalTemplateID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SEGoalTemplate  failed. In: ' 
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


