IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFrameworkById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFrameworkById.'
      DROP PROCEDURE dbo.GetFrameworkById
   END
GO
PRINT '.. Creating sproc GetFrameworkById.'
GO

CREATE PROCEDURE dbo.GetFrameworkById
	@pFrameworkID BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vFramework
 WHERE FrameworkID=@pFrameworkID

