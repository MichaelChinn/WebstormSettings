IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetFormById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetFormById'
      DROP PROCEDURE dbo.GetFormById
   END
GO
PRINT '.. Creating sproc GetFormById'
GO

CREATE PROCEDURE dbo.GetFormById
	@pFormId BIGINT
AS

SET NOCOUNT ON 
SELECT * 
  FROM dbo.vForm
 WHERE FormID=@pFormID

