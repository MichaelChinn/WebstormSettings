IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkNodeById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkNodeById.'
      DROP PROCEDURE dbo.GetFrameworkNodeById
   END
GO
PRINT '.. Creating sproc GetFrameworkNodeById.'
GO

CREATE PROCEDURE dbo.GetFrameworkNodeById
	@pFrameworkNodeID BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vFrameworkNode
 WHERE FrameworkNodeID=@pFrameworkNodeID

