if exists (select * from sysobjects 
where id = object_id('dbo.AdvanceEvaluationWorkflow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AdvanceEvaluationWorkflow.'
      drop procedure dbo.AdvanceEvaluationWorkflow
   END
GO
PRINT '.. Creating sproc AdvanceEvaluationWorkflow.'
GO
CREATE PROCEDURE dbo.AdvanceEvaluationWorkflow
	@pEvaluationID bigint
	,@pToStateID bigint
	,@pUserID bigint
    ,@pComment text = ''
	,@sql_error_message VARCHAR(1000) OUTPUT

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT

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

BEGIN

    IF EXISTS (SELECT WfStateID=WfStateID FROM dbo.SEEvaluation WHERE EvaluationID=@pEvaluationID AND WfStateID=@pToStateID)
    BEGIN
		GOTO ProcEnd
    END
    
    DECLARE @TimeNow DATETIME ,
        @CurrentStateID BIGINT ,
        @WfTransitionID BIGINT,
        @WfTransitionName VARCHAR(100)
                
    SELECT  @TimeNow = GETDATE() ,
            @CurrentStateID = WfStateID
      FROM  dbo.SEEvaluation
     WHERE  EvaluationID = @pEvaluationID

	SELECT @WfTransitionId = WfTransitionID ,
	       @WfTransitionName = s_start.ShortName + '-' + s_end.ShortName
      FROM dbo.SEWfTransition t
      JOIN dbo.SEWfState s_start ON t.StartStateID=s_start.WfStateID
      JOIN dbo.SEWfState s_end ON t.EndStateID=s_end.WfStateID
	 WHERE t.StartSTateID = @currentStateID 
       AND t.EndStateID = @pToStateID
	
	IF (@wfTransitionId IS NULL)
	BEGIN
		SELECT @sql_error = -1
		SELECT @sql_error_message = 'Illegal transition '
		GOTO ErrorHandler
	END

	UPDATE dbo.SEEvaluation 
       SET WfStateID = @pToStateID 
	 WHERE EvaluationID = @pEvaluationID

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update evaluation state here. '
		GOTO ErrorHandler
	END

	IF (@WfTransitionName = 'DRAFT-CONFERENCE')
	BEGIN
		 UPDATE dbo.SEEvaluation 
		   SET VisibleToEvaluatee=1
		   	  ,SubmissionCount=(SubmissionCount+1)
		 WHERE EvaluationID = @pEvaluationID

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not update evaluation state here. '
			
		END
	END
	
	IF (@WfTransitionName LIKE '%-DRAFT')
	BEGIN
		 UPDATE dbo.SEEvaluation 
		   SET VisibleToEvaluatee=1
		      ,ByPassSGScores=0
			 -- ,SGScoreOverrideComment=''
		      ,AutoSubmitAfterReceipt=1
		      ,ByPassReceipt=0
		     -- ,ByPassReceiptOverrideComment=''
		      ,DropToPaper=0
		    --  ,DropToPaperOverrideComment=''
		      ,MarkedFinalDateTime=NULL
		      ,FinalReportRepositoryItemID=NULL
		      ,HasBeenSubmitted=0
		 WHERE EvaluationID = @pEvaluationID

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not update evaluation state here. '
			
		END
	END
	
	IF (@WfTransitionName = 'CONFERENCE-RECEIPT')
	BEGIN
		 UPDATE dbo.SEEvaluation 
		   SET MarkedFinalDateTime = GETDATE()
		 WHERE EvaluationID = @pEvaluationID

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not update evaluation state here. '
			
		END
	END
	
	IF (@WfTransitionName LIKE '%-SUBMITTED')
	BEGIN
		 UPDATE dbo.SEEvaluation 
		   SET HasBeenSubmitted=1
		      ,SubmissionDate=GETDATE()
		 WHERE EvaluationID = @pEvaluationID

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not update evaluation state here. '
			
		END
	END
	
	INSERT dbo.SEEvaluationWfHistory (EvaluationID, WfTransitionID, UserId, Timestamp, Comment)
	VALUES (@pEvaluationID, @WfTransitionId, @pUserId, @TimeNow, @pComment)

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not insert entry into wf history. '
		GOTO ErrorHandler
	END	
	
END

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
		SELECT @sql_error_message = @sql_error_message +
		'EvaluationId : ' + Convert(varchar(20), @pEvaluationID) + '; ' +
        'wfTransitionID : '   + Convert(varchar(20), isNull(@wfTransitionID,'-')) + '; ' +
		'StartState : '     + Convert(varchar(20), @currentStateID)   + '; ' +
		'EndState : ' + Convert(varchar(20), @pToStateID) + '... ' +
		'In: ' + @ProcName

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


