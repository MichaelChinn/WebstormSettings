if exists (select * from sysobjects 
where id = object_id('dbo.GetChildRubricRowOfFrameworkNode') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetChildRubricRowOfFrameworkNode.'
      drop procedure dbo.GetChildRubricRowOfFrameworkNode
   END
GO
PRINT '.. Creating sproc GetChildRubricRowOfFrameworkNode.'
GO
CREATE PROCEDURE GetChildRubricRowOfFrameworkNode
	@pFrameworkNodeId bigint
	,@pRubricRowID bigint

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

/***********************************************************************************/
BEGIN
	SELECT * from vFrameworkNodeRubricRow 
	where RubricRowID = @pRubricRowId
		and FrameworkNodeId = @pFrameworkNodeID
END
/***********************************************************************************/

GO

