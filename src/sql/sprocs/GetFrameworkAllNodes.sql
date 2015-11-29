IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkAllNodes') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkAllNodes.'
      DROP PROCEDURE dbo.GetFrameworkAllNodes
   END
GO
PRINT '.. Creating sproc GetFrameworkAllNodes.'
GO

CREATE PROCEDURE dbo.GetFrameworkAllNodes
	@pFrameworkID BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vFrameworkNode
 WHERE FrameworkID=@pFrameworkID
 ORDER BY ParentNodeID, Sequence


