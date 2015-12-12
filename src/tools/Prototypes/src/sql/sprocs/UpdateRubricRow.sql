if exists (select * from sysobjects 
where id = object_id('dbo.UpdateRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateRubricRow.'
      drop procedure dbo.UpdateRubricRow
   END
GO
PRINT '.. Creating sproc UpdateRubricRow.'
GO
CREATE PROCEDURE UpdateRubricRow
@pRubricRowId bigint
, @pFrameworkNodeId bigint
, @pTitle varchar (256)
, @pDescription text
, @pPl1 text
, @pPl2 text
, @pPl3 text
, @pPl4 text
, @pSequence int

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

/***********************************************************************************/
BEGIN

	update dbo.SERubricRow set
		title = @pTitle 
		, Description= @pDescription 
		, Pl1Descriptor = @pPl1 
		, Pl2Descriptor = @pPl2 
		, Pl3Descriptor = @pPl3 
		, Pl4Descriptor = @pPl4
	where RubricRowId = @pRubricRowId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem updating rubric row' 

		  GOTO ErrorHandler
	   END

	update dbo.SERubricRowFrameworkNode set
		Sequence = @pSequence
	where RubricRowId = @pRubricRowId
		and FrameworkNodeID = @pFrameworkNodeId

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem updating rubric row' 

		  GOTO ErrorHandler
	   END


END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = '.... In: ' + @ProcName + '. ' + Convert(varchar(20), @sql_error) 
		+ '>>>' + ISNULL(@sql_error_message, '') + '<<<  '
		+ ' ... parameters...'
		+ ' @pRubricRow = ' + convert(varchar(10), isnull(@pRubricRowId, -1)) + '  |  '
		+ ' @pTitle       = ' + @pTitle         + '  |  '
		
		+   '<<<  '

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

