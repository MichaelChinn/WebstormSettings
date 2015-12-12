if exists (select * from sysobjects 
where id = object_id('dbo.GetChildRubricRowsOfFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetChildRubricRowsOfFrameworkNode.'
      drop procedure dbo.GetChildRubricRowsOfFrameworkNode
   END
GO
PRINT '.. Creating sproc GetChildRubricRowsOfFrameworkNode.'
GO
CREATE PROCEDURE GetChildRubricRowsOfFrameworkNode
@pFrameworkNodeID bigint

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

	select * from vFrameworkNodeRubricRow
	where FrameworkNodeID = @pFrameworkNodeID
	order by sequence
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'problem getting child rubric rows of node' 

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
		+ 	' @pFrameworkNodeID =' + convert(varchar(50), isNull(@pFrameworkNodeID , '-1')) 
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

