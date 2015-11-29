IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetResourceById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetResourceById.'
      DROP PROCEDURE dbo.GetResourceById
   END
GO
PRINT '.. Creating sproc GetResourceById.'
GO

CREATE PROCEDURE dbo.GetResourceById
	@pResourceId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vResource
 WHERE ResourceID=@pResourceID

