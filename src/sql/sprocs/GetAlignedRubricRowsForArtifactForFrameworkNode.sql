if exists (select * from sysobjects 
where id = object_id('dbo.GetAlignedRubricRowsForArtifactForFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAlignedRubricRowsForArtifactForFrameworkNode.'
      drop procedure dbo.GetAlignedRubricRowsForArtifactForFrameworkNode
   END
GO
PRINT '.. Creating sproc GetAlignedRubricRowsForArtifactForFrameworkNode.'
GO

CREATE PROCEDURE dbo.GetAlignedRubricRowsForArtifactForFrameworkNode
	 @pFrameworkNodeID BIGINT
	,@pArtifactID BIGINT	
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


SELECT rr.*,fn.FrameworkNodeID
  FROM dbo.SEArtifactRubricRowAlignment arr
  JOIN dbo.vRubricRow rr ON arr.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 WHERE rr.IsStateAligned=1	
	AND arr.ArtifactID=@pArtifactID
	AND fn.FrameworkNodeID=@pFrameworkNodeID
   

	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'Problem selecting records.' 

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
		+ 	' @pFrameworkNodeID =' + convert(bigint, isNull(@pFrameworkNodeID , '')) 
		+ 	' | @pArtifactID =' + convert(bigint, isNull(@pArtifactID , '')) 		
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

