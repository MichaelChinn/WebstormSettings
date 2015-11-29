if exists (select * from sysobjects 
where id = object_id('dbo.RemovePracticeSession') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RemovePracticeSession.'
      drop procedure dbo.RemovePracticeSession
   END
GO
PRINT '.. Creating sproc RemovePracticeSession.'
GO
CREATE PROCEDURE RemovePracticeSession
	@pPracticeSessionID BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
	   ,@sql_error_message		   VARCHAR(500)


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
	 
	CREATE TABLE #Session(ID BIGINT IDENTITY(1,1) NOT NULL, SessionID BIGINT)
	INSERT INTO #Session(SessionID)
	SELECT EvalSessionID
	  FROM dbo.SEPracticeSessionParticipant
	 WHERE PracticeSessionID=@pPracticeSessionID
	   
	DELETE dbo.SEPracticeSessionParticipant
	 WHERE PracticeSessionID=@pPracticeSessionID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'DELETE SEPracticeSessionParticipant failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	 END

	DECLARE @Index BIGINT, @SessionID BIGINT, @MaxIndex BIGINT
	SELECT @Index = 1
	SELECT @MaxIndex = MAX(ID) FROM #Session
	WHILE (@Index <=@MaxIndex)
	BEGIN
		SELECT @SessionID = SessionID FROM #Session WHERE ID=@Index
		EXEC @sql_error =  dbo.RemoveEvalSession @pSessionID=@SessionID, @sql_error_message=@sql_error_message OUTPUT
		IF @sql_error <> 0
		 BEGIN
			SELECT @sql_error_message = 'EXEC RemoveEvalSession failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
			GOTO ErrorHandler
		 END
		 
		 SELECT @Index = @Index + 1
	END

	DELETE dbo.SEPracticeSession
	 WHERE PracticeSessionID=@pPracticeSessionID
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	 BEGIN
		SELECT @sql_error_message = 'DELETE SEPracticeSession failed. In: ' + @ProcName + '. ' + '>>>' + ISNULL(@sql_error_message, '')
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


