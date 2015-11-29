if exists (select * from sysobjects 
where id = object_id('dbo.InsertRubricRow') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertRubricRow.'
      drop procedure dbo.InsertRubricRow
   END
GO
PRINT '.. Creating sproc InsertRubricRow.'
GO
CREATE PROCEDURE InsertRubricRow
 @pTitle varchar (256)
, @pDescription text
, @pPl1 text
, @pPl2 text
, @pPl3 text
, @pPl4 text
, @pFrameworkNodeID bigint
, @pSequence int = 0

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
	INSERT dbo.SERubricRow (title, description, pl1Descriptor, pl2Descriptor, pl3Descriptor, pl4Descriptor)
	values ( @pTitle ,  @pDescription ,  @pPl1 ,  @pPl2 ,  @pPl3 ,  @pPl4 )


	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting rubric row' 

		  GOTO ErrorHandler
	   END
	
	DECLARE @id bigint
	SELECT @id=SCOPE_IDENTITY()

	If (@pFrameworkNodeID <> 0)
	BEGIN
		INSERT dbo.SERubricRowFrameworkNode (FrameworkNodeId, RubricRowID, Sequence)
		VALUES (@pFrameworkNodeID, @id, @pSequence)

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Problem inserting rubricrow-frameworknode link' 

			  GOTO ErrorHandler
		   END

	END


	SELECT * from vFrameworkNodeRubricRow where RubricRowID = @id

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

