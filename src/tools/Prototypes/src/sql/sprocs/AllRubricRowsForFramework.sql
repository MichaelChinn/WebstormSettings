if exists (select * from sysobjects 
where id = object_id('dbo.AllRubricRowsForFramework') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc AllRubricRowsForFramework.'
      drop procedure dbo.AllRubricRowsForFramework
   END
GO
PRINT '.. Creating sproc AllRubricRowsForFramework.'
GO
CREATE PROCEDURE AllRubricRowsForFramework
@pFrameworkId bigint

AS
SET NOCOUNT ON 



select fn.FrameworkNodeID as FNID, rr.* from SERubricRow rr
join SERubricRowFrameworkNode rrfn on rrfn.RubricRowID = rr.RubricRowID
join SEFrameworkNode fn on fn.FrameworkNodeID = rrfn.FrameworkNodeID
where fn.FrameworkID = @pFrameworkID
order by fn.FrameworkNodeID, rr.RubricRowID




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
	

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem inserting into COEStudent' 

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
		+ 	' @pFrameworkID =' + convert(varchar(50), isNull(@pFrameworkId , ''))
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

